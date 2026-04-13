import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_cta_button.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Image.asset(
                'assets/images/logo_cropped.png',
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            const HomeHeroSection(),
            const Spacer(),
            HomeCtaButton(
              onPressed: () => context.push(AppRouter.onboardingName),
            ),
          ],
        ),
      ),
    );
  }
}
