import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

// Libellés conservés tels quels : ils sont enregistrés dans le profil.
const _moods = [
  'Stressé(e)',
  'Fatigué(e)',
  'Découragé(e)',
  'Perdu(e)',
  'Bien',
  'Focalisé(e)',
  'Motivé(e)',
  'En feu',
];

class OnboardingMoodPage extends StatefulWidget {
  const OnboardingMoodPage({super.key});

  @override
  State<OnboardingMoodPage> createState() => _OnboardingMoodPageState();
}

class _OnboardingMoodPageState extends State<OnboardingMoodPage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(AppRouter.onboardingMood);

    return Scaffold(
      backgroundColor: AppStyle.bg,
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
                      'comment tu te sens,\nlà, maintenant ?',
                      style: AppStyle.display(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Réponds sans réfléchir — on part de là.',
                      style: AppStyle.body,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final (i, mood) in _moods.indexed)
                        FadeSlideIn(
                          delay: Duration(milliseconds: 250 + i * 55),
                          duration: const Duration(milliseconds: 500),
                          child: SelectableRow(
                            label: mood,
                            selected: _selected == mood,
                            onTap: () => setState(() => _selected = mood),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FadeSlideIn(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: ContinueButton(
                  enabled: _selected != null,
                  onPressed: _selected == null
                      ? null
                      : () {
                          context.read<OnboardingCubit>().saveMood(_selected!);
                          OnboardingFlow.next(context, AppRouter.onboardingMood);
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
