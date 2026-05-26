import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _storage = di.sl<SecureStorage>();

  bool _enabled = false;
  int _frequency = 1;
  int _startHour = 8;
  int _endHour = 21;
  bool _loading = true;

  static const _freqOptions = [
    (freq: 1, label: '1x par jour', sub: 'Le matin pour bien commencer'),
    (freq: 3, label: '3x par jour', sub: 'Matin, midi et soir'),
    (freq: 5, label: '5x par jour', sub: 'Boost régulier'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _storage.readNotificationEnabled();
    final freq = await _storage.readNotificationFrequency();
    final start = await _storage.readNotificationStartHour();
    final end = await _storage.readNotificationEndHour();
    if (mounted) {
      setState(() {
        _enabled = enabled;
        _frequency = freq;
        _startHour = start;
        _endHour = end;
        _loading = false;
      });
    }
  }

  Future<void> _setEnabled(bool value) async {
    if (value) {
      final granted = await NotificationService.requestPermissions();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Autorise les notifications dans les réglages.')),
        );
        return;
      }
    }
    setState(() => _enabled = value);
    await _storage.saveNotificationEnabled(value);
    if (value) {
      await _reschedule();
    } else {
      await NotificationService.cancelAll();
    }
  }

  Future<void> _reschedule() async {
    final onboardingState = context.read<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final userName = profile?.name ?? '';
    final target = profile?.mrrTarget ?? '';

    final rawTexts = await di.sl<AffirmationLocalDataSource>().getAllTexts();
    final resolved = rawTexts
        .map((t) => t
            .replaceAll('{name}', userName)
            .replaceAll('{target}', target))
        .toList()
      ..shuffle();

    await NotificationService.schedule(
      affirmations: resolved,
      frequency: _frequency,
      startHour: _startHour,
      endHour: _endHour,
    );
  }

  Future<void> _onFreqChanged(int freq) async {
    setState(() => _frequency = freq);
    await _storage.saveNotificationFrequency(freq);
    if (_enabled) await _reschedule();
  }

  Future<void> _onStartChanged(int hour) async {
    setState(() => _startHour = hour);
    await _storage.saveNotificationStartHour(hour);
    if (_enabled) await _reschedule();
  }

  Future<void> _onEndChanged(int hour) async {
    setState(() => _endHour = hour);
    await _storage.saveNotificationEndHour(hour);
    if (_enabled) await _reschedule();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back,
                          size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Rappels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Toggle ────────────────────────────────────────
                      _Card(
                        colors: colors,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Activer les rappels',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                    ),
                                  ),
                                  Text(
                                    _enabled ? 'Actifs' : 'Désactivés',
                                    style: TextStyle(
                                        fontSize: 12, color: colors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _enabled,
                              onChanged: _setEnabled,
                              activeThumbColor: colors.primary,
                              activeTrackColor:
                                  colors.primary.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),

                      if (_enabled) ...[
                        const SizedBox(height: 16),

                        // ─── Test ──────────────────────────────────────
                        _TestButton(colors: colors),

                        const SizedBox(height: 28),

                        // ─── Fréquence ─────────────────────────────────
                        _SectionLabel('FRÉQUENCE', colors),
                        const SizedBox(height: 10),
                        ..._freqOptions.map((opt) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _FrequencyCard(
                                label: opt.label,
                                sub: opt.sub,
                                selected: _frequency == opt.freq,
                                colors: colors,
                                onTap: () => _onFreqChanged(opt.freq),
                              ),
                            )),

                        const SizedBox(height: 28),

                        // ─── Plage horaire ─────────────────────────────
                        _SectionLabel('PLAGE HORAIRE', colors),
                        const SizedBox(height: 6),
                        Text(
                          'Tes rappels seront envoyés entre ces heures',
                          style: TextStyle(
                              fontSize: 13, color: colors.secondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _HourPicker(
                                label: 'De',
                                value: _startHour,
                                colors: colors,
                                onChanged: _onStartChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _HourPicker(
                                label: 'À',
                                value: _endHour,
                                colors: colors,
                                onChanged: _onEndChanged,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 32),
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

// ─── Widgets partagés ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final AppColors colors;
  const _SectionLabel(this.text, this.colors);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: colors.secondary,
        ),
      );
}

class _Card extends StatelessWidget {
  final AppColors colors;
  final Widget child;
  const _Card({required this.colors, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: child,
      );
}

class _FrequencyCard extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final AppColors colors;
  final VoidCallback onTap;

  const _FrequencyCard({
    required this.label,
    required this.sub,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? colors.scaffold : colors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 13,
                color: selected
                    ? colors.scaffold.withValues(alpha: 0.6)
                    : colors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestButton extends StatefulWidget {
  final AppColors colors;
  const _TestButton({required this.colors});

  @override
  State<_TestButton> createState() => _TestButtonState();
}

class _TestButtonState extends State<_TestButton> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _sent
          ? null
          : () async {
              final onboardingState =
                  context.read<OnboardingCubit>().state;
              final profile = switch (onboardingState) {
                OnboardingDataSaved(:final profile) => profile,
                OnboardingProfileLoaded(:final profile) => profile,
                _ => null,
              };
              final userName = profile?.name ?? '';
              final target =
                  profile?.mrrTarget ?? '';
              final texts =
                  await di.sl<AffirmationLocalDataSource>().getAllTexts();
              texts.shuffle();
              final text = (texts.isNotEmpty ? texts.first : 'Continue, tu es plus proche que tu ne le crois.')
                  .replaceAll('{name}', userName)
                  .replaceAll('{target}', target);
              await NotificationService.scheduleTestIn5Seconds(text);
              setState(() => _sent = true);
              Future.delayed(const Duration(seconds: 8),
                  () { if (mounted) setState(() => _sent = false); });
              Future.delayed(const Duration(seconds: 8),
                  () { if (mounted) setState(() => _sent = false); });
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: widget.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _sent ? Icons.check : Icons.notifications_active_outlined,
              size: 16,
              color: widget.colors.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              _sent ? 'Notif dans 5 secondes — passe en arrière-plan' : 'Envoyer une notif de test',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: widget.colors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourPicker extends StatelessWidget {
  final String label;
  final int value;
  final AppColors colors;
  final ValueChanged<int> onChanged;

  const _HourPicker({
    required this.label,
    required this.value,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: colors.secondary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: colors.card,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: colors.secondary),
              items: List.generate(
                  24,
                  (h) => DropdownMenuItem(
                        value: h,
                        child: Text('${h}h00'),
                      )),
              onChanged: (h) {
                if (h != null) onChanged(h);
              },
            ),
          ),
        ),
      ],
    );
  }
}
