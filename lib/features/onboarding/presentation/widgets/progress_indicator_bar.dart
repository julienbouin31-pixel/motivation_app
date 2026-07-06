import 'package:flutter/material.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_style.dart';

/// Marqueur d'étape textuel — remplace la barre de progression générique.
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
    return Row(
      children: [
        Text('étape $currentStep sur $totalSteps', style: OnbStyle.overline),
        const SizedBox(width: 14),
        const Expanded(child: Divider(color: OnbStyle.hairline, height: 1)),
      ],
    );
  }
}
