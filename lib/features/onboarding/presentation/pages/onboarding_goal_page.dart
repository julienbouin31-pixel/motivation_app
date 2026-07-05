import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

const _goals = [
  (
    icon: Icons.diamond_outlined,
    label: 'Confiance en soi',
    sub: 'Croire en tes capacités',
    accent: Color(0xFFD4C27F),
  ),
  (
    icon: Icons.water_drop_outlined,
    label: 'Réduire le stress',
    sub: 'Retrouver la paix intérieure',
    accent: Color(0xFF86BBD8),
  ),
  (
    icon: Icons.lens_blur,
    label: 'Rester focalisé(e)',
    sub: "Concentre-toi sur l'essentiel",
    accent: Color(0xFF7CB8A9),
  ),
  (
    icon: Icons.trending_up_rounded,
    label: 'État d\'esprit',
    sub: 'Cultiver la croissance',
    accent: Color(0xFFB19CD9),
  ),
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
                      'Quel est ton\nobjectif principal ?',
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
                    'Tes affirmations seront centrées sur cet objectif.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.4),
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Cartes objectifs ───────────────────────────────────────
                Expanded(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 180),
                    child: Column(
                      children: _goals.map((g) {
                        final selected = _selected == g.label;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = g.label),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? g.accent.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? g.accent.withValues(alpha: 0.55)
                                      : Colors.white.withValues(alpha: 0.07),
                                  width: selected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? g.accent.withValues(alpha: 0.2)
                                          : Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      g.icon,
                                      size: 20,
                                      color: selected ? g.accent : Colors.white.withValues(alpha: 0.55),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          g.label,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          g.sub,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: selected
                                                ? g.accent.withValues(alpha: 0.8)
                                                : Colors.white.withValues(alpha: 0.35),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: selected
                                        ? Container(
                                            key: const ValueKey('check'),
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: g.accent.withValues(alpha: 0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.check_rounded, size: 12, color: g.accent),
                                          )
                                        : const SizedBox(key: ValueKey('empty'), width: 20, height: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ── CTA ────────────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 260),
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
      ),
    );
  }
}
