import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/theme/theme_cubit.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = context.watch<ThemeCubit>().state;

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
                    'Apparence',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _SectionLabel('THÈME', colors),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _ThemeRow(
                          icon: Icons.brightness_auto_outlined,
                          title: 'Système',
                          subtitle: 'Suit les réglages de l\'appareil',
                          mode: ThemeMode.system,
                          current: current,
                          colors: colors,
                          preview: _ThemePreview.system,
                        ),
                        Divider(height: 1, thickness: 1, indent: 58, color: colors.border),
                        _ThemeRow(
                          icon: Icons.light_mode_outlined,
                          title: 'Clair',
                          subtitle: 'Interface blanche',
                          mode: ThemeMode.light,
                          current: current,
                          colors: colors,
                          preview: _ThemePreview.light,
                        ),
                        Divider(height: 1, thickness: 1, indent: 58, color: colors.border),
                        _ThemeRow(
                          icon: Icons.dark_mode_outlined,
                          title: 'Sombre',
                          subtitle: 'Interface noire',
                          mode: ThemeMode.dark,
                          current: current,
                          colors: colors,
                          preview: _ThemePreview.dark,
                        ),
                      ],
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

enum _ThemePreview { light, dark, system }

class _ThemeRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeMode mode;
  final ThemeMode current;
  final AppColors colors;
  final _ThemePreview preview;

  const _ThemeRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.current,
    required this.colors,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == mode;

    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().setTheme(mode),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icône
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: colors.primary),
            ),
            const SizedBox(width: 13),
            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: colors.secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Mini preview
            _MiniPreview(type: preview),
            const SizedBox(width: 12),
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? colors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? colors.primary : colors.secondary,
                  width: 2,
                ),
              ),
              child: selected
                  ? Icon(Icons.check, size: 12, color: colors.scaffold)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPreview extends StatelessWidget {
  final _ThemePreview type;
  const _MiniPreview({required this.type});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 36,
        height: 24,
        child: switch (type) {
          _ThemePreview.light => Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  Container(height: 8, color: Colors.white),
                  const Spacer(),
                  Container(
                    height: 3,
                    margin: const EdgeInsets.fromLTRB(4, 0, 4, 3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          _ThemePreview.dark => Container(
              color: const Color(0xFF111111),
              child: Column(
                children: [
                  Container(height: 8, color: const Color(0xFF1C1C1C)),
                  const Spacer(),
                  Container(
                    height: 3,
                    margin: const EdgeInsets.fromLTRB(4, 0, 4, 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          _ThemePreview.system => Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      children: [
                        Container(height: 8, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFF111111),
                    child: Column(
                      children: [
                        Container(height: 8, color: const Color(0xFF1C1C1C)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
