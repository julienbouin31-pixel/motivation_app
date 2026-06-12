import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/age_option_card.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';

class OnboardingAgePage extends StatefulWidget {
  const OnboardingAgePage({super.key});

  @override
  State<OnboardingAgePage> createState() => _OnboardingAgePageState();
}

class _OnboardingAgePageState extends State<OnboardingAgePage> {
  String? _selectedAgeRange;

  final List<String> _ageRanges = [
    '18-24 ans',
    '25-34 ans',
    '35-44 ans',
    '45-54 ans',
    '55+ ans',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeSlideIn(
                        child: Row(
                          children: const [BackButtonWidget(), Spacer()],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 60),
                        child: ProgressIndicatorBar(
                          currentStep: OnboardingFlow.progress(AppRouter.onboardingAge).step,
                          totalSteps: OnboardingFlow.progress(AppRouter.onboardingAge).total,
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 120),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFD3D3D3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                          child: const Text(
                            'Quel âge as-tu ?',
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
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 160),
                        child: Text(
                          'Pour adapter le ton de tes affirmations.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.5),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 220),
                        child: Column(
                          children: _ageRanges.map((ageRange) => AgeOptionCard(
                            ageRange: ageRange,
                            isSelected: _selectedAgeRange == ageRange,
                            onTap: () => setState(() => _selectedAgeRange = ageRange),
                          )).toList(),
                        ),
                      ),
                      const Spacer(),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 320),
                        child: ContinueButton(
                          enabled: _selectedAgeRange != null,
                          onPressed: _selectedAgeRange != null
                              ? () => context.push(AppRouter.onboardingNotifications)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
