import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

class OnboardingNamePage extends StatefulWidget {
  const OnboardingNamePage({super.key});

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  void _validateName() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = OnboardingFlow.progress(AppRouter.onboardingName);

    return Scaffold(
      backgroundColor: AppStyle.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
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
                            Text(
                              'et toi, comment\ntu t\'appelles ?',
                              style: AppStyle.display(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Chaque affirmation te sera adressée par ton prénom.',
                              style: AppStyle.body,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // ── Saisie : grand serif sur simple filet ─────────────
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 250),
                        duration: const Duration(milliseconds: 600),
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: AppStyle.ink,
                          style: AppStyle.display(size: 30),
                          decoration: InputDecoration(
                            hintText: 'ton prénom',
                            hintStyle: AppStyle.displayItalic(size: 30)
                                .copyWith(
                                    color:
                                        AppStyle.dim.withValues(alpha: 0.5)),
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppStyle.hairline),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyle.ink.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Aperçu vivant : l'affirmation prend vie en tapant ─
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        opacity: _isNameValid ? 1 : 0,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          offset: _isNameValid
                              ? Offset.zero
                              : const Offset(0, 0.3),
                          child: Text(
                            '« ${_nameController.text.trim()}, tu es capable de grandes choses. »',
                            style: AppStyle.displayItalic(size: 17).copyWith(
                              color: AppStyle.ink.withValues(alpha: 0.45),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      ContinueButton(
                        enabled: _isNameValid,
                        onPressed: _isNameValid
                            ? () {
                                context.read<OnboardingCubit>().saveName(
                                      _nameController.text.trim(),
                                    );
                                OnboardingFlow.next(
                                    context, AppRouter.onboardingName);
                              }
                            : null,
                      ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
