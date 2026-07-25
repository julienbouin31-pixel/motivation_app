import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';
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
    (freq: 1, label: 'Une fois par jour', sub: 'Le matin, pour bien commencer'),
    (freq: 3, label: 'Trois fois par jour', sub: 'Matin, midi et soir'),
    (freq: 5, label: 'Cinq fois par jour', sub: 'Un fil rouge dans ta journée'),
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
      if (mounted) {
        await NotificationService.scheduleStreakDanger(
          context.read<StreakCubit>().state,
        );
      }
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

    final rawEntries = await di.sl<AffirmationLocalDataSource>().getAllWithIds();
    final resolved = rawEntries
        .map((e) => (e.$1, e.$2.replaceAll('{name}', userName)))
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
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppStyle.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('tes rappels', style: AppStyle.display(size: 30)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppStyle.dim),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Toggle ────────────────────────────────────
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppStyle.hairline),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Activer les rappels',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppStyle.ink,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: _enabled,
                              onChanged: _setEnabled,
                              activeThumbColor: const Color(0xFF111110),
                              activeTrackColor: AppStyle.ink,
                            ),
                          ],
                        ),
                      ),

                      if (_enabled) ...[
                        const SizedBox(height: 20),

                        // ─── Test ──────────────────────────────────
                        const _TestButton(),

                        const SizedBox(height: 32),

                        // ─── Fréquence ─────────────────────────────
                        const Text('fréquence', style: AppStyle.overline),
                        const SizedBox(height: 4),
                        for (final opt in _freqOptions)
                          SelectableRow(
                            label: opt.label,
                            sublabel: opt.sub,
                            selected: _frequency == opt.freq,
                            onTap: () => _onFreqChanged(opt.freq),
                          ),

                        const SizedBox(height: 32),

                        // ─── Plage horaire ─────────────────────────
                        const Text('plage horaire', style: AppStyle.overline),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _HourPicker(
                                label: 'de',
                                value: _startHour,
                                onChanged: _onStartChanged,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _HourPicker(
                                label: 'à',
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
    );
  }
}

// ─── Bouton de test ───────────────────────────────────────────────────────────

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
              final texts =
                  await di.sl<AffirmationLocalDataSource>().getAllTexts();
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
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppStyle.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _sent ? Icons.check : Icons.notifications_active_outlined,
              size: 16,
              color: AppStyle.ink.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              _sent
                  ? 'notif dans 5 secondes — passe en arrière-plan'
                  : 'envoyer une notif de test',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppStyle.ink.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sélecteur d'heure sur filet ──────────────────────────────────────────────

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
        Text(label, style: AppStyle.overline),
        const SizedBox(height: 2),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppStyle.hairline)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF171716),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppStyle.ink,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppStyle.ink.withValues(alpha: 0.4),
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
