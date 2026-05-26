import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_cubit.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_state.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };

    final affirmationText = 'Ship it. Learn it. Iterate.';
    final category = 'général';
    final hasGoal = profile?.stripeApiKey != null;

    // Get real data from GoalCubit, fallback to placeholder
    final goalState = context.watch<GoalCubit>().state;
    final goalData = switch (goalState) {
      GoalLoaded(:final data) => data,
      _ => null,
    };
    final goalCurrent = goalData?.current ?? 0.0;
    final goalTarget = goalData?.target ?? 5000.0;
    final goalChangePct = goalData?.changePct ?? 0.0;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────────────────────
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
                    'Widgets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Contenu ─────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // ── Instructions ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(Icons.widgets, size: 18, color: colors.scaffold),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Comment ajouter un widget',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _Step(number: '1', text: 'Appuie longuement sur l\'écran d\'accueil', colors: colors),
                        _Step(number: '2', text: 'Tape "+" en haut à gauche', colors: colors),
                        _Step(number: '3', text: 'Recherche "Motivation" dans la liste', colors: colors),
                        _Step(number: '4', text: 'Choisis le widget et appuie sur Ajouter', colors: colors),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Petits widgets ────────────────────────────────────────
                  _SectionLabel('PETITS WIDGETS  2×2', colors),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _WidgetPreviewSmall(
                          label: 'Affirmation',
                          child: _AffirmationMini(text: affirmationText, category: category),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _WidgetPreviewSmall(
                          label: hasGoal ? 'MRR' : 'Objectif',
                          child: _GoalMini(
                            current: goalCurrent,
                            target: goalTarget,
                            changePct: goalChangePct,
                            isMrr: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Widget combiné ────────────────────────────────────────
                  _SectionLabel('WIDGET COMBINÉ  4×2', colors),
                  const SizedBox(height: 12),
                  _WidgetPreviewMedium(
                    label: 'MRR + Affirmation',
                    child: _CombinedMini(
                      text: affirmationText,
                      category: category,
                      current: goalCurrent,
                      target: goalTarget,
                      changePct: goalChangePct,
                      isMrr: true,
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

// ─── Section label ────────────────────────────────────────────────────────────

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

// ─── Step item ────────────────────────────────────────────────────────────────

class _Step extends StatelessWidget {
  final String number;
  final String text;
  final AppColors colors;
  const _Step({required this.number, required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: colors.secondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget preview containers ────────────────────────────────────────────────

class _WidgetPreviewSmall extends StatelessWidget {
  final String label;
  final Widget child;
  const _WidgetPreviewSmall({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WidgetPreviewMedium extends StatelessWidget {
  final String label;
  final Widget child;
  const _WidgetPreviewMedium({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Widget dark background ───────────────────────────────────────────────────

const _kBg = Color(0xFF161616);
const _kGreen = Color(0xFF4CAF50);
const _kSecondary = Color(0x62FFFFFF);
const _kTrack = Color(0x1FFFFFFF);

class _MiniProgressBar extends StatelessWidget {
  final double progress;
  const _MiniProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          Container(height: 3, decoration: BoxDecoration(color: _kTrack, borderRadius: BorderRadius.circular(2))),
          Container(
            height: 3,
            width: (c.maxWidth * progress).clamp(4.0, c.maxWidth),
            decoration: BoxDecoration(color: _kGreen, borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
    );
  }
}

// ─── Affirmation mini ─────────────────────────────────────────────────────────

class _AffirmationMini extends StatelessWidget {
  final String text;
  final String category;
  const _AffirmationMini({required this.text, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u201C',
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Color(0x1EFFFFFF),
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, height: 1.4),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '— $category',
            style: const TextStyle(fontSize: 10, color: _kSecondary, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

// ─── Goal mini ────────────────────────────────────────────────────────────────

class _GoalMini extends StatelessWidget {
  final double current;
  final double target;
  final double changePct;
  final bool isMrr;
  const _GoalMini({
    required this.current,
    required this.target,
    required this.changePct,
    required this.isMrr,
  });

  String _fmt(double v) {
    if (v >= 1000) {
      final k = (v / 1000 * 10).round() / 10;
      final s = k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1).replaceAll('.', ',')}K';
      return isMrr ? '$s€' : s;
    }
    return isMrr ? '${v.toInt()}€' : '${v.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    final sign = changePct >= 0 ? '+' : '';
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isMrr ? 'MRR' : 'VISITES',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _kSecondary, letterSpacing: 0.6),
              ),
              const Spacer(),
              const Icon(Icons.arrow_upward, size: 12, color: _kGreen),
            ],
          ),
          const Spacer(),
          Text(
            _fmt(current),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '$sign${changePct.toInt()}% ce mois',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _kGreen),
          ),
          const SizedBox(height: 8),
          _MiniProgressBar(progress: progress),
        ],
      ),
    );
  }
}

// ─── Combined mini ────────────────────────────────────────────────────────────

class _CombinedMini extends StatelessWidget {
  final String text;
  final String category;
  final double current;
  final double target;
  final double changePct;
  final bool isMrr;
  const _CombinedMini({
    required this.text,
    required this.category,
    required this.current,
    required this.target,
    required this.changePct,
    required this.isMrr,
  });

  String _fmt(double v) {
    if (v >= 1000) {
      final k = (v / 1000 * 10).round() / 10;
      final s = k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1).replaceAll('.', ',')}K';
      return isMrr ? '$s€' : s;
    }
    return isMrr ? '${v.toInt()}€' : '${v.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    final sign = changePct >= 0 ? '+' : '';
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: value + change
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fmt(current),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.arrow_upward, size: 10, color: _kGreen),
                      const SizedBox(width: 2),
                      Text(
                        '$sign${changePct.toInt()}%',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kGreen),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Right: label + progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isMrr ? 'MRR' : 'VISITES',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _kSecondary, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 60,
                    child: _MiniProgressBar(progress: progress),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Quote
          Text(
            '"$text"',
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Color(0xCCFFFFFF),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '— $category',
            style: const TextStyle(fontSize: 10, color: _kSecondary, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
