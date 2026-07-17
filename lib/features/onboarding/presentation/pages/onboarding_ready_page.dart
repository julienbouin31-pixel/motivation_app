import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_message_page.dart';

class OnboardingReadyPage extends StatelessWidget {
  const OnboardingReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final name = profile?.name?.isNotEmpty == true ? profile!.name! : null;

    return OnboardingMessagePage(
      route: AppRouter.onboardingReady,
      cta: 'entrer',
      title: Text.rich(
        TextSpan(
          style: AppStyle.display(size: 38),
          children: [
            const TextSpan(text: 'ton espace\nest prêt'),
            if (name != null)
              TextSpan(
                text: ', $name',
                style: AppStyle.displayItalic(size: 38),
              ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
      body: 'Tes affirmations t\'attendent.\nOn se voit demain matin ?',
    );
  }
}
