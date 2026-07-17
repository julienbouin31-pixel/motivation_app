import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_message_page.dart';

class OnboardingSciencePage extends StatelessWidget {
  const OnboardingSciencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingMessagePage(
      route: AppRouter.onboardingScience,
      title: Text.rich(
        TextSpan(
          style: AppStyle.display(size: 36),
          children: [
            const TextSpan(text: 'ce que tu te répètes\nfinit par devenir '),
            TextSpan(
              text: 'vrai',
              style: AppStyle.displayItalic(size: 36),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
      body: 'Rien de magique : ce que tu lis le matin colore ta journée.\n'
          'Autant choisir des mots qui te font du bien.',
    );
  }
}
