import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingMoodSourcePage extends StatelessWidget {
  const OnboardingMoodSourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingQuestionPage(
      route: AppRouter.onboardingMoodSource,
      title: 'qu\'est-ce qui pèse\nle plus en ce moment ?',
      subtitle: 'Pour te parler de ce qui compte vraiment.',
      options: [
        (label: 'Le travail', sub: null),
        (label: 'La famille', sub: null),
        (label: 'Les relations', sub: null),
        (label: 'La santé', sub: null),
        (label: 'L\'argent', sub: null),
        (label: 'Rien de précis', sub: null),
      ],
    );
  }
}
