import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';

class OnboardingStripePage extends StatefulWidget {
  const OnboardingStripePage({super.key});

  @override
  State<OnboardingStripePage> createState() => _OnboardingStripePageState();
}

class _OnboardingStripePageState extends State<OnboardingStripePage> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _apiKeyController.addListener(() {
      setState(() => _isValid = _apiKeyController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Widget _backLink(BuildContext context, String label, VoidCallback onTap) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 16, color: colors.secondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: colors.secondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffold,
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
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ProgressIndicatorBar(
                      currentStep: OnboardingFlow.progress(AppRouter.onboardingStripe, isMrr: true).step,
                      totalSteps: OnboardingFlow.progress(AppRouter.onboardingStripe, isMrr: true).total,
                    ),
                    const SizedBox(height: 20),
                    _backLink(context, 'Retour', () => context.pop()),
                    const SizedBox(height: 32),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.link, size: 26, color: colors.primary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Connecter Stripe',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Entre ta clé API secrète pour synchroniser ton MRR.',
                      style: TextStyle(fontSize: 13, color: colors.secondary, height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'CLÉ API STRIPE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: colors.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _apiKeyController,
                      style: TextStyle(color: colors.primary),
                      decoration: InputDecoration(
                        hintText: 'sk_live_...',
                        hintStyle: TextStyle(color: colors.secondary),
                        filled: true,
                        fillColor: colors.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isValid
                            ? () {
                                context.read<OnboardingCubit>().saveStripeApiKey(
                                      _apiKeyController.text.trim(),
                                    );
                                OnboardingFlow.next(context, AppRouter.onboardingStripe);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid ? colors.primary : colors.border,
                          foregroundColor: colors.scaffold,
                          disabledBackgroundColor: colors.border,
                          disabledForegroundColor: colors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Valider la connexion',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push(AppRouter.onboardingMrrTarget),
                        child: Text(
                          'Passer cette étape',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.secondary,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OÙ TROUVER CETTE CLÉ ?',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: colors.secondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('1. Connecte-toi à ton dashboard Stripe',
                              style: TextStyle(fontSize: 13, color: colors.secondary)),
                          const SizedBox(height: 4),
                          Text('2. Va dans Développeurs → Clés API',
                              style: TextStyle(fontSize: 13, color: colors.secondary)),
                          const SizedBox(height: 4),
                          Text('3. Copie ta clé secrète (sk_live_...)',
                              style: TextStyle(fontSize: 13, color: colors.secondary)),
                        ],
                      ),
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
