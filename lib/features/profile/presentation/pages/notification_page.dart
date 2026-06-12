import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

    final rawTexts = await di.sl<AffirmationLocalDataSource>().getAllTexts();
    final resolved = rawTexts
        .map((t) => t.replaceAll('{name}', userName))
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Rappels',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_loading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Toggle ────────────────────────────────────
                        _Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Activer les rappels',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _enabled ? 'Actifs' : 'Désactivés',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: _enabled,
                                onChanged: _setEnabled,
                                activeThumbColor: Colors.white,
                                activeTrackColor: Colors.white.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        ),

                        if (_enabled) ...[
                          const SizedBox(height: 16),

                          // ─── Test ──────────────────────────────────
                          const _TestButton(),

                          const SizedBox(height: 28),

                          // ─── Fréquence ─────────────────────────────
                          const _SectionLabel('FRÉQUENCE'),
                          const SizedBox(height: 10),
                          ..._freqOptions.map((opt) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _FrequencyCard(
                                  label: opt.label,
                                  sub: opt.sub,
                                  selected: _frequency == opt.freq,
                                  onTap: () => _onFreqChanged(opt.freq),
                                ),
                              )),

                          const SizedBox(height: 28),

                          // ─── Plage horaire ─────────────────────────
                          const _SectionLabel('PLAGE HORAIRE'),
                          const SizedBox(height: 6),
                          Text(
                            'Tes rappels seront envoyés entre ces heures',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _HourPicker(
                                  label: 'De',
                                  value: _startHour,
                                  onChanged: _onStartChanged,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _HourPicker(
                                  label: 'À',
                                  value: _endHour,
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
      ),
    );
  }
}

// ─── Widgets partagés ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: child,
      );
}

class _FrequencyCard extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _FrequencyCard({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
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
                color: selected ? Colors.white : Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 13,
                color: selected
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestButton extends StatefulWidget {
  const _TestButton();

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
              final onboardingState = context.read<OnboardingCubit>().state;
              final profile = switch (onboardingState) {
                OnboardingDataSaved(:final profile) => profile,
                OnboardingProfileLoaded(:final profile) => profile,
                _ => null,
              };
              final userName = profile?.name ?? '';
              final texts = await di.sl<AffirmationLocalDataSource>().getAllTexts();
              texts.shuffle();
              final text = (texts.isNotEmpty
                      ? texts.first
                      : 'Continue, tu es plus proche que tu ne le crois.')
                  .replaceAll('{name}', userName);
              await NotificationService.scheduleTestIn5Seconds(text);
              setState(() => _sent = true);
              Future.delayed(const Duration(seconds: 8), () {
                if (mounted) setState(() => _sent = false);
              });
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _sent ? Icons.check : Icons.notifications_active_outlined,
              size: 16,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              _sent
                  ? 'Notif dans 5 secondes — passe en arrière-plan'
                  : 'Envoyer une notif de test',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.6),
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
  final ValueChanged<int> onChanged;

  const _HourPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.5)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A1A1A),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              items: List.generate(
                24,
                (h) => DropdownMenuItem(
                  value: h,
                  child: Text('${h}h00'),
                ),
              ),
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
