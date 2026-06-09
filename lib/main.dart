import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/analytics/activity_logger.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';
import 'package:motivation_app/core/sync/one_time_migration.dart';
import 'package:motivation_app/core/sync/sync_service.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/widgets/home_widget_service.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await initSupabase();
  await ensureAnonymousSession();

  await di.init();

  final local = di.sl<AffirmationLocalDataSource>();
  final repo = di.sl<AffirmationRepository>();
  final affirmationCount = await local.totalCount();
  if (affirmationCount == 0) {
    await repo.weeklyRefreshInBackground();
  } else {
    unawaited(repo.weeklyRefreshInBackground());
  }

  await di.sl<OneTimeMigration>().runIfNeeded();
  await di.sl<ActivityLogger>().log(ActivityEvent.appOpen);
  unawaited(di.sl<SyncService>().kick());

  final onboardingCubit = di.sl<OnboardingCubit>();
  await onboardingCubit.loadUserProfile();

  final profile = switch (onboardingCubit.state) {
    OnboardingProfileLoaded(:final profile) => profile,
    OnboardingDataSaved(:final profile) => profile,
    _ => null,
  };
  final storage = di.sl<SecureStorage>();

  final isDone = profile?.name?.isNotEmpty == true;
  final initialLocation = isDone ? AppRouter.affirmation : AppRouter.home;

  final router = createAppRouter(initialLocation: initialLocation);

  await NotificationService.init();
  if (await storage.readNotificationEnabled()) {
    final rawTexts = await local.getAllTexts();
    final userName = profile?.name ?? '';
    final resolved = rawTexts
        .map((t) => t.replaceAll('{name}', userName))
        .toList()
      ..shuffle();
    await NotificationService.schedule(
      affirmations: resolved,
      frequency: await storage.readNotificationFrequency(),
      startHour: await storage.readNotificationStartHour(),
      endHour: await storage.readNotificationEndHour(),
    );
  }

  await HomeWidgetService.init();

  final cardThemeCubit = CardThemeCubit(di.sl<SecureStorage>());
  await cardThemeCubit.load();

  final streakCubit = di.sl<StreakCubit>();
  await streakCubit.load();

  runApp(MyApp(
    router: router,
    onboardingCubit: onboardingCubit,
    cardThemeCubit: cardThemeCubit,
    streakCubit: streakCubit,
  ));
}

class MyApp extends StatefulWidget {
  final GoRouter router;
  final OnboardingCubit onboardingCubit;
  final CardThemeCubit cardThemeCubit;
  final StreakCubit streakCubit;

  const MyApp({
    super.key,
    required this.router,
    required this.onboardingCubit,
    required this.cardThemeCubit,
    required this.streakCubit,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.onboardingCubit),
        BlocProvider.value(value: widget.cardThemeCubit),
        BlocProvider.value(value: widget.streakCubit),
      ],
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listenWhen: (prev, next) =>
            prev is! OnboardingDataSaved && next is OnboardingDataSaved,
        listener: (context, state) => widget.streakCubit.load(),
        child: MaterialApp.router(
          title: 'Motivation App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: widget.router,
        ),
      ),
    );
  }
}
