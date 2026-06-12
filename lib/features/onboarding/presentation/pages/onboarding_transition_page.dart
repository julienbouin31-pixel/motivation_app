import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';

class OnboardingTransitionPage extends StatelessWidget {
  const OnboardingTransitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Colors.black,
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- NOUVEL ÉLÉMENT GRAPHIQUE (Plus premium) ---
                FadeSlideIn(
                  delay: const Duration(milliseconds: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Container(
                      // Halo lumineux très diffus derrière l'icône
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.08),
                            blurRadius: 50,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      // Application d'un dégradé sur l'icône elle-même
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFF888888)], // Effet argenté
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.self_improvement, // Icône de développement personnel
                          size: 72, // Plus grande pour plus d'impact
                          color: Colors.white, // Forcé en blanc pour le ShaderMask
                        ),
                      ),
                    ),
                  ),
                ),
                // -----------------------------------------------

                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFD3D3D3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'On va personnaliser\nton expérience.',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 180),
                  child: Text(
                    'Quelques questions rapides pour que\nchaque journée compte vraiment.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: colors.secondary.withValues(alpha: 0.8),
                      height: 1.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const Spacer(),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 320),
                  child: ContinueButton(
                    onPressed: () => OnboardingFlow.next(
                        context, AppRouter.onboardingTransition),
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