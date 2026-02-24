import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';

/// Defines the linear onboarding step order.
/// To reorder: move a line.
/// To skip a step: comment it out.
/// To add a step: add a line + create the page + add route in AppRouter.
class OnboardingFlow {
  static const List<String> steps = [
    AppRouter.onboardingName,
    AppRouter.onboardingTransition,
    AppRouter.onboardingObjective,
    AppRouter.onboardingAge,
    AppRouter.onboardingStripe,
    AppRouter.onboardingStripeConnected,
    AppRouter.onboardingMrrTarget,
  ];

  /// Navigate to the next step, or to the main app if it was the last step.
  static void next(BuildContext context, String currentRoute) {
    final index = steps.indexOf(currentRoute);
    if (index >= 0 && index < steps.length - 1) {
      context.push(steps[index + 1]);
    } else {
      context.go(AppRouter.affirmation);
    }
  }

  /// 1-based step number for the progress bar.
  static int stepNumber(String route) => steps.indexOf(route) + 1;

  /// Total number of linear steps.
  static int get totalSteps => steps.length;
}
