import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_style.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnbStyle.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // ── Logo ───────────────────────────────────────────────────
              FadeSlideIn(
                duration: const Duration(milliseconds: 700),
                child: Image.asset(
                  'assets/images/logo_cropped.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 44),

              // ── Énoncé ─────────────────────────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 250),
                duration: const Duration(milliseconds: 700),
                child: Text.rich(
                  TextSpan(
                    style: OnbStyle.display(size: 40),
                    children: [
                      const TextSpan(text: 'un mot '),
                      TextSpan(
                          text: 'juste',
                          style: OnbStyle.displayItalic(size: 40)),
                      const TextSpan(text: ',\nchaque matin.'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const AnimatedHairline(
                delay: Duration(milliseconds: 550),
                duration: Duration(milliseconds: 900),
              ),

              const SizedBox(height: 24),

              FadeSlideIn(
                delay: const Duration(milliseconds: 650),
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'Des affirmations écrites pour toi,\nà lire en trente secondes avec ton café.',
                  style: OnbStyle.body,
                ),
              ),

              const Spacer(flex: 3),

              // ── CTA ────────────────────────────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 950),
                duration: const Duration(milliseconds: 600),
                child: ContinueButton(
                  label: 'commencer',
                  onPressed: () =>
                      OnboardingFlow.next(context, AppRouter.onboardingWelcome),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
