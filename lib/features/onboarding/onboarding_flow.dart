import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class OnboardingFlow {
  // Chemin sans objectif
  static const List<String> _defaultSteps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingObjective,
    AppRouter.onboardingAge,
    AppRouter.onboardingNotifications,
  ];

  // Chemin MRR (stripe + target)
  static const List<String> _mrrSteps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingObjective,
    AppRouter.onboardingStripe,
    AppRouter.onboardingStripeConnected,
    AppRouter.onboardingMrrTarget,
    AppRouter.onboardingNotifications,
  ];

  // Liste complète pour le routing next()
  static const List<String> steps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingObjective,
    AppRouter.onboardingAge,
    AppRouter.onboardingStripe,
    AppRouter.onboardingStripeConnected,
    AppRouter.onboardingMrrTarget,
    AppRouter.onboardingNotifications,
  ];

  static void next(BuildContext context, String currentRoute) {
    final index = steps.indexOf(currentRoute);
    if (index >= 0 && index < steps.length - 1) {
      context.push(steps[index + 1]);
    } else {
      context.go(AppRouter.affirmation);
    }
  }

  static ({int step, int total}) progress(String route, {bool isMrr = false}) {
    final list = isMrr ? _mrrSteps : _defaultSteps;
    final idx = list.indexOf(route);
    if (idx < 0) return (step: 1, total: _defaultSteps.length);
    return (step: idx + 1, total: list.length);
  }

  static int stepNumber(String route) => steps.indexOf(route) + 1;
  static int get totalSteps => steps.length;
}
