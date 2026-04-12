import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_logo.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/injection_container.dart' as di;

class OnboardingMrrTargetPage extends StatefulWidget {
  const OnboardingMrrTargetPage({super.key});

  @override
  State<OnboardingMrrTargetPage> createState() => _OnboardingMrrTargetPageState();
}

class _OnboardingMrrTargetPageState extends State<OnboardingMrrTargetPage> {
  String? _selectedTarget;

  static const _targets = [
    (amount: '1K€', label: 'Premier palier'),
    (amount: '5K€', label: 'Quitter le CDI'),
    (amount: '10K€', label: 'Liberté financière'),
    (amount: '25K€', label: 'Scale mode'),
    (amount: '50K€+', label: 'Empire builder'),
  ];

  Widget _backLink(BuildContext context, String label, VoidCallback onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 16, color: colors.secondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: colors.secondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
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
                currentStep: OnboardingFlow.stepNumber(AppRouter.onboardingMrrTarget),
                totalSteps: OnboardingFlow.totalSteps,
              ),
              const SizedBox(height: 20),
              _backLink(context, 'Retour', () => context.pop()),
              const SizedBox(height: 8),
              _backLink(context, 'Modifier la connexion', () => context.pop()),
              const SizedBox(height: 32),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.trending_up, size: 26, color: colors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                'Ton objectif MRR ?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'On adaptera les affirmations à ton niveau d\'ambition.',
                style: TextStyle(fontSize: 13, color: colors.secondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Stripe connecté • Acme SaaS Inc.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _targets.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final target = _targets[index];
                    final isSelected = _selectedTarget == target.amount;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTarget = target.amount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? colors.primary : colors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              target.amount,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '/mois',
                              style: TextStyle(fontSize: 14, color: colors.secondary),
                            ),
                            const Spacer(),
                            Text(
                              target.label,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? colors.primary : colors.secondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              ContinueButton(
                enabled: _selectedTarget != null,
                onPressed: _selectedTarget != null
                    ? () async {
                        await context.read<OnboardingCubit>().saveMrrTarget(_selectedTarget!);
                        await di.sl<SecureStorage>().setOnboardingDone();
                        if (context.mounted) {
                          OnboardingFlow.next(context, AppRouter.onboardingMrrTarget);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
