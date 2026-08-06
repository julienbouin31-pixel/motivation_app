import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/purchases/premium_content.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

class OnboardingThemePage extends StatelessWidget {
  const OnboardingThemePage({super.key});

  // Vitrine premium : les décors les plus marquants (photos nature, cosmos,
  // urbain) montrés avec un cadenas pour donner envie.
  static const _premiumShowcase = [
    CardVisualTheme.aurore,
    CardVisualTheme.galaxie,
    CardVisualTheme.nebuleuse,
    CardVisualTheme.aube,
    CardVisualTheme.tempete,
    CardVisualTheme.metropole,
    CardVisualTheme.desert,
    CardVisualTheme.flamme,
  ];

  // Décors gratuits en tête (sélectionnables), suivis de la vitrine premium.
  List<CardVisualTheme> get _choices {
    final free =
        CardVisualTheme.values.where(PremiumContent.freeThemes.contains);
    return [...free, ..._premiumShowcase];
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
                    itemCount: choices.length + 1,
                    itemBuilder: (context, index) {
                      // Dernière tuile : aperçu "plein d'autres".
                      if (index == choices.length) return const _MoreTile();

                      final theme = choices[index];
                      final data = theme.data;
                      final locked =
                          !PremiumContent.freeThemes.contains(theme);
                      final selected = current == theme;

                      return GestureDetector(
                        onTap: locked
                            ? null
                            : () =>
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
                                if (locked)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black
                                          .withValues(alpha: 0.45),
                                      child: Center(
                                        child: Icon(
                                          Icons.lock_outline,
                                          size: 18,
                                          color: Colors.white
                                              .withValues(alpha: 0.85),
                                        ),
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

              const SizedBox(height: 16),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'débloque ',
                    style: const TextStyle(fontSize: 13, color: AppStyle.dim),
                    children: [
                      TextSpan(
                        text: 'curves premium',
                        style: AppStyle.displayItalic(size: 13)
                            .copyWith(color: AppStyle.accent),
                      ),
                      const TextSpan(text: ' pour en avoir plein d\'autres.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

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

// ─── Tuile "plein d'autres" (aperçu premium) ─────────────────────────────────

class _MoreTile extends StatelessWidget {
  const _MoreTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppStyle.hairline),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline,
                size: 16, color: AppStyle.ink.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            const Text(
              'plein\nd\'autres',
              textAlign: TextAlign.center,
              style: AppStyle.overline,
            ),
          ],
        ),
      ),
    );
  }
}
