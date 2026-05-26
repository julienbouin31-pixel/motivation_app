import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_cubit.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_state.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({super.key});

  static String fmtRevenue(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      final rounded = (k * 10).round() / 10;
      return rounded == rounded.truncateToDouble()
          ? '${rounded.toStringAsFixed(0)}K€'
          : '${rounded.toStringAsFixed(1)}K€';
    }
    return '${amount.toStringAsFixed(0)}€';
  }

  static String fmtCount(double count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(1)}K';
    }
    return count.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCubit, GoalState>(
      builder: (context, state) {
        return switch (state) {
          GoalLoaded(:final data) => data.current >= data.target
              ? _GoalAchieved(
                  current: data.current,
                  target: data.target,
                )
              : _GoalBar(
                  current: data.current,
                  target: data.target,
                  changePct: data.changePct,
                ),
          GoalLoading() => const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                height: 40,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4CAF50)),
                  ),
                ),
              ),
            ),
          GoalError(:final message) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                message,
                style: TextStyle(fontSize: 11, color: Colors.red.shade300),
                textAlign: TextAlign.center,
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

// ─── Objectif atteint ─────────────────────────────────────────────────────────

class _GoalAchieved extends StatelessWidget {
  final double current;
  final double target;

  const _GoalAchieved({
    required this.current,
    required this.target,
  });

  String _affirmation(String currentLabel, String targetLabel) {
    const messages = [
      'Tu as dépassé {target}/mois. Relève la barre.',
      'Objectif {target} atteint. Maintenant vise plus haut.',
      '{current}/mois — tu es là où tu voulais être.',
      'Tu génères {current}. L\'objectif {target} est derrière toi.',
      'De l\'ambition, encore. {current}/mois, c\'est ton nouveau plancher.',
    ];
    final idx = (current.toInt() + target.toInt()) % messages.length;
    return messages[idx]
        .replaceAll('{current}', currentLabel)
        .replaceAll('{target}', targetLabel);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLabel = GoalProgressBar.fmtRevenue(current);
    final targetLabel = GoalProgressBar.fmtRevenue(target);

    const green = Color(0xFF4CAF50);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onTap: () => context.push(AppRouter.editProfile),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B3A1C) : const Color(0xFFD6F0D8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: green.withValues(alpha: 0.45)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icône
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('✦', style: TextStyle(fontSize: 14, color: green)),
                ),
              ),
              const SizedBox(width: 12),
              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OBJECTIF DÉPASSÉ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: green,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _affirmation(currentLabel, targetLabel),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0A2E0B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 12, color: green),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Barre de progression normale ─────────────────────────────────────────────

class _GoalBar extends StatelessWidget {
  final double current;
  final double target;
  final double changePct;

  const _GoalBar({
    required this.current,
    required this.target,
    required this.changePct,
  });

  @override
  Widget build(BuildContext context) {
    const label = 'MRR mensuel';
    final currentLabel = GoalProgressBar.fmtRevenue(current);
    final targetLabel = GoalProgressBar.fmtRevenue(target);
    final double progress = (current / target).clamp(0.0, 1.0);
    final int pct = (progress * 100).round();
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? const Color(0x1FFFFFFF) : const Color(0xFFE8F5E9);

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
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.secondary,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                currentLabel,
                style: TextStyle(
                  fontSize: 14,
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
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: trackColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
