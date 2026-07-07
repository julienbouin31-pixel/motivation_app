import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };

    final name = (profile?.name?.isNotEmpty == true) ? profile!.name! : null;
    final initial = (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '?';
    final streak = context.watch<StreakCubit>().state;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
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
                  Text('réglages', style: AppStyle.display(size: 30)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
                children: [
                  // ── Profil ──────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => context.push(AppRouter.editProfile),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppStyle.hairline),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppStyle.hairline),
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: AppStyle.display(size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              name ?? '—',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: AppStyle.ink,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              size: 18,
                              color: AppStyle.ink.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Streak ──────────────────────────────────────────────
                  _StreakCard(streak: streak),

                  const SizedBox(height: 36),

                  // ── Affirmations ────────────────────────────────────────
                  const Text('affirmations', style: AppStyle.overline),
                  const SizedBox(height: 4),
                  const _SettingsRow(
                    title: 'Mes favoris',
                    subtitle: 'Affirmations sauvegardées',
                    route: AppRouter.affirmationFavorites,
                  ),
                  const _SettingsRow(
                    title: 'Mes affirmations',
                    subtitle: 'Créer des affirmations perso',
                    route: AppRouter.affirmationCustom,
                  ),

                  const SizedBox(height: 32),

                  // ── Personnalisation ────────────────────────────────────
                  const Text('personnalisation', style: AppStyle.overline),
                  const SizedBox(height: 4),
                  const _SettingsRow(
                    title: 'Widgets',
                    subtitle: 'Écran d\'accueil & verrouillage',
                    route: AppRouter.widgets,
                  ),
                  const _SettingsRow(
                    title: 'Apparence',
                    subtitle: 'Thème & couleurs',
                    route: AppRouter.appearance,
                  ),

                  const SizedBox(height: 32),

                  // ── Notifications ───────────────────────────────────────
                  const Text('notifications', style: AppStyle.overline),
                  const SizedBox(height: 4),
                  const _SettingsRow(
                    title: 'Rappels quotidiens',
                    subtitle: 'Heure & fréquence',
                    route: AppRouter.notifications,
                  ),

                  const SizedBox(height: 44),

                  // ── Debug ───────────────────────────────────────────────
                  GestureDetector(
                    onTap: () async {
                      final local = di.sl<AffirmationLocalDataSource>();
                      await local.clearAll();
                      await NotificationService.cancelAll();
                      await di.sl<SecureStorage>().deleteAll();
                      unawaited(di
                          .sl<AffirmationRepository>()
                          .weeklyRefreshInBackground());
                      di.sl<OnboardingCubit>().reset();
                      if (context.mounted) {
                        context.go(AppRouter.onboardingWelcome);
                      }
                    },
                    child: Center(
                      child: Text(
                        'réinitialiser l\'application',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade400.withValues(alpha: 0.8),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Rangée de réglage sur filet ──────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String route;

  const _SettingsRow({
    required this.title,
    this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppStyle.hairline)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppStyle.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppStyle.dim,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18, color: AppStyle.ink.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

// ─── Série ────────────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIndex = DateTime.now().weekday - 1; // 0=Lun … 6=Dim

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppStyle.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Chiffre + label ──────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak',
                style: AppStyle.display(size: 40).copyWith(height: 1),
              ),
              const SizedBox(height: 4),
              const Text('jours de série', style: AppStyle.overline),
            ],
          ),

          const SizedBox(width: 16),

          // ── Jours de la semaine ──────────────────────────────────────
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (i) {
              final isToday = i == todayIndex;
              // Jour couvert par la série : les `streak` derniers jours,
              // en remontant depuis aujourd'hui (sans déborder sur la
              // semaine précédente, non affichée ici).
              final distance = todayIndex - i;
              final isDone = distance >= 0 && distance < streak;
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    Text(
                      days[i],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isDone || isToday
                            ? AppStyle.ink
                            : AppStyle.ink.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppStyle.accent : Colors.transparent,
                        border: Border.all(
                          color: isDone
                              ? AppStyle.accent
                              : isToday
                                  ? AppStyle.ink.withValues(alpha: 0.45)
                                  : AppStyle.hairline,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              size: 12, color: Color(0xFF111110))
                          : null,
                    ),
                  ],
                ),
              );
            }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
