import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_question_page.dart';

class OnboardingStrugglePage extends StatelessWidget {
  const OnboardingStrugglePage({super.key});

  static const _map = {
    'La procrastination': 'procrastination',
    'Le doute': 'doute',
    'Le stress': 'stress',
    'Le manque d\'énergie': 'energie',
    'La régularité': 'regularite',
    'Un peu tout ça': 'tout',
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestionPage(
      route: AppRouter.onboardingStruggle,
      title: 'qu\'est-ce qui t\'empêche\nd\'avancer, en ce moment ?',
      onSelected: (label) =>
          context.read<OnboardingCubit>().saveStruggle(_map[label] ?? 'tout'),
      options: const [
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
