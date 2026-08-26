import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
import 'package:motivation_app/core/purchases/purchases_service.dart';
import 'package:motivation_app/core/purchases/subscription_cubit.dart';
import 'package:motivation_app/core/widgets/home_widget_service.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final sentryDsn = dotenv.env['SENTRY_DSN'];
  if (sentryDsn != null && sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.tracesSampleRate = 0.0;
      },
      appRunner: _bootstrap,
    );
  } else {
    await _bootstrap();
  }
}

Future<void> _bootstrap() async {
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

  await HomeWidgetService.init();

  // Ouvre l'affirmation précise si l'app a été lancée à froid depuis une notif
  // ou depuis un tap sur le widget.
  final launchPayload = await NotificationService.init();
  final launchId = int.tryParse(launchPayload ?? '') ??
      HomeWidgetService.affirmationIdFrom(
          await HomeWidgetService.initiallyLaunched());

  var initialLocation = isDone ? AppRouter.affirmation : AppRouter.onboardingWelcome;
  if (isDone && launchId != null) {
    initialLocation = '${AppRouter.affirmation}?id=$launchId';
  }

  final router = createAppRouter(initialLocation: initialLocation);

  // Tap sur une notif pendant que l'app tourne déjà (foreground/background).
  NotificationService.onNotificationTap.listen((payload) {
    final id = int.tryParse(payload);
    if (id != null) {
      router.go('${AppRouter.affirmation}?id=$id');
    }
  });

  // Tap sur le widget pendant que l'app tourne déjà.
  HomeWidgetService.clicks.listen((uri) {
    final id = HomeWidgetService.affirmationIdFrom(uri);
    if (id != null) {
      router.go('${AppRouter.affirmation}?id=$id');
    }
  });

  if (await storage.readNotificationEnabled()) {
    final rawEntries = await local.getAllWithIds();
    final userName = profile?.name ?? '';
    final resolved = rawEntries
        .map((e) => (e.$1, e.$2.replaceAll('{name}', userName)))
        .toList()
      ..shuffle();
    await NotificationService.schedule(
      affirmations: resolved,
      frequency: await storage.readNotificationFrequency(),
      startHour: await storage.readNotificationStartHour(),
      endHour: await storage.readNotificationEndHour(),
    );
  }

  await _pushWidgetPool(local, profile?.name ?? '');

  await PurchasesService.init();
  final subscriptionCubit = SubscriptionCubit();
  await subscriptionCubit.load();

  final cardThemeCubit = CardThemeCubit(di.sl<SecureStorage>());
  await cardThemeCubit.load();

  final streakCubit = di.sl<StreakCubit>();
  await streakCubit.load();
  await HomeWidgetService.updateStreak(streakCubit.state);

  runApp(MyApp(
    router: router,
    onboardingCubit: onboardingCubit,
    cardThemeCubit: cardThemeCubit,
    streakCubit: streakCubit,
    subscriptionCubit: subscriptionCubit,
  ));
}

/// Pousse le réservoir d'affirmations (résolues + catégorie en clair) vers le
/// widget, qui pioche dedans tout seul pour tourner plusieurs fois par jour.
Future<void> _pushWidgetPool(
    AffirmationLocalDataSource local, String userName) async {
  final rows = await local.getAllForWidget();
  if (rows.isEmpty) return;
  final pool = rows.map((r) {
    final text = r.$2.replaceAll('{name}', userName);
    String label;
    try {
      label = AffirmationCategory.values.byName(r.$3).label.toLowerCase();
    } catch (_) {
      label = r.$3.toLowerCase();
    }
    return {'id': '${r.$1}', 'text': text, 'category': label};
  }).toList()
    ..shuffle();
  await HomeWidgetService.updatePool(pool);
}

class MyApp extends StatefulWidget {
  final GoRouter router;
  final OnboardingCubit onboardingCubit;
  final CardThemeCubit cardThemeCubit;
  final StreakCubit streakCubit;
  final SubscriptionCubit subscriptionCubit;

  const MyApp({
    super.key,
    required this.router,
    required this.onboardingCubit,
    required this.cardThemeCubit,
    required this.streakCubit,
    required this.subscriptionCubit,
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
        BlocProvider.value(value: widget.subscriptionCubit),
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
