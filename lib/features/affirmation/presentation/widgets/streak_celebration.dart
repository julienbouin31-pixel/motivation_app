import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivation_app/config/themes/app_style.dart';

/// Affiche la célébration de série sous forme de bottom sheet qui monte du bas.
Future<void> showStreakCelebration(BuildContext context, int count) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    isScrollControlled: true,
    builder: (_) => _StreakSheet(count: count),
  );
}

class _StreakSheet extends StatelessWidget {
  final int count;
  const _StreakSheet({required this.count});

  String get _message {
    switch (count) {
      case 1:
        return 'ta série commence. reviens demain pour la faire grandir.';
      case 7:
        return 'une semaine d\'affilée. la régularité paie.';
      case 30:
        return 'un mois entier. c\'est devenu une habitude.';
      case 100:
        return 'cent jours. chapeau.';
      default:
        return 'continue comme ça, un jour à la fois.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141413),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(28, 12, 28, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppStyle.ink.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 34),

          // Flamme discrète
          const Icon(
            Icons.local_fire_department_rounded,
            size: 30,
            color: AppStyle.accent,
          ),
          const SizedBox(height: 18),

          // Grand chiffre animé
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.7, end: 1),
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: scale.clamp(0.0, 1.0),
                child: child,
              ),
            ),
            child: Text(
              '$count',
              style: AppStyle.display(size: 68).copyWith(height: 1),
            ),
          ),
          const SizedBox(height: 6),
          const Text('jours de série', style: AppStyle.overline),

          const SizedBox(height: 16),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppStyle.ink.withValues(alpha: 0.6),
            ),
          ),

          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppStyle.ink,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  'continuer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111110),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
