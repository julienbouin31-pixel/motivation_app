import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
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
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };

    final name = profile?.name ?? '—';
    final objectiveType = profile?.objectiveType ?? '—';
    final mrrTarget = profile?.mrrTarget ?? '—';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───────────────────────────────────────────────────────
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
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Réglages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ─── Contenu scrollable ───────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // ── Carte profil ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
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
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$objectiveType · $mrrTarget',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 20, color: Colors.grey[300]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Section Personnalisation ───────────────────────────────
                  const _SectionLabel('PERSONNALISATION'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    items: [
                      _SettingsItem(
                        icon: Icons.widgets_outlined,
                        title: 'Widgets',
                        subtitle: 'Écran d\'accueil & verrouillage',
                        badge: 'Bientôt',
                      ),
                      _SettingsItem(
                        icon: Icons.palette_outlined,
                        title: 'Apparence',
                        subtitle: 'Thème & couleurs',
                        badge: 'Bientôt',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Section Notifications ──────────────────────────────────
                  const _SectionLabel('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
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
                  const _SectionLabel('COMPTE'),
                  const SizedBox(height: 8),
                  _SettingsGroup(
                    items: [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: 'Modifier le profil',
                        subtitle: 'Nom, objectif, cible MRR',
                        badge: 'Bientôt',
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
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey[400],
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.onTap,
  });
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsRow(item: items[i]),
            if (i < items.length - 1)
              Divider(height: 1, thickness: 1, indent: 54, color: Colors.grey[100]),
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
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Icône dans un carré arrondi
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 17, color: Colors.black87),
            ),
            const SizedBox(width: 13),
            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: item.onTap == null && item.badge == null
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge "Bientôt" ou chevron
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right, size: 18, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
