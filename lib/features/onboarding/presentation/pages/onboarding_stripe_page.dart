import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_logo.dart';
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

  Widget _backLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

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
                        const OnboardingLogo(),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const ProgressIndicatorBar(currentStep: 2, totalSteps: 3),
                    const SizedBox(height: 20),
                    _backLink('Retour', () => context.pop()),
                    const SizedBox(height: 8),
                    _backLink('Retour', () => context.pop()),
                    const SizedBox(height: 32),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.link, size: 26, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Connecter Stripe',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Entre ta clé API secrète pour synchroniser ton MRR.',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'CLÉ API STRIPE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        hintText: 'sk_live_...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black, width: 1.5),
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
                                context.read<OnboardingCubit>().saveStripeApiKeyAction(
                                      _apiKeyController.text.trim(),
                                    );
                                context.push(AppRouter.onboardingStripeConnected);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid ? Colors.black : Colors.grey[300],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
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
                            color: Colors.grey[500],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
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
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('1. Connecte-toi à ton dashboard Stripe',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                          const SizedBox(height: 4),
                          Text('2. Va dans Développeurs → Clés API',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                          const SizedBox(height: 4),
                          Text('3. Copie ta clé secrète (sk_live_...)',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
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
