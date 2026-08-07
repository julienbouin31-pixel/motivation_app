import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

/// Page de question à choix unique : on sélectionne une option puis on valide
/// avec le bouton continuer. Un "passer" discret permet d'ignorer la question.
class OnboardingQuestionPage extends StatefulWidget {
  final String route;
  final String title;
  final String? subtitle;
  final List<({String label, String? sub})> options;

  /// Appelé avec le label choisi au moment du « continuer » (pour persister
  /// la réponse). Le "passer" ne le déclenche pas.
  final ValueChanged<String>? onSelected;

  const OnboardingQuestionPage({
    super.key,
    required this.route,
    required this.title,
    this.subtitle,
    required this.options,
    this.onSelected,
  });

  @override
  State<OnboardingQuestionPage> createState() => _OnboardingQuestionPageState();
}

class _OnboardingQuestionPageState extends State<OnboardingQuestionPage> {
  String? _selected;

  void _select(String label) {
    setState(() => _selected = label);
  }

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(widget.route);

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
                    Row(
                      children: [
                        const BackButtonWidget(),
                        const Spacer(),
                        GestureDetector(
                          onTap: () =>
                              OnboardingFlow.next(context, widget.route),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('passer', style: AppStyle.overline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ProgressIndicatorBar(
                      currentStep: progress.step,
                      totalSteps: progress.total,
                    ),
                    const SizedBox(height: 36),
                    Text(widget.title, style: AppStyle.display()),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 12),
                      Text(widget.subtitle!, style: AppStyle.body),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final (i, option) in widget.options.indexed)
                        FadeSlideIn(
                          delay: Duration(milliseconds: 200 + i * 55),
                          duration: const Duration(milliseconds: 500),
                          child: SelectableRow(
                            label: option.label,
                            sublabel: option.sub,
                            selected: _selected == option.label,
                            onTap: () => _select(option.label),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ContinueButton(
                enabled: _selected != null,
                onPressed: _selected == null
                    ? null
                    : () {
                        widget.onSelected?.call(_selected!);
                        OnboardingFlow.next(context, widget.route);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
