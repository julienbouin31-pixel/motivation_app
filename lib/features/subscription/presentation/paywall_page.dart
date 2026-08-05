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
  // Connect). La notif de rappel tombe [_reminderInDays] jours après le début
  // (ici 1 jour avant la fin).
  static const int _trialDays = 3;
  static const int _reminderInDays = 2;

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

  // ─── Offres (réelles ou repli) ──────────────────────────────────────────────

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

  /// Sous-titre de l'offre annuelle, avec l'équivalent mensuel réel (calculé
  /// par le store) quand il est disponible.
  String get _annualSubtitle {
    final perMonth = _annual?.storeProduct.pricePerMonthString;
    return perMonth != null
        ? '$_annualPrice par an · $perMonth/mois'
        : '$_annualPrice par an';
  }

  String get _finePrint {
    if (_annualSelected) {
      return 'sans engagement, annule quand tu veux — puis $_annualPrice par an.';
    }
    return 'sans engagement, annule quand tu veux — puis $_monthlyPrice par mois.';
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
        const SnackBar(content: Text('bienvenue dans curves premium.')),
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
            Text(ok ? 'abonnement restauré.' : 'aucun abonnement à restaurer.'),
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
                      padding: const EdgeInsets.fromLTRB(28, 4, 28, 8),
                      children: [
                        Text(
                          'comment fonctionne\nton essai gratuit',
                          style: AppStyle.display(size: 27),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppStyle.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '0 € à payer aujourd\'hui',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppStyle.ink.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // Timeline sobre : marqueurs à filet, un point ocre
                        // pour aujourd'hui, reliés par un filet.
                        _TimelineStep(
                          label: 'aujourd\'hui',
                          body:
                              'accès complet à toutes les fonctionnalités de curves.',
                          active: true,
                        ),
                        _TimelineStep(
                          label: 'dans $_reminderInDays jours',
                          body:
                              'on t\'envoie un rappel avant la fin de ta période d\'essai.',
                        ),
                        _TimelineStep(
                          label: 'dans $_trialDays jours',
                          body:
                              'début de l\'abonnement le ${_frenchDate(startDate)}, sauf si tu annules avant.',
                          isLast: true,
                        ),

                        const SizedBox(height: 20),

                        // Offres — listes à filets (composant maison)
                        SelectableRow(
                          label: 'annuel',
                          sublabel: _annualSubtitle,
                          selected: _annualSelected,
                          onTap: () =>
                              setState(() => _selected = _annual ?? _selected),
                        ),
                        SelectableRow(
                          label: 'mensuel',
                          sublabel: '$_monthlyPrice par mois',
                          selected: !_annualSelected,
                          onTap: () =>
                              setState(() => _selected = _monthly ?? _selected),
                        ),

                        // Rappel — même filet
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: AppStyle.hairline)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'me rappeler avant la fin',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppStyle.ink.withValues(alpha: 0.55),
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _reminder,
                                onChanged: (v) => setState(() => _reminder = v),
                                activeThumbColor: const Color(0xFF111110),
                                activeTrackColor: AppStyle.ink,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
                    child: Column(
                      children: [
                        Text(
                          _finePrint,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 12, color: AppStyle.dim),
                        ),
                        const SizedBox(height: 14),
                        _PrimaryButton(
                          label: _busy ? '…' : 'essayer gratuitement',
                          enabled: !_busy,
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

// ─── Étape de timeline (éditoriale : filets, point ocre) ──────────────────────

class _TimelineStep extends StatelessWidget {
  final String label;
  final String body;
  final bool active;
  final bool isLast;

  const _TimelineStep({
    required this.label,
    required this.body,
    this.active = false,
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
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active
                        ? AppStyle.accent
                        : AppStyle.ink.withValues(alpha: 0.25),
                  ),
                ),
                child: active
                    ? Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppStyle.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: AppStyle.hairline),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 26, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppStyle.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppStyle.ink.withValues(alpha: 0.55),
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

// ─── Bouton pilule ivoire ─────────────────────────────────────────────────────

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
