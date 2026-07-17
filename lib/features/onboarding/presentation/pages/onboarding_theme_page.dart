import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

class OnboardingThemePage extends StatelessWidget {
  const OnboardingThemePage({super.key});

  List<CardVisualTheme> get _choices {
    final adaptive =
        CardVisualTheme.values.where((t) => t.data.isAdaptive).toList();
    final photos = CardVisualTheme.values
        .where((t) => t.data.assetImage != null)
        .take(5)
        .toList();
    return [...adaptive.take(1), ...photos];
  }

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(AppRouter.onboardingTheme);
    final current = context.watch<CardThemeCubit>().state;
    final choices = _choices;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                duration: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(),
                    ),
                    const SizedBox(height: 18),
                    ProgressIndicatorBar(
                      currentStep: progress.step,
                      totalSteps: progress.total,
                    ),
                    const SizedBox(height: 36),
                    Text('choisis ton décor.', style: AppStyle.display()),
                    const SizedBox(height: 12),
                    Text(
                      'Le fond de tes affirmations — tu pourras en changer à tout moment.',
                      style: AppStyle.body,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 250),
                  duration: const Duration(milliseconds: 600),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: choices.length,
                    itemBuilder: (context, index) {
                      final theme = choices[index];
                      final data = theme.data;
                      final selected = current == theme;

                      return GestureDetector(
                        onTap: () =>
                            context.read<CardThemeCubit>().setTheme(theme),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? AppStyle.ink : AppStyle.hairline,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (data.isAdaptive)
                                  Container(color: const Color(0xFF161615))
                                else if (data.assetImage != null)
                                  Image.asset(
                                    data.assetImage!,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: data.gradientColors,
                                        begin: data.begin,
                                        end: data.end,
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: Text(
                                    'Aa',
                                    style: AppStyle.display(size: 18).copyWith(
                                      color: data.isAdaptive
                                          ? AppStyle.ink
                                          : data.textColor,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Positioned(
                                    top: 7,
                                    right: 7,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: AppStyle.ink,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 11,
                                        color: Color(0xFF111110),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ContinueButton(
                onPressed: () =>
                    OnboardingFlow.next(context, AppRouter.onboardingTheme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
