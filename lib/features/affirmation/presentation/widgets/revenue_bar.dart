import 'package:flutter/material.dart';

class GoalProgressBar extends StatelessWidget {
  final String? objectiveType;
  final String? target;

  const GoalProgressBar({
    super.key,
    required this.objectiveType,
    this.target,
  });

  static double _parseTarget(String? target) {
    if (target == null) return 5000;
    final t = target.toUpperCase().replaceAll('€', '').replaceAll('+', '').trim();
    if (t.endsWith('K')) {
      return (double.tryParse(t.replaceAll('K', '')) ?? 5) * 1000;
    }
    return double.tryParse(t) ?? 5000;
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
      currentValue = (targetValue * 0.27).roundToDouble();
      label = 'MRR mensuel';
      currentLabel = _fmtRevenue(currentValue);
      targetLabel = _fmtRevenue(targetValue);
    } else {
      targetValue = 10000;
      currentValue = 3412;
      label = 'Visiteurs ce mois-ci';
      currentLabel = _fmtCount(currentValue);
      targetLabel = _fmtCount(targetValue);
    }

    final double progress = (currentValue / targetValue).clamp(0.0, 1.0);
    final int pct = (progress * 100).round();

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
                  color: Colors.grey[400],
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Text(
                currentLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                ' / $targetLabel',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
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
