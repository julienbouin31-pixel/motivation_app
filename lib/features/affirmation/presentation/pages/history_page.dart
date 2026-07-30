import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/models/affirmation_model.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:motivation_app/injection_container.dart' as di;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final Future<List<AffirmationModel>> _future =
      di.sl<AffirmationLocalDataSource>().getViewed();

  @override
  Widget build(BuildContext context) {
    final onboardingState = context.watch<OnboardingCubit>().state;
    final profile = switch (onboardingState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final userName = profile?.name ?? 'toi';

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppStyle.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('historique', style: AppStyle.display(size: 30)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<AffirmationModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppStyle.dim),
                    );
                  }
                  final items = snapshot.data!;
                  if (items.isEmpty) return const _EmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
                    itemCount: items.length,
                    itemBuilder: (context, i) =>
                        _HistoryRow(item: items[i], userName: userName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final AffirmationModel item;
  final String userName;
  const _HistoryRow({required this.item, required this.userName});

  String get _categoryLabel {
    try {
      return AffirmationCategory.values.byName(item.category).label.toLowerCase();
    } catch (_) {
      return item.category.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = item.text.replaceAll('{name}', userName);

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppStyle.hairline)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            style: AppStyle.display(size: 16).copyWith(height: 1.5),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(_categoryLabel, style: AppStyle.overline),
              const SizedBox(width: 8),
              Text('·', style: AppStyle.overline),
              const SizedBox(width: 8),
              Text(_relative(item.lastViewedAt), style: AppStyle.overline),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppStyle.hairline),
            ),
            child: Icon(
              Icons.history,
              size: 26,
              color: AppStyle.ink.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text('rien pour l\'instant.', style: AppStyle.display(size: 20)),
          const SizedBox(height: 8),
          const Text(
            'Les affirmations que tu parcours\napparaîtront ici.',
            style: TextStyle(fontSize: 13, color: AppStyle.dim),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Date relative ────────────────────────────────────────────────────────────

String _relative(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final d = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final days = today.difference(d).inDays;
  if (days <= 0) return 'aujourd\'hui';
  if (days == 1) return 'hier';
  if (days < 7) return 'il y a $days jours';
  if (days < 14) return 'la semaine dernière';
  if (days < 30) return 'il y a ${(days / 7).floor()} semaines';
  if (days < 60) return 'le mois dernier';
  return 'il y a ${(days / 30).floor()} mois';
}
