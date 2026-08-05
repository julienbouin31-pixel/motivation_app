import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Direction de l'onboarding, alignée sur le logo "curves" : sans géométrique
/// light en grands énoncés, monochrome neutre, filets fins qui font écho au
/// tracé du nœud, ornements réduits au strict minimum.
abstract final class AppStyle {
  static const Color bg = Color(0xFF0A0A0A);
  static const Color ink = Color(0xFFF4F4F1); // blanc doux neutre
  static const Color dim = Color(0xFF8B8B87); // gris neutre secondaire
  static const Color hairline = Color(0x26F4F4F1); // filets / séparateurs
  static const Color accent = Color(0xFFE0A96D); // ocre doux — à petites doses

  static TextStyle display({double size = 34}) => GoogleFonts.urbanist(
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: ink,
        height: 1.25,
        letterSpacing: 0.2,
      );

  /// Style d'accent (mots mis en valeur) : même géométrique, en italique.
  static TextStyle displayItalic({double size = 34}) => GoogleFonts.urbanist(
        fontSize: size,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: ink,
        height: 1.25,
        letterSpacing: 0.2,
      );

  static final TextStyle body = TextStyle(
    fontSize: 15,
    color: ink.withValues(alpha: 0.55),
    height: 1.6,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10.5,
    color: dim,
    letterSpacing: 2.6,
    fontWeight: FontWeight.w600,
  );
}

/// Filet horizontal qui se dessine de gauche à droite après [delay].
class AnimatedHairline extends StatelessWidget {
  final Duration delay;
  final Duration duration;

  const AnimatedHairline({
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    final total = delay + duration;
    final start = delay.inMilliseconds / total.inMilliseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, value, _) => Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value,
          child: const Divider(color: AppStyle.hairline, height: 1),
        ),
      ),
    );
  }
}

/// Ligne sélectionnable façon sommaire : texte + point ocre quand choisi,
/// séparée par un filet. Remplace les anciennes cartes "verre dépoli".
class SelectableRow extends StatelessWidget {
  final String label;
  final String? sublabel;
  final bool selected;
  final VoidCallback onTap;

  /// Réservé au premium : affiche un cadenas discret au lieu du point de
  /// sélection (le tap ouvre alors typiquement le paywall).
  final bool locked;

  const SelectableRow({
    super.key,
    required this.label,
    this.sublabel,
    required this.selected,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppStyle.hairline)),
        ),
        padding: EdgeInsets.symmetric(vertical: sublabel == null ? 16 : 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? AppStyle.ink
                          : AppStyle.ink.withValues(alpha: 0.55),
                      letterSpacing: -0.2,
                    ),
                    child: Text(label),
                  ),
                  if (sublabel != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sublabel!,
                      style: const TextStyle(fontSize: 13, color: AppStyle.dim),
                    ),
                  ],
                ],
              ),
            ),
            if (locked)
              Icon(
                Icons.lock_outline,
                size: 15,
                color: AppStyle.ink.withValues(alpha: 0.3),
              )
            else
              AnimatedScale(
                duration: const Duration(milliseconds: 380),
                curve: Curves.elasticOut,
                scale: selected ? 1 : 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppStyle.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
