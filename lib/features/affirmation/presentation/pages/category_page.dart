import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/core/purchases/premium_content.dart';
import 'package:motivation_app/core/purchases/subscription_cubit.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';

typedef _Item = ({AffirmationCategory category, String description});

const _allItems = <_Item>[
  (category: AffirmationCategory.general, description: 'Du quotidien'),
  (category: AffirmationCategory.confidence, description: 'Croire en toi'),
  (category: AffirmationCategory.mindset, description: 'Tes croyances'),
  (category: AffirmationCategory.action, description: "Passer à l'acte"),
  (category: AffirmationCategory.focus, description: 'Rester dans le flow'),
  (category: AffirmationCategory.resilience, description: 'Rebondir toujours'),
  (category: AffirmationCategory.vision, description: 'Voir grand'),
  (category: AffirmationCategory.citations, description: 'De grands esprits'),
  (category: AffirmationCategory.custom, description: 'Mes créations'),
];

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<AffirmationCategory> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.of(context.read<AffirmationCubit>().selectedCategories);
  }

  void _toggle(AffirmationCategory category) {
    final List<AffirmationCategory> next;
    if (_selected.contains(category)) {
      next = _selected.where((c) => c != category).toList();
    } else {
      final candidate = [..._selected, category];
      next = candidate.length == AffirmationCategory.values.length
          ? []
          : candidate;
    }
    setState(() => _selected = next);
    context.read<AffirmationCubit>().setCategories(next);
  }

  void _reset() {
    setState(() => _selected = []);
    context.read<AffirmationCubit>().setCategories([]);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<SubscriptionCubit>().state;
    final total = AffirmationCategory.values.length;
    final activeCount = _selected.isEmpty ? total : _selected.length;
    final isAll = _selected.isEmpty;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child:
                            Text('catégories', style: AppStyle.display(size: 30)),
                      ),
                      if (_selected.isNotEmpty)
                        GestureDetector(
                          onTap: _reset,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text('tout remettre',
                                style: AppStyle.overline),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ton fil se compose des catégories choisies.',
                    style: AppStyle.body.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '$activeCount active${activeCount > 1 ? 's' : ''} sur $total',
                        style: AppStyle.overline,
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Divider(color: AppStyle.hairline, height: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Liste ──────────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
                itemCount: _allItems.length,
                itemBuilder: (context, index) {
                  final item = _allItems[index];
                  final locked =
                      PremiumContent.categoryLocked(item.category, isPremium);
                  final selected =
                      !locked && (isAll || _selected.contains(item.category));
                  return SelectableRow(
                    label: item.category.label,
                    sublabel: locked ? 'premium' : item.description,
                    selected: selected,
                    locked: locked,
                    onTap: locked
                        ? () => context.push(AppRouter.paywall)
                        : () => _toggle(item.category),
                  );
                },
              ),
            ),

            // ── Bas de page ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppStyle.ink,
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Center(
                    child: Text(
                      isAll
                          ? 'toutes les catégories actives'
                          : '$activeCount catégorie${activeCount > 1 ? 's' : ''} — terminé',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111110),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
