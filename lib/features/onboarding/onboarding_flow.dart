import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class OnboardingFlow {
  // Chemin commun + analytics/none
  static const List<String> _defaultSteps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingObjective,
    AppRouter.onboardingAge,
    AppRouter.onboardingNotifications,
  ];

  // Chemin MRR (pas d'age, mais stripe + target)
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

  /// Retourne (step, total) selon si la route est dans le chemin MRR ou non.
  static ({int step, int total}) progress(String route, {bool isMrr = false}) {
    final list = isMrr ? _mrrSteps : _defaultSteps;
    final idx = list.indexOf(route);
    if (idx < 0) {
      // Fallback pour les pages hors liste (stripe sur chemin non-MRR, etc.)
      return (step: 1, total: _defaultSteps.length);
    }
    return (step: idx + 1, total: list.length);
  }

  // Compat pour les pages qui n'ont pas encore accès au cubit
  static int stepNumber(String route) => steps.indexOf(route) + 1;
  static int get totalSteps => steps.length;
}
