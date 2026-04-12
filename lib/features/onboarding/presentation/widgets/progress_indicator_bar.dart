import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class ProgressIndicatorBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return LinearProgressIndicator(
      value: currentStep / totalSteps,
      backgroundColor: colors.border,
      valueColor: AlwaysStoppedAnimation(colors.primary),
      minHeight: 3,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
