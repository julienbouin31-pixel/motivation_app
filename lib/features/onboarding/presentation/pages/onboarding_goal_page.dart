import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

// Libellés conservés tels quels : ils sont enregistrés dans le profil.
const _goals = [
  (label: 'Confiance en soi', sub: 'Croire en tes capacités'),
  (label: 'Réduire le stress', sub: 'Retrouver la paix intérieure'),
  (label: 'Rester focalisé(e)', sub: "Te concentrer sur l'essentiel"),
  (label: 'État d\'esprit', sub: 'Cultiver la croissance'),
];

class OnboardingGoalPage extends StatefulWidget {
  const OnboardingGoalPage({super.key});

  @override
  State<OnboardingGoalPage> createState() => _OnboardingGoalPageState();
}

class _OnboardingGoalPageState extends State<OnboardingGoalPage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(AppRouter.onboardingGoal);

    return Scaffold(
      backgroundColor: OnbStyle.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                duration: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(),
                    ),
                    const SizedBox(height: 18),
                    ProgressIndicatorBar(
                      currentStep: progress.step,
                      totalSteps: progress.total,
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'sur quoi veux-tu\ntravailler en premier ?',
                      style: OnbStyle.display(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tes affirmations seront écrites autour de ça.',
                      style: OnbStyle.body,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Column(
                  children: [
                    for (final (i, goal) in _goals.indexed)
                      FadeSlideIn(
                        delay: Duration(milliseconds: 250 + i * 70),
                        duration: const Duration(milliseconds: 500),
                        child: OnbSelectableRow(
                          label: goal.label,
                          sublabel: goal.sub,
                          selected: _selected == goal.label,
                          onTap: () => setState(() => _selected = goal.label),
                        ),
                      ),
                  ],
                ),
              ),

              FadeSlideIn(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: ContinueButton(
                  enabled: _selected != null,
                  onPressed: _selected == null
                      ? null
                      : () {
                          context.read<OnboardingCubit>().saveGoal(_selected!);
                          OnboardingFlow.next(context, AppRouter.onboardingGoal);
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
