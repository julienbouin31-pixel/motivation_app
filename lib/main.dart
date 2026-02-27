import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_seed.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  // Précharge le flag onboardingDone depuis le secure storage (lecture unique)
  await di.sl<SecureStorage>().preloadCache();

  final local = di.sl<AffirmationLocalDataSource>();

  // Peuple la DB localement avant runApp → pas de spinner au premier lancement
  await seedAffirmationsIfEmpty(local);

  // Refresh hebdomadaire en arrière-plan — non awaité
  di.sl<AffirmationRepository>().weeklyRefreshInBackground();

  final onboardingDone = di.sl<SecureStorage>().cachedOnboardingDone;
  final router = createAppRouter(onboardingDone: onboardingDone);

  // OnboardingCubit global — profil pré-chargé avant runApp pour un premier rendu correct
  final onboardingCubit = di.sl<OnboardingCubit>();
  await onboardingCubit.loadUserProfile();

  runApp(MyApp(router: router, onboardingCubit: onboardingCubit));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  final OnboardingCubit onboardingCubit;

  const MyApp({super.key, required this.router, required this.onboardingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: onboardingCubit,
      child: MaterialApp.router(
        title: 'Motivation App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
