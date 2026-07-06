import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/core/widgets/fade_slide_in.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/progress_indicator_bar.dart';
import 'package:motivation_app/injection_container.dart' as di;

class OnboardingNotificationPage extends StatefulWidget {
  const OnboardingNotificationPage({super.key});

  @override
  State<OnboardingNotificationPage> createState() =>
      _OnboardingNotificationPageState();
}

class _OnboardingNotificationPageState
    extends State<OnboardingNotificationPage> {
  int _frequency = 1;
  int _startHour = 8;
  int _endHour = 21;
  bool _saving = false;

  static const _freqOptions = [
    (freq: 1, label: 'Une fois par jour', sub: 'Le matin, pour bien commencer'),
    (freq: 3, label: 'Trois fois par jour', sub: 'Matin, midi et soir'),
    (freq: 5, label: 'Cinq fois par jour', sub: 'Un fil rouge dans ta journée'),
  ];

  Future<void> _confirm() async {
    if (_saving) return;
    HapticFeedback.lightImpact();
    setState(() => _saving = true);

    final granted = await NotificationService.requestPermissions();
    final storage = di.sl<SecureStorage>();

    await storage.setOnboardingDone();
    await storage.saveNotificationEnabled(granted);
    await storage.saveNotificationFrequency(_frequency);
    await storage.saveNotificationStartHour(_startHour);
    await storage.saveNotificationEndHour(_endHour);

    if (granted && mounted) {
      final onboardingState = context.read<OnboardingCubit>().state;
      final profile = switch (onboardingState) {
        OnboardingDataSaved(:final profile) => profile,
        OnboardingProfileLoaded(:final profile) => profile,
        _ => null,
      };
      final userName = profile?.name ?? '';

      final rawTexts =
          await di.sl<AffirmationLocalDataSource>().getAllTexts();
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

    if (mounted) {
      setState(() => _saving = false);
      OnboardingFlow.next(context, AppRouter.onboardingNotifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        OnboardingFlow.progress(AppRouter.onboardingNotifications);

    return Scaffold(
      backgroundColor: OnbStyle.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header fixe ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
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
                ],
              ),
            ),

            // ─── Contenu scrollable ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeSlideIn(
                      duration: const Duration(milliseconds: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'quand veux-tu\nqu\'on t\'écrive ?',
                            style: OnbStyle.display(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tu pourras changer ça à tout moment.',
                            style: OnbStyle.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    FadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500),
                      child: const Text('fréquence', style: OnbStyle.overline),
                    ),
                    const SizedBox(height: 4),
                    for (final (i, opt) in _freqOptions.indexed)
                      FadeSlideIn(
                        delay: Duration(milliseconds: 260 + i * 70),
                        duration: const Duration(milliseconds: 500),
                        child: OnbSelectableRow(
                          label: opt.label,
                          sublabel: opt.sub,
                          selected: _frequency == opt.freq,
                          onTap: () => setState(() => _frequency = opt.freq),
                        ),
                      ),

                    const SizedBox(height: 32),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 500),
                      child:
                          const Text('plage horaire', style: OnbStyle.overline),
                    ),
                    const SizedBox(height: 14),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 560),
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                      children: [
                        Expanded(
                          child: _HourPicker(
                            label: 'De',
                            value: _startHour,
                            onChanged: (h) =>
                                setState(() => _startHour = h),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _HourPicker(
                            label: 'À',
                            value: _endHour,
                            onChanged: (h) => setState(() => _endHour = h),
                          ),
                        ),
                      ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── CTA fixe en bas ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: TextButton(
                  onPressed: _saving ? null : _confirm,
                  style: TextButton.styleFrom(
                    backgroundColor: OnbStyle.ink,
                    foregroundColor: const Color(0xFF111110),
                    disabledBackgroundColor:
                        OnbStyle.ink.withValues(alpha: 0.5),
                    shape: const StadiumBorder(),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF111110),
                          ),
                        )
                      : const Text(
                          'c\'est parti',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                ),
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
        Text(label.toLowerCase(), style: OnbStyle.overline),
        const SizedBox(height: 2),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: OnbStyle.hairline)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF171716),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: OnbStyle.ink,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: OnbStyle.ink.withValues(alpha: 0.4),
              ),
              items: List.generate(
                24,
                (h) => DropdownMenuItem(value: h, child: Text('${h}h00')),
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
