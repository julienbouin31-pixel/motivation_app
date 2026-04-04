import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.rocket_launch,
        color: colors.scaffold,
        size: 28,
      ),
    );
  }
}
