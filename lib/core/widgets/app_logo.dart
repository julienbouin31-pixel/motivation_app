import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;

  const AppLogo({super.key, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      'curves',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: colors.primary,
        letterSpacing: -0.3,
      ),
    );
  }
}
