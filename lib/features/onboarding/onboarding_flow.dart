import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class OnboardingFlow {
  static const List<String> steps = [
    AppRouter.onboardingWelcome,
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingMood,
    AppRouter.onboardingMoodSource,
    AppRouter.onboardingBelief,
    AppRouter.onboardingScience,
    AppRouter.onboardingGoal,
    AppRouter.onboardingStruggle,
    AppRouter.onboardingTone,
    AppRouter.onboardingPreview,
    AppRouter.onboardingTheme,
    AppRouter.onboardingStreak,
    AppRouter.onboardingNotifications,
    AppRouter.onboardingReady,
  ];

  static void next(BuildContext context, String currentRoute) {
    final index = steps.indexOf(currentRoute);
    if (index >= 0 && index < steps.length - 1) {
      context.push(steps[index + 1]);
    } else {
      // Fin de l'onboarding : on présente le paywall une fois (soft, avec une
      // croix pour passer), qui mène ensuite à l'app.
      context.go('${AppRouter.paywall}?from=onboarding');
    }
  }

  static ({int step, int total}) progress(String route) {
    final idx = steps.indexOf(route);
    if (idx < 0) return (step: 1, total: steps.length);
    return (step: idx + 1, total: steps.length);
  }

  static int stepNumber(String route) => steps.indexOf(route) + 1;
  static int get totalSteps => steps.length;
}
