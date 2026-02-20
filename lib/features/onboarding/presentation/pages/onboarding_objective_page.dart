import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_logo.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/objective_option_card.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';

class OnboardingObjectivePage extends StatelessWidget {
  const OnboardingObjectivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const OnboardingLogo(),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 24),
                ProgressIndicatorBar(
                  currentStep: OnboardingFlow.stepNumber(AppRouter.onboardingObjective),
                  totalSteps: OnboardingFlow.totalSteps,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 6),
                      Text(
                        'Retour',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.gps_fixed_outlined, size: 26, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Quel type d\'objectif ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choisis ce que tu veux tracker. On adaptera l\'app à ton besoin.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 28),
                ObjectiveOptionCard(
                  icon: Icons.trending_up,
                  iconBgColor: const Color(0xFFE8F5E9),
                  title: 'Revenu (MRR)',
                  description: 'Suivi de ton revenu mensuel récurrent',
                  connectLabel: 'Connecte Stripe',
                  onTap: () {
                    context.read<OnboardingCubit>().saveObjectiveType('mrr');
                    context.push(AppRouter.onboardingStripe);
                  },
                ),
                ObjectiveOptionCard(
                  icon: Icons.bar_chart,
                  iconBgColor: const Color(0xFFE3F2FD),
                  title: 'Analytics',
                  description: 'Suivi des visites et métriques de ton site',
                  connectLabel: 'Connecte Google Analytics',
                  onTap: () {
                    context.read<OnboardingCubit>().saveObjectiveType('analytics');
                    OnboardingFlow.next(context, AppRouter.onboardingObjective);
                  },
                ),
                ObjectiveOptionCard(
                  icon: Icons.block,
                  iconBgColor: const Color(0xFFF5F5F5),
                  iconColor: Colors.black54,
                  title: 'Pas d\'objectif',
                  description: 'Je veux juste les affirmations',
                  onTap: () {
                    context.read<OnboardingCubit>().saveObjectiveType('none');
                    OnboardingFlow.next(context, AppRouter.onboardingObjective);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
