import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/injection_container.dart' as di;

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final Future<_Stats> _future = _load();

  Future<_Stats> _load() async {
    final local = di.sl<AffirmationLocalDataSource>();
    final storage = di.sl<SecureStorage>();
    final viewed = await local.viewedCount();
    final activeDays = await storage.readTotalActiveDays();
    return _Stats(viewed: viewed, activeDays: activeDays);
  }

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<StreakCubit>().state;

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
                  Text('ta progression', style: AppStyle.display(size: 30)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<_Stats>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppStyle.dim),
                    );
                  }
                  final stats = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              value: '${stats.viewed}',
                              label: 'affirmations\nlues',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              value: '${stats.activeDays}',
                              label: 'jours\nactifs',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              value: '$streak',
                              label: 'série\nactuelle',
                              accent: true,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _Stats {
  final int viewed;
  final int activeDays;
  const _Stats({required this.viewed, required this.activeDays});
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final bool accent;

  const _StatTile({
    required this.value,
    required this.label,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppStyle.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppStyle.display(size: 30)
                .copyWith(color: accent ? AppStyle.accent : AppStyle.ink),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppStyle.dim,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
