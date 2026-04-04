import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class GoalProgressBar extends StatelessWidget {
  final String? objectiveType;
  final String? target;

  const GoalProgressBar({
    super.key,
    required this.objectiveType,
    this.target,
  });

  // Valeurs mock fixes — indépendantes du target
  static const double mockMrrCurrent = 1350;
  static const double mockAnalyticsCurrent = 3412;

  static double _parseTarget(String? target, {bool isAnalytics = false}) {
    if (target == null) return isAnalytics ? 10000 : 5000;
    final t = target
        .toUpperCase()
        .replaceAll('€', '')
        .replaceAll('+', '')
        .replaceAll('/MOIS', '')
        .trim();
    if (t.endsWith('K')) {
      return (double.tryParse(t.replaceAll('K', '')) ?? (isAnalytics ? 10 : 5)) * 1000;
    }
    return double.tryParse(t) ?? (isAnalytics ? 10000 : 5000);
  }

  static String _fmtRevenue(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      final rounded = (k * 10).round() / 10;
      return rounded == rounded.truncateToDouble()
          ? '${rounded.toStringAsFixed(0)}K€'
          : '${rounded.toStringAsFixed(1)}K€';
    }
    return '${amount.toStringAsFixed(0)}€';
  }

  static String _fmtCount(double count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(1)}K';
    }
    return count.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (objectiveType == null || objectiveType == 'none') {
      return const SizedBox.shrink();
    }

    final isMrr = objectiveType == 'mrr';

    final double targetValue;
    final double currentValue;
    final String label;
    final String currentLabel;
    final String targetLabel;

    if (isMrr) {
      targetValue = _parseTarget(target);
      currentValue = mockMrrCurrent;
      label = 'MRR mensuel';
      currentLabel = _fmtRevenue(currentValue);
      targetLabel = _fmtRevenue(targetValue);
    } else {
      targetValue = _parseTarget(target, isAnalytics: true);
      currentValue = mockAnalyticsCurrent;
      label = 'Visiteurs ce mois-ci';
      currentLabel = _fmtCount(currentValue);
      targetLabel = _fmtCount(targetValue);
    }

    final double progress = (currentValue / targetValue).clamp(0.0, 1.0);
    final int pct = (progress * 100).round();
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.secondary,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Text(
                currentLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              Text(
                ' / $targetLabel',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Color(0xFFE8F5E9),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
