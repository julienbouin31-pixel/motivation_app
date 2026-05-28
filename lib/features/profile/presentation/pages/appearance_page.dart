import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
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
                  _SectionLabel('THÈME VISUEL', colors),
                  const SizedBox(height: 12),

                  // ── Grille thèmes de carte ────────────────────────────────
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.78,
                    children: CardVisualTheme.values.map((theme) {
                      final data = theme.data;
                      final selected = currentCardTheme == theme;
                      return GestureDetector(
                        onTap: () => context.read<CardThemeCubit>().setTheme(theme),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? colors.primary : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13.5),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Fond
                                if (data.isAdaptive)
                                  Container(color: colors.card)
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: data.gradientColors,
                                        begin: data.begin,
                                        end: data.end,
                                      ),
                                    ),
                                  ),

                                // Préview contenu
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Lignes simulant du texte
                                      Container(
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: (data.isAdaptive
                                                  ? colors.primary
                                                  : data.textColor)
                                              .withValues(alpha: 0.55),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 3,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: (data.isAdaptive
                                                  ? colors.primary
                                                  : data.textColor)
                                              .withValues(alpha: 0.35),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Boutons simulés
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _MiniButton(
                                            bg: data.isAdaptive
                                                ? colors.surface
                                                : data.buttonBg,
                                          ),
                                          const SizedBox(width: 6),
                                          _MiniButton(
                                            bg: data.isAdaptive
                                                ? colors.surface
                                                : data.buttonBg,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
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
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                      color: data.isAdaptive
                                          ? colors.secondary
                                          : data.textColor.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ),

                                // Checkmark
                                if (selected)
                                  Positioned(
                                    top: 7,
                                    right: 7,
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

class _MiniButton extends StatelessWidget {
  final Color bg;
  const _MiniButton({required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    );
  }
}
