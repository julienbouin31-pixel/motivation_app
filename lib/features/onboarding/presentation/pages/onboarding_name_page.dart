import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_text_field.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/continue_button.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';

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
    final colors = Theme.of(context).extension<AppColors>()!;
    
    return Scaffold(
      backgroundColor: Colors.black, // Raccord avec la HomePage
      // Essentiel pour que l'UI remonte avec le clavier
      resizeToAvoidBottomInset: true, 
      body: Container(
        // Le même gradient subtil pour la cohérence
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Colors.black,
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          // Utilisation d'un CustomScrollView pour gérer le clavier sans overflow
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FadeSlideIn(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BackButtonWidget(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 60),
                        child: ProgressIndicatorBar(
                          currentStep: OnboardingFlow.progress(AppRouter.onboardingName).step,
                          totalSteps: OnboardingFlow.progress(AppRouter.onboardingName).total,
                        ),
                      ),
                      const SizedBox(height: 48), // Un peu plus d'air
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 120),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFD3D3D3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                          child: Text(
                            'Comment tu t\'appelles ?',
                            style: TextStyle(
                              fontSize: 34, // Plus grand
                              fontWeight: FontWeight.w800, // Plus massif
                              color: Colors.white, // Forcé en blanc pour le mask
                              height: 1.15,
                              letterSpacing: -1.0, // Plus resserré
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 160),
                        child: Text(
                          'On personnalisera tes affirmations quotidiennes.',
                          style: TextStyle(
                            fontSize: 16, // Plus lisible
                            fontWeight: FontWeight.w400,
                            color: colors.secondary.withValues(alpha: 0.8),
                            height: 1.5,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 220),
                        child: OnboardingTextField(
                          hintText: 'Ton prénom',
                          controller: _nameController,
                          // Idéalement, si ton OnboardingTextField le permet,
                          // ajoute un paramètre `autofocus: true` pour ouvrir le clavier direct.
                        ),
                      ),
                      const Spacer(),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 300),
                        child: ContinueButton(
                          enabled: _isNameValid,
                          onPressed: _isNameValid
                              ? () {
                                  context.read<OnboardingCubit>().saveName(
                                        _nameController.text.trim(),
                                      );
                                  OnboardingFlow.next(context, AppRouter.onboardingName);
                                }
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