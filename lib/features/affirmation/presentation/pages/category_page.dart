import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  static const _items = [
    (
      index: '01',
      category: AffirmationCategory.general,
      description: 'Affirmations du quotidien',
    ),
    (
      index: '02',
      category: AffirmationCategory.mindset,
      description: 'Reprogramme tes croyances',
    ),
    (
      index: '03',
      category: AffirmationCategory.action,
      description: 'Passe à l\'exécution',
    ),
    (
      index: '04',
      category: AffirmationCategory.focus,
      description: 'Reste dans le flow',
    ),
    (
      index: '05',
      category: AffirmationCategory.mrr,
      description: 'Scale ton chiffre d\'affaires',
    ),
  ];

  late List<AffirmationCategory> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.of(context.read<AffirmationCubit>().selectedCategories);
  }

  void _toggle(AffirmationCategory category) {
    List<AffirmationCategory> next;
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
    final activeCount =
        _selected.isEmpty ? AffirmationCategory.values.length : _selected.length;

    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Thèmes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _selected.isEmpty ? 'tous actifs' : '$activeCount / ${AffirmationCategory.values.length}',
                    style: TextStyle(fontSize: 13, color: colors.secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ─── Liste ───────────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isSelected = _selected.contains(item.category);
                  return _CategoryRow(
                    index: item.index,
                    category: item.category,
                    description: item.description,
                    isSelected: isSelected,
                    onTap: () => _toggle(item.category),
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

class _CategoryRow extends StatelessWidget {
  final String index;
  final AffirmationCategory category;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.index,
    required this.category,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.scaffold,
          border: Border(
            bottom: BorderSide(color: colors.border),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Numéro
            SizedBox(
              width: 26,
              child: Text(
                index,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colors.secondary : colors.border,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? colors.scaffold : colors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.secondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Indicateur sélection
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? colors.scaffold : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
