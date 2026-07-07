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
            const TextSpan(text: 'la répétition\n'),
            TextSpan(
              text: 'reprogramme',
              style: AppStyle.displayItalic(size: 36),
            ),
            const TextSpan(text: '\nton cerveau.'),
          ],
        ),
      ),
      body: 'C\'est la neuroplasticité : ce que tu te répètes '
          'chaque matin finit par devenir ta façon de penser.\n'
          'C\'est exactement ce qu\'on va faire ensemble.',
    );
  }
}
