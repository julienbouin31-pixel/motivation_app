import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
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
    final colors = Theme.of(context).extension<AppColors>()!;
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
              // ─── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      'Réglages',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    // ── Carte profil ────────────────────────────────────────
                    GestureDetector(
                      onTap: () => context.push(AppRouter.editProfile),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                name ?? '—',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 20, color: Colors.white.withValues(alpha: 0.3)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Streak ──────────────────────────────────────────────
                    _StreakCard(streak: streak),

                    const SizedBox(height: 28),

                    // ── Section Affirmations ────────────────────────────────
                    const _SectionLabel('AFFIRMATIONS'),
                    const SizedBox(height: 8),
                    const _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.favorite_outline,
                          title: 'Mes favoris',
                          subtitle: 'Affirmations sauvegardées',
                          route: AppRouter.affirmationFavorites,
                        ),
                        _SettingsItem(
                          icon: Icons.edit_note_rounded,
                          title: 'Mes affirmations',
                          subtitle: 'Créer des affirmations perso',
                          route: AppRouter.affirmationCustom,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Section Personnalisation ────────────────────────────
                    const _SectionLabel('PERSONNALISATION'),
                    const SizedBox(height: 8),
                    const _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.widgets_outlined,
                          title: 'Widgets',
                          subtitle: 'Écran d\'accueil & verrouillage',
                          route: AppRouter.widgets,
                        ),
                        _SettingsItem(
                          icon: Icons.palette_outlined,
                          title: 'Apparence',
                          subtitle: 'Thème & couleurs',
                          route: AppRouter.appearance,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Section Notifications ───────────────────────────────
                    const _SectionLabel('NOTIFICATIONS'),
                    const SizedBox(height: 8),
                    const _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: 'Rappels quotidiens',
                          subtitle: 'Heure & fréquence',
                          route: AppRouter.notifications,
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // ── Debug ───────────────────────────────────────────────
                    GestureDetector(
                      onTap: () async {
                        final local = di.sl<AffirmationLocalDataSource>();
                        await local.clearAll();
                        unawaited(di.sl<AffirmationRepository>().weeklyRefreshInBackground());
                        await NotificationService.cancelAll();
                        await di.sl<SecureStorage>().deleteAll();
                        di.sl<OnboardingCubit>().reset();
                        if (context.mounted) context.go(AppRouter.home);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
                        ),
                        child: const Center(
                          child: Text(
                            '🧪 Reset onboarding (debug)',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
      ),
    );
  }
}

// ─── Composants ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String route;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.route,
  });
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsRow(item: items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 54,
                color: Colors.white.withValues(alpha: 0.06),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final _SettingsItem item;
  const _SettingsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 17, color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

// ─── Carte Streak ─────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIndex = DateTime.now().weekday - 1; // 0=Lun … 6=Dim
    final isOnFire = streak >= 2;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icône + Chiffre + label ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOnFire
                      ? const Color(0xFFFF9500).withValues(alpha: 0.15)
                      : const Color(0xFF4FC3F7).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOnFire ? Icons.local_fire_department : Icons.ac_unit,
                  size: 22,
                  color: isOnFire ? const Color(0xFFFF9500) : const Color(0xFF4FC3F7),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                      letterSpacing: -2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Série',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // ── Jours de la semaine ──────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (i) {
              final isToday = i == todayIndex;
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    Text(
                      days[i],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isToday ? Colors.white : Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday
                            ? const Color(0xFF4CAF50).withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.06),
                        border: Border.all(
                          color: isToday
                              ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: isToday
                          ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
