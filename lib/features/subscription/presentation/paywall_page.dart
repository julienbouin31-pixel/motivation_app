import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/purchases/purchases_service.dart';
import 'package:motivation_app/core/purchases/subscription_cubit.dart';

class PaywallPage extends StatefulWidget {
  /// true quand le paywall est présenté à la fin de l'onboarding : le fermer
  /// mène à l'app (au lieu d'un simple retour).
  final bool fromOnboarding;

  const PaywallPage({super.key, this.fromOnboarding = false});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  // Essai gratuit (doit correspondre à l'introductory offer dans App Store
  // Connect). La notif de rappel tombe [_reminderInDays] jours après le début.
  static const int _trialDays = 7;
  static const int _reminderInDays = 5;

  // Prix affichés en attendant la config RevenueCat. En production, ce sont les
  // vrais prix du store (storeProduct.priceString) qui priment.
  static const String _fallbackAnnual = '20 €';
  static const String _fallbackMonthly = '2,99 €';

  Offering? _offering;
  Package? _selected;
  bool _loading = true;
  bool _busy = false;
  bool _reminder = true;

  @override
  void initState() {
    super.initState();
    _loadOffering();
  }

  Future<void> _loadOffering() async {
    final offering = await PurchasesService.currentOffering();
    if (!mounted) return;
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

  // ─── Offres (réelles ou fallback) ───────────────────────────────────────────

  Package? get _annual => _packageOfType(PackageType.annual);
  Package? get _monthly => _packageOfType(PackageType.monthly);

  Package? _packageOfType(PackageType type) {
    for (final p in _offering?.availablePackages ?? const <Package>[]) {
      if (p.packageType == type) return p;
    }
    return null;
  }

  bool get _annualSelected =>
      _selected == null || _selected?.packageType == PackageType.annual;

  String get _annualPrice => _annual?.storeProduct.priceString ?? _fallbackAnnual;
  String get _monthlyPrice =>
      _monthly?.storeProduct.priceString ?? _fallbackMonthly;

  /// Petit texte "engagement" adapté à l'offre sélectionnée.
  String get _finePrint {
    if (_annualSelected) {
      return 'Sans engagement. Annule à tout moment ou continue pour '
          '$_annualPrice/an (soit ~1,67 €/mois).';
    }
    return 'Sans engagement. Annule à tout moment ou continue pour '
        '$_monthlyPrice/mois.';
  }

  // ─── Actions ────────────────────────────────────────────────────────────────

  void _close() {
    if (widget.fromOnboarding) {
      context.go(AppRouter.affirmation);
    } else {
      context.pop();
    }
  }

  Future<void> _subscribe() async {
    if (_busy) return;
    HapticFeedback.lightImpact();
    final package = _selected;

    // RevenueCat pas encore configuré : on laisse passer (aperçu / mode gratuit).
    if (package == null) {
      _close();
      return;
    }

    setState(() => _busy = true);
    final ok = await context.read<SubscriptionCubit>().purchase(package);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      if (_reminder) {
        await NotificationService.scheduleTrialReminder(inDays: _reminderInDays);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bienvenue dans Curves Premium ✦')),
      );
      _close();
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
        content:
            Text(ok ? 'Abonnement restauré.' : 'Aucun abonnement à restaurer.'),
      ),
    );
    if (ok) _close();
  }

  Future<void> _openUrl(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.now().add(const Duration(days: _trialDays));

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppStyle.dim))
            : Column(
                children: [
                  // Fermer
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _close,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Icon(Icons.close,
                            size: 22,
                            color: AppStyle.ink.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
                      children: [
                        Text(
                          'on te préviendra avant\nla fin de ton essai gratuit',
                          style: AppStyle.display(size: 26),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.check_rounded,
                                size: 18, color: AppStyle.accent),
                            const SizedBox(width: 6),
                            Text(
                              '0 € à payer aujourd\'hui',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppStyle.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Timeline
                        _TimelineStep(
                          icon: Icons.lock_open_rounded,
                          title: 'aujourd\'hui',
                          body:
                              'Accès complet à toutes les fonctionnalités de Curves.',
                        ),
                        _TimelineStep(
                          icon: Icons.notifications_none_rounded,
                          title: 'dans $_reminderInDays jours',
                          body:
                              'On t\'envoie une notification avant la fin de ta période d\'essai.',
                        ),
                        _TimelineStep(
                          icon: Icons.workspace_premium_outlined,
                          title: 'dans $_trialDays jours',
                          body:
                              'Début de ton abonnement le ${_frenchDate(startDate)}, sauf si tu annules avant.',
                          isLast: true,
                        ),

                        const SizedBox(height: 20),

                        // Sélecteur d'offre
                        Row(
                          children: [
                            Expanded(
                              child: _OfferPill(
                                title: 'annuel',
                                price: '$_annualPrice/an',
                                badge: '-44 %',
                                selected: _annualSelected,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() =>
                                      _selected = _annual ?? _selected);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _OfferPill(
                                title: 'mensuel',
                                price: '$_monthlyPrice/mois',
                                selected: !_annualSelected,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() =>
                                      _selected = _monthly ?? _selected);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Toggle rappel
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppStyle.hairline),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Rappel avant la fin de l\'essai',
                                  style: TextStyle(
                                      fontSize: 14, color: AppStyle.ink),
                                ),
                              ),
                              Switch.adaptive(
                                value: _reminder,
                                onChanged: (v) => setState(() => _reminder = v),
                                activeThumbColor: const Color(0xFF111110),
                                activeTrackColor: AppStyle.accent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bas : engagement + CTA + légal
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
                    child: Column(
                      children: [
                        Text(
                          _finePrint,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 12, color: AppStyle.dim),
                        ),
                        const SizedBox(height: 12),
                        _PrimaryButton(
                          label: _busy ? '…' : 'essayer gratuitement',
                          enabled: !_busy,
                          onPressed: _subscribe,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LinkText('restaurer', _restore),
                            _dot(),
                            _LinkText('confidentialité',
                                () => _openUrl(AppRouter.privacyUrl)),
                            _dot(),
                            _LinkText(
                                'conditions', () => _openUrl(AppRouter.termsUrl)),
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
}

// ─── Étape de timeline ────────────────────────────────────────────────────────

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.accent.withValues(alpha: 0.12),
                  border:
                      Border.all(color: AppStyle.accent.withValues(alpha: 0.5)),
                ),
                child: Icon(icon, size: 18, color: AppStyle.accent),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppStyle.accent.withValues(alpha: 0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppStyle.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppStyle.ink.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pilule d'offre ───────────────────────────────────────────────────────────

class _OfferPill extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const _OfferPill({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppStyle.accent : AppStyle.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppStyle.ink,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppStyle.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111110),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 13,
                color: AppStyle.ink.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
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
      child: Container(
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

// ─── Date en français ─────────────────────────────────────────────────────────

String _frenchDate(DateTime d) {
  const mois = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];
  return '${d.day} ${mois[d.month - 1]}';
}
