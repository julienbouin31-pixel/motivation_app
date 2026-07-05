import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

const _moods = [
  (emoji: '😰', label: 'Stressé(e)'),
  (emoji: '😴', label: 'Fatigué(e)'),
  (emoji: '😔', label: 'Découragé(e)'),
  (emoji: '🤔', label: 'Perdu(e)'),
  (emoji: '😊', label: 'Bien'),
  (emoji: '🎯', label: 'Focalisé(e)'),
  (emoji: '💪', label: 'Motivé(e)'),
  (emoji: '🔥', label: 'En feu'),
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
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                FadeSlideIn(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: BackButtonWidget(),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 40),
                  child: ProgressIndicatorBar(
                    currentStep: progress.step,
                    totalSteps: progress.total,
                  ),
                ),
                const SizedBox(height: 40),

                // ── Titre ──────────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFD3D3D3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'Comment tu te sens\nen ce moment ?',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 140),
                  child: Text(
                    'On adapte tes affirmations à ton état du moment.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.4),
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Grille de moods ────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 180),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _moods.map((m) {
                      final selected = _selected == m.label;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = m.label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.08),
                              width: selected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.emoji, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(
                                m.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                  color: selected ? Colors.white : Colors.white.withValues(alpha: 0.65),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Spacer(),

                // ── CTA ────────────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 260),
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
      ),
    );
  }
}
