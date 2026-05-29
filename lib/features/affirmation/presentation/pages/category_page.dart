import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';

typedef _Item = ({
  AffirmationCategory category,
  IconData icon,
  String description,
  Color accent,
});

const _allItems = <_Item>[
  (
    category: AffirmationCategory.general,
    icon: Icons.format_quote_rounded,
    description: 'Du quotidien',
    accent: Color(0xFF6C8EF5),
  ),
  (
    category: AffirmationCategory.confidence,
    icon: Icons.bolt_rounded,
    description: 'Croire en toi',
    accent: Color(0xFFE8C84A),
  ),
  (
    category: AffirmationCategory.mindset,
    icon: Icons.psychology_rounded,
    description: 'Tes croyances',
    accent: Color(0xFFB06EF5),
  ),
  (
    category: AffirmationCategory.action,
    icon: Icons.rocket_launch_rounded,
    description: "Passe à l'acte",
    accent: Color(0xFFF57C45),
  ),
  (
    category: AffirmationCategory.focus,
    icon: Icons.center_focus_strong_rounded,
    description: 'Reste dans le flow',
    accent: Color(0xFF45C4B0),
  ),
  (
    category: AffirmationCategory.resilience,
    icon: Icons.shield_rounded,
    description: 'Rebondir toujours',
    accent: Color(0xFFF5A623),
  ),
  (
    category: AffirmationCategory.vision,
    icon: Icons.explore_rounded,
    description: 'Voir grand',
    accent: Color(0xFF5EC4F5),
  ),
  (
    category: AffirmationCategory.custom,
    icon: Icons.edit_note_rounded,
    description: 'Mes créations perso',
    accent: Color(0xFFE06E9C),
  ),
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
      next = candidate.length == AffirmationCategory.values.length ? [] : candidate;
    }
    setState(() => _selected = next);
    context.read<AffirmationCubit>().setCategories(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final activeCount =
        _selected.isEmpty ? AffirmationCategory.values.length : _selected.length;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Row(
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
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catégories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    Text(
                      '$activeCount actif${activeCount > 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 12, color: colors.secondary),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Info banner ───────────────────────────────────────────────────
            if (_selected.isEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 15, color: colors.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Aucune sélection = toutes les catégories sont actives',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.secondary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Liste ─────────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _allItems.length; i++) ...[
                    _CategoryRow(
                      item: _allItems[i],
                      isSelected: _selected.contains(_allItems[i].category),
                      colors: colors,
                      isFirst: i == 0,
                      isLast: i == _allItems.length - 1,
                      onTap: () => _toggle(_allItems[i].category),
                    ),
                    if (i < _allItems.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 64,
                        color: colors.border,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ligne catégorie ──────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final _Item item;
  final bool isSelected;
  final AppColors colors;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.item,
    required this.isSelected,
    required this.colors,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = item.accent;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(18) : Radius.zero,
          bottom: isLast ? const Radius.circular(18) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icône
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 20, color: accent),
              ),
              const SizedBox(width: 14),

              // Label + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Check
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accent : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accent : colors.border,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
