import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class OnboardingFlow {
  static const List<String> steps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingAge,
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

  static ({int step, int total}) progress(String route) {
    final idx = steps.indexOf(route);
    if (idx < 0) return (step: 1, total: steps.length);
    return (step: idx + 1, total: steps.length);
  }

  static int stepNumber(String route) => steps.indexOf(route) + 1;
  static int get totalSteps => steps.length;
}
