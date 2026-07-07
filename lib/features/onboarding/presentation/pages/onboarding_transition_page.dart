import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/config/themes/app_style.dart';

class OnboardingTransitionPage extends StatelessWidget {
  const OnboardingTransitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final name = profile?.name?.isNotEmpty == true ? profile!.name! : null;

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
                child: Text.rich(
                  TextSpan(
                    style: AppStyle.display(size: 38),
                    children: [
                      TextSpan(
                        text: name != null ? 'enchanté, ' : 'enchanté.',
                      ),
                      if (name != null)
                        TextSpan(
                          text: '$name.',
                          style: AppStyle.displayItalic(size: 38),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FadeSlideIn(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'On va faire connaissance —\nquelques questions, deux petites minutes.',
                  style: AppStyle.body,
                ),
              ),

              const SizedBox(height: 36),
              const AnimatedHairline(
                delay: Duration(milliseconds: 600),
                duration: Duration(milliseconds: 900),
              ),

              const Spacer(flex: 3),

              FadeSlideIn(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: ContinueButton(
                  onPressed: () => OnboardingFlow.next(
                      context, AppRouter.onboardingTransition),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
