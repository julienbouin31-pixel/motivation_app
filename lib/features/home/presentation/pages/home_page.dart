import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/home/presentation/widgets/home_cta_button.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Container(
        // 1. Ajout d'un gradient très subtil pour casser le noir plat
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A), // Gris très sombre en haut
              Colors.black,
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 2. Halo lumineux subtil derrière le logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.08),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo_cropped.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64), // Espace légèrement augmenté
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  // 3. Effet métallique/reflet sur le texte principal
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFD3D3D3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'Commence à construire\nton futur, aujourd\'hui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38, // Légèrement plus grand
                        fontWeight: FontWeight.w800, // Plus massif
                        height: 1.15,
                        color: Colors.white,
                        letterSpacing: -1.0, // Tracking serré plus moderne
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 240),
                  child: Text(
                    'Une affirmation par jour pour rester\nfocalisé sur ce qui compte vraiment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.6), // Meilleur contraste
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const Spacer(),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 360),
                  child: HomeCtaButton(
                    onPressed: () => context.push(AppRouter.onboardingName),
                  ),
                ),
                const SizedBox(height: 24), // Laisse le bouton respirer en bas
              ],
            ),
          ),
        ),
      ),
    );
  }
}