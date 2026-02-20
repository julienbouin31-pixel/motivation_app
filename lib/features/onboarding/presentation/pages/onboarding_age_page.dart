import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_logo.dart';
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
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BackButtonWidget(),
                        const Spacer(),
                        const OnboardingLogo(),
                      ],
                    ),
                    const SizedBox(height: 32),
                     ProgressIndicatorBar(
                  currentStep: OnboardingFlow.stepNumber(AppRouter.onboardingObjective),
                  totalSteps: OnboardingFlow.totalSteps,
                ),
                    const SizedBox(height: 48),
                    const Text(
                      'Quel âge as-tu ?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pour adapter le ton de tes affirmations.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ..._ageRanges.map((ageRange) => AgeOptionCard(
                          ageRange: ageRange,
                          isSelected: _selectedAgeRange == ageRange,
                          onTap: () {
                            setState(() {
                              _selectedAgeRange = ageRange;
                            });
                          },
                        )),
                    const Spacer(),
                    ContinueButton(
                      enabled: _selectedAgeRange != null,
                      onPressed: _selectedAgeRange != null
                          ? () => context.go(AppRouter.affirmation)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
