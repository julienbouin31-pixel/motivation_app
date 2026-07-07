import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';

/// Page de respiration : un grand énoncé, un texte court, un filet qui se
/// dessine — pas de question, juste un moment.
class OnboardingMessagePage extends StatelessWidget {
  final String route;
  final Widget title;
  final String? body;
  final String cta;
  final Widget? extra;

  const OnboardingMessagePage({
    super.key,
    required this.route,
    required this.title,
    this.body,
    this.cta = 'continuer',
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              FadeSlideIn(
                duration: const Duration(milliseconds: 700),
                child: title,
              ),

              if (body != null) ...[
                const SizedBox(height: 20),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  child: Text(body!, style: AppStyle.body),
                ),
              ],

              const SizedBox(height: 36),
              const AnimatedHairline(
                delay: Duration(milliseconds: 600),
                duration: Duration(milliseconds: 900),
              ),

              if (extra != null) ...[
                const SizedBox(height: 36),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 600),
                  child: extra!,
                ),
              ],

              const Spacer(flex: 3),

              FadeSlideIn(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: ContinueButton(
                  label: cta,
                  onPressed: () => OnboardingFlow.next(context, route),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
