import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/theme/theme_cubit.dart';
import 'package:motivation_app/core/widgets/home_widget_service.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_seed.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  final local = di.sl<AffirmationLocalDataSource>();
  await seedAffirmationsIfEmpty(local);
  di.sl<AffirmationRepository>().weeklyRefreshInBackground();

  // Charge le profil et détermine l'écran de départ
  final onboardingCubit = di.sl<OnboardingCubit>();
  await onboardingCubit.loadUserProfile();

  final profile = switch (onboardingCubit.state) {
    OnboardingProfileLoaded(:final profile) => profile,
    OnboardingDataSaved(:final profile) => profile,
    _ => null,
  };
  final isDone = profile?.name != null;
  final initialLocation = isDone ? AppRouter.affirmation : AppRouter.home;

  final router = createAppRouter(initialLocation: initialLocation);

  // Initialise le service de widgets iOS
  await HomeWidgetService.init();

  // Charge la préférence de thème
  final themeCubit = ThemeCubit(di.sl<SecureStorage>());
  await themeCubit.load();

  runApp(MyApp(
    router: router,
    onboardingCubit: onboardingCubit,
    themeCubit: themeCubit,
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  final OnboardingCubit onboardingCubit;
  final ThemeCubit themeCubit;

  const MyApp({
    super.key,
    required this.router,
    required this.onboardingCubit,
    required this.themeCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: 'Motivation App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
