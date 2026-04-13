import 'package:flutter/material.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_motivation_app_canvas.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
