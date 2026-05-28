import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/onboarding/onboarding_flow.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/back_button_widget.dart';
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
    (freq: 1, label: '1x par jour', sub: 'Le matin pour bien commencer'),
    (freq: 3, label: '3x par jour', sub: 'Matin, midi et soir'),
    (freq: 5, label: '5x par jour', sub: 'Boost régulier'),
  ];

  Future<void> _confirm() async {
    if (_saving) return;
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
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header fixe ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const BackButtonWidget(),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProgressIndicatorBar(
                    currentStep: OnboardingFlow.progress(AppRouter.onboardingNotifications).step,
                    totalSteps: OnboardingFlow.progress(AppRouter.onboardingNotifications).total,
                  ),
                ],
              ),
            ),

            // ─── Contenu scrollable ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.notifications_outlined,
                          size: 22, color: colors.primary),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Tes rappels',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: colors.primary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Quand veux-tu recevoir tes affirmations ?',
                      style: TextStyle(
                          fontSize: 14,
                          color: colors.secondary,
                          height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    _SectionLabel('FRÉQUENCE', colors),
                    const SizedBox(height: 8),
                    ..._freqOptions.map((opt) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _FrequencyCard(
                            label: opt.label,
                            sub: opt.sub,
                            selected: _frequency == opt.freq,
                            colors: colors,
                            onTap: () =>
                                setState(() => _frequency = opt.freq),
                          ),
                        )),

                    const SizedBox(height: 20),
                    _SectionLabel('PLAGE HORAIRE', colors),
                    const SizedBox(height: 4),
                    Text(
                      'Tes rappels seront envoyés entre ces heures',
                      style:
                          TextStyle(fontSize: 13, color: colors.secondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _HourPicker(
                            label: 'De',
                            value: _startHour,
                            colors: colors,
                            onChanged: (h) =>
                                setState(() => _startHour = h),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _HourPicker(
                            label: 'À',
                            value: _endHour,
                            colors: colors,
                            onChanged: (h) => setState(() => _endHour = h),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── CTA fixe en bas ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: _CtaButton(
                saving: _saving,
                onPressed: _confirm,
                colors: colors,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
              items: List.generate(24, (h) => DropdownMenuItem(
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

class _CtaButton extends StatelessWidget {
  final bool saving;
  final VoidCallback onPressed;
  final AppColors colors;

  const _CtaButton({
    required this.saving,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: saving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.scaffold,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: saving
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.scaffold,
                ),
              )
            : const Text(
                'C\'est parti ! 🚀',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
