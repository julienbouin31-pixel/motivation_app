import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_style.dart';

/// Progression silencieuse : un simple filet qui se remplit, sans chiffres —
/// l'utilisateur sent qu'il avance sans jamais voir "étape 3 sur 15".
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
    return SizedBox(
      height: 2,
      child: Stack(
        children: [
          Container(color: AppStyle.hairline),
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            alignment: Alignment.centerLeft,
            widthFactor: (currentStep / totalSteps).clamp(0.0, 1.0),
            child: Container(color: AppStyle.ink.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }
}
