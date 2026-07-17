import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingBeliefPage extends StatelessWidget {
  const OnboardingBeliefPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingQuestionPage(
      route: AppRouter.onboardingBelief,
      title: 'crois-tu que tes pensées\nfaçonnent ta réalité ?',
      options: [
        (label: 'Oui, je l\'ai déjà vécu', sub: null),
        (label: 'Je suis ouvert(e) à l\'idée', sub: null),
        (label: 'Pas vraiment, mais on verra', sub: null),
      ],
    );
  }
}
