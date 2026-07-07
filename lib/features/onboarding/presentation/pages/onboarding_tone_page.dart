import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingTonePage extends StatelessWidget {
  const OnboardingTonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingQuestionPage(
      route: AppRouter.onboardingTone,
      title: 'quel ton te parle\nle plus ?',
      subtitle: 'On ajustera l\'écriture de tes affirmations.',
      options: [
        (label: 'Direct, sans détour', sub: '« Lève-toi et avance. »'),
        (label: 'Doux et bienveillant', sub: '« Tu as le droit d\'aller à ton rythme. »'),
        (label: 'Poétique', sub: '« Chaque matin est une page blanche. »'),
        (label: 'Court et percutant', sub: '« Un pas. Maintenant. »'),
      ],
    );
  }
}
