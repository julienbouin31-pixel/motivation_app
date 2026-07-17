import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingStrugglePage extends StatelessWidget {
  const OnboardingStrugglePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingQuestionPage(
      route: AppRouter.onboardingStruggle,
      title: 'qu\'est-ce qui t\'empêche\nd\'avancer, en ce moment ?',
      options: [
        (label: 'La procrastination', sub: null),
        (label: 'Le doute', sub: null),
        (label: 'Le stress', sub: null),
        (label: 'Le manque d\'énergie', sub: null),
        (label: 'La régularité', sub: null),
        (label: 'Un peu tout ça', sub: null),
      ],
    );
  }
}
