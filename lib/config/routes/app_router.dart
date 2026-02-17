import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/home/presentation/pages/home_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_name_page.dart';
import 'package:motivation_app/features/onboarding/presentation/pages/onboarding_age_page.dart';
import 'package:motivation_app/features/affirmation/presentation/pages/affirmation_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const String home = '/';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingAge = '/onboarding/age';
  static const String affirmation = '/affirmation';
  static const String revenue = '/revenue';
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRouter.home,
  routes: [
    GoRoute(
      path: AppRouter.home,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HomePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingName,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingNamePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.onboardingAge,
      pageBuilder: (context, state) => const MaterialPage(
        child: OnboardingAgePage(),
      ),
    ),
    GoRoute(
      path: AppRouter.affirmation,
      pageBuilder: (context, state) {
        final userName = state.extra as String? ?? 'Julien';
        return NoTransitionPage(
          child: AffirmationPage(userName: userName),
        );
      },
    ),
  ],
);
