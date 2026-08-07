import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingMoodSourcePage extends StatelessWidget {
  const OnboardingMoodSourcePage({super.key});

  static const _map = {
    'Le travail': 'travail',
    'La famille': 'famille',
    'Les relations': 'relations',
    'La santé': 'sante',
    'L\'argent': 'argent',
    'Rien de précis': '',
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestionPage(
      route: AppRouter.onboardingMoodSource,
      title: 'qu\'est-ce qui pèse\nle plus en ce moment ?',
      subtitle: 'Pour te parler de ce qui compte vraiment.',
      onSelected: (label) =>
          context.read<OnboardingCubit>().saveLifeArea(_map[label] ?? ''),
      options: const [
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
