import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_seed.dart';
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
    final objectiveType = profile?.objectiveType;
    final mrrTarget = profile?.mrrTarget;
    final analyticsTarget = profile?.analyticsTarget;
    final initial = (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '?';

    final objectiveLabel = switch (objectiveType) {
      'mrr' => 'MRR',
      'analytics' => 'Analytics',
      _ => null,
    };
    final subtitle = [
      if (objectiveLabel != null) objectiveLabel,
      if (objectiveType == 'mrr' && mrrTarget != null && mrrTarget.isNotEmpty) mrrTarget,
      if (objectiveType == 'analytics' && analyticsTarget != null && analyticsTarget.isNotEmpty)
        analyticsTarget,
    ].join(' · ');

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      child: Icon(Icons.arrow_back, size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Réglages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
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
                  // ── Carte profil ──────────────────────────────────────────
                  GestureDetector(
                    onTap: () => context.push(AppRouter.editProfile),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Avatar — toujours noir/blanc (élément de brand)
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Colors.black,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name ?? '—',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                                if (subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.secondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 20, color: colors.secondary),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Section Personnalisation ───────────────────────────────
                  _SectionLabel('PERSONNALISATION', colors),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    colors: colors,
                    items: [
                      _SettingsItem(
                        icon: Icons.widgets_outlined,
                        title: 'Widgets',
                        subtitle: 'Écran d\'accueil & verrouillage',
                        onTap: () => context.push(AppRouter.widgets),
                      ),
                      _SettingsItem(
                        icon: Icons.palette_outlined,
                        title: 'Apparence',
                        subtitle: 'Thème & couleurs',
                        onTap: () => context.push(AppRouter.appearance),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Section Notifications ──────────────────────────────────
                  _SectionLabel('NOTIFICATIONS', colors),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    colors: colors,
                    items: [
                      _SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'Rappels quotidiens',
                        subtitle: 'Heure & fréquence',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Section Compte ─────────────────────────────────────────
                  _SectionLabel('COMPTE', colors),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    colors: colors,
                    items: [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: 'Modifier le profil',
                        subtitle: 'Nom, objectif, cible',
                        onTap: () => context.push(AppRouter.editProfile),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // ── Debug ──────────────────────────────────────────────────
                  GestureDetector(
                    onTap: () async {
                      final local = di.sl<AffirmationLocalDataSource>();
                      await local.clearAll();
                      await seedAffirmationsIfEmpty(local);
                      await di.sl<SecureStorage>().deleteAll();
                      di.sl<OnboardingCubit>().reset();
                      if (context.mounted) context.go(AppRouter.home);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
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
    );
  }
}

// ─── Composants ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColors colors;
  const _SectionLabel(this.label, this.colors);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.secondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  final AppColors colors;
  const _SettingsGroup({required this.items, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsRow(item: items[i], colors: colors),
            if (i < items.length - 1)
              Divider(height: 1, thickness: 1, indent: 54, color: colors.border),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final _SettingsItem item;
  final AppColors colors;
  const _SettingsRow({required this.item, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 17, color: colors.primary),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(fontSize: 12, color: colors.secondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: colors.secondary),
          ],
        ),
      ),
    );
  }
}
