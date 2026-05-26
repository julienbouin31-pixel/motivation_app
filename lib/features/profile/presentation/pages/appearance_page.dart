import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/core/theme/theme_cubit.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = context.watch<ThemeCubit>().state;
    final currentCardTheme = context.watch<CardThemeCubit>().state;

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

                  const SizedBox(height: 28),

                  // ── Thème visuel carte ──────────────────────────────────
                  _SectionLabel('THÈME VISUEL', colors),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                    children: CardVisualTheme.values.map((theme) {
                      final data = theme.data;
                      final selected = currentCardTheme == theme;
                      return GestureDetector(
                        onTap: () => context.read<CardThemeCubit>().setTheme(theme),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? colors.primary : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Fond
                                theme.isAdaptive
                                    ? Container(color: colors.card)
                                    : Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: data.gradientColors,
                                            begin: data.begin,
                                            end: data.end,
                                          ),
                                        ),
                                      ),
                                // Contenu preview
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 3,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: theme.isAdaptive
                                              ? colors.primary.withValues(alpha: 0.5)
                                              : data.textColor.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 3,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: theme.isAdaptive
                                              ? colors.primary.withValues(alpha: 0.3)
                                              : data.textColor.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: theme.isAdaptive
                                                  ? colors.surface
                                                  : data.buttonBg,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: theme.isAdaptive
                                                  ? colors.surface
                                                  : data.buttonBg,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Nom du thème
                                Positioned(
                                  bottom: 7,
                                  left: 0,
                                  right: 0,
                                  child: Text(
                                    data.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: theme.isAdaptive
                                          ? colors.secondary
                                          : data.textColor.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ),
                                // Checkmark
                                if (selected)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 11,
                                        color: colors.scaffold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
              color: const Color(0xFFF0EDE7),
              child: Column(
                children: [
                  Container(height: 8, color: const Color(0xFFF8F6F1)),
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
                    color: const Color(0xFFF0EDE7),
                    child: Column(
                      children: [
                        Container(height: 8, color: const Color(0xFFF8F6F1)),
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
