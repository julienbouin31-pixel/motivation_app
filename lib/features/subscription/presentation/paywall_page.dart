import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/purchases/purchases_service.dart';
import 'package:motivation_app/core/purchases/subscription_cubit.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  static const _benefits = [
    'Toutes les catégories d\'affirmations',
    'Tous les thèmes de cartes',
    'Affirmations personnelles illimitées',
    'Soutiens le développement de l\'app',
  ];

  Offering? _offering;
  Package? _selected;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadOffering();
  }

  Future<void> _loadOffering() async {
    final offering = await PurchasesService.currentOffering();
    if (!mounted) return;
    // Sélectionne l'annuel par défaut s'il existe, sinon le premier.
    final packages = offering?.availablePackages ?? [];
    Package? selected;
    if (packages.isNotEmpty) {
      selected = packages.firstWhere(
        (p) => p.packageType == PackageType.annual,
        orElse: () => packages.first,
      );
    }
    setState(() {
      _offering = offering;
      _selected = selected;
      _loading = false;
    });
  }

  Future<void> _subscribe() async {
    final package = _selected;
    if (package == null || _busy) return;
    setState(() => _busy = true);
    final ok = await context.read<SubscriptionCubit>().purchase(package);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bienvenue dans Curves Premium ✦')),
      );
    }
  }

  Future<void> _restore() async {
    if (_busy) return;
    setState(() => _busy = true);
    final ok = await context.read<SubscriptionCubit>().restore();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Abonnement restauré.'
            : 'Aucun abonnement à restaurer.'),
      ),
    );
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fermer
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.close,
                        size: 22, color: AppStyle.ink.withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
                children: [
                  Text('curves', style: AppStyle.display(size: 34)),
                  Row(
                    children: [
                      Text('premium',
                          style: AppStyle.displayItalic(size: 34)
                              .copyWith(color: AppStyle.accent)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Débloque toute l\'expérience et va plus loin dans ta pratique.',
                    style: AppStyle.body,
                  ),
                  const SizedBox(height: 32),

                  // Avantages
                  for (final b in _benefits) ...[
                    _BenefitRow(text: b),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 20),

                  // Offres
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: AppStyle.dim),
                      ),
                    )
                  else if (_offering == null ||
                      _offering!.availablePackages.isEmpty)
                    const _OffersUnavailable()
                  else
                    for (final p in _offering!.availablePackages)
                      _OfferCard(
                        package: p,
                        selected: identical(p, _selected),
                        onTap: () => setState(() => _selected = p),
                      ),
                ],
              ),
            ),

            // CTA + légal
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: Column(
                children: [
                  _PrimaryButton(
                    label: _busy ? '…' : 'continuer',
                    enabled: _selected != null && !_busy,
                    onPressed: _subscribe,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LinkText('restaurer', _restore),
                      _dot(),
                      _LinkText('confidentialité',
                          () => _openUrl(AppRouter.privacyUrl)),
                      _dot(),
                      _LinkText('conditions',
                          () => _openUrl(AppRouter.termsUrl)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('·', style: AppStyle.overline),
      );

  Future<void> _openUrl(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

// ─── Avantage ────────────────────────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: AppStyle.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppStyle.ink.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Carte d'offre ───────────────────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  final Package package;
  final bool selected;
  final VoidCallback onTap;

  const _OfferCard({
    required this.package,
    required this.selected,
    required this.onTap,
  });

  String get _period {
    switch (package.packageType) {
      case PackageType.annual:
        return 'annuel';
      case PackageType.monthly:
        return 'mensuel';
      case PackageType.weekly:
        return 'hebdomadaire';
      case PackageType.lifetime:
        return 'à vie';
      default:
        return package.storeProduct.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppStyle.accent : AppStyle.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppStyle.accent : AppStyle.hairline,
                  width: selected ? 5 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _period,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppStyle.ink,
                ),
              ),
            ),
            Text(
              package.storeProduct.priceString,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppStyle.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OffersUnavailable extends StatelessWidget {
  const _OffersUnavailable();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppStyle.hairline),
      ),
      child: Text(
        PurchasesService.isConfigured
            ? 'Les offres arrivent bientôt.'
            : 'Les abonnements ne sont pas encore configurés.',
        style: const TextStyle(fontSize: 14, color: AppStyle.dim),
      ),
    );
  }
}

// ─── Bouton principal ────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: enabled ? AppStyle.ink : AppStyle.ink.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? const Color(0xFF111110)
                  : AppStyle.ink.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkText(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(label, style: AppStyle.overline),
    );
  }
}
