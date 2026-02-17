import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_header.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:motivation_app/features/home/presentation/widgets/feature_card.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_cta_button.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 16),
            const HomeHeroSection(),
            const SizedBox(height: 24),
            const FeatureCard(
              icon: Icons.flash_on,
              title: 'Mindset quotidien',
              description: 'Des affirmations pour booster ton énergie de maker',
            ),
            const FeatureCard(
              icon: Icons.notifications_outlined,
              title: 'Rappels intelligents',
              description: 'Choisis quand recevoir ton boost motivation',
            ),
            const FeatureCard(
              icon: Icons.favorite_border,
              title: 'Tes favoris',
              description: 'Sauvegarde les citations qui te parlent vraiment',
            ),
            const Spacer(),
            HomeCtaButton(
              onPressed: () {
                context.push(AppRouter.onboardingName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
