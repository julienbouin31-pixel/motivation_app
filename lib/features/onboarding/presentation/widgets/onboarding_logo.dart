import 'package:flutter/material.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.rocket_launch,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
