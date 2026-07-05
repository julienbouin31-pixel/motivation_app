import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),

                // ── Logo / icône ───────────────────────────────────────────
                FadeSlideIn(
                  child: Image.asset(
                    'assets/images/logo_cropped.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Titre ──────────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFB0B0B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Chaque jour,\nune version\nmeilleure de toi.',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Sous-titre ─────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: Text(
                    'Des affirmations personnalisées pour\nte motiver, chaque matin.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.45),
                      height: 1.55,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Preuves sociales ───────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 220),
                  child: Row(
                    children: [
                      _Pill(icon: Icons.star_rounded, label: '4.9', color: const Color(0xFFFFCC00)),
                      const SizedBox(width: 10),
                      _Pill(icon: Icons.people_outline_rounded, label: '12k+ utilisateurs', color: Colors.white.withValues(alpha: 0.5)),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // ── CTA ────────────────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  child: ContinueButton(
                    label: 'Commencer',
                    onPressed: () => OnboardingFlow.next(context, AppRouter.onboardingWelcome),
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

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
