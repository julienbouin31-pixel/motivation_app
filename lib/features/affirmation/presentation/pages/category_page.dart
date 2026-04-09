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
      category: AffirmationCategory.general,
      description: 'Du quotidien',
      icon: Icons.auto_awesome_outlined,
      accent: Color(0xFF6C8EF5),
    ),
    (
      category: AffirmationCategory.mindset,
      description: 'Tes croyances',
      icon: Icons.psychology_outlined,
      accent: Color(0xFFB06EF5),
    ),
    (
      category: AffirmationCategory.action,
      description: "Passe à l'acte",
      icon: Icons.rocket_launch_outlined,
      accent: Color(0xFFF57C45),
    ),
    (
      category: AffirmationCategory.focus,
      description: 'Reste dans le flow',
      icon: Icons.center_focus_strong_outlined,
      accent: Color(0xFF45C4B0),
    ),
    (
      category: AffirmationCategory.mrr,
      description: 'Scale ton CA',
      icon: Icons.trending_up,
      accent: Color(0xFF4CAF50),
    ),
    (
      category: AffirmationCategory.resilience,
      description: 'Rebondir toujours',
      icon: Icons.shield_outlined,
      accent: Color(0xFFF5A623),
    ),
    (
      category: AffirmationCategory.confidence,
      description: 'Croire en toi',
      icon: Icons.bolt_outlined,
      accent: Color(0xFFE8C84A),
    ),
    (
      category: AffirmationCategory.vision,
      description: 'Voir grand',
      icon: Icons.explore_outlined,
      accent: Color(0xFF5EC4F5),
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
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeCount =
        _selected.isEmpty ? AffirmationCategory.values.length : _selected.length;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thèmes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '$activeCount actif${activeCount > 1 ? 's' : ''}',
                          style: TextStyle(fontSize: 12, color: colors.secondary),
                        ),
                      ],
                    ),
                  ),
                  // Tout sélectionner / désélectionner
                  GestureDetector(
                    onTap: () {
                      setState(() => _selected = []);
                      context.read<AffirmationCubit>().setCategories([]);
                    },
                    child: Text(
                      'Tous',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFF4CAF50) : colors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Grille ───────────────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.15,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isSelected = _selected.contains(item.category);
                  return _CategoryTile(
                    category: item.category,
                    description: item.description,
                    icon: item.icon,
                    accent: item.accent,
                    isSelected: isSelected,
                    isDark: isDark,
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

class _CategoryTile extends StatelessWidget {
  final AffirmationCategory category;
  final String description;
  final IconData icon;
  final Color accent;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.description,
    required this.icon,
    required this.accent,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final bgColor = isSelected
        ? (isDark ? accent.withValues(alpha: 0.14) : accent.withValues(alpha: 0.09))
        : colors.card;

    final borderColor = isSelected
        ? accent.withValues(alpha: isDark ? 0.55 : 0.45)
        : colors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icône
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withValues(alpha: isDark ? 0.28 : 0.16)
                        : colors.surface,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? accent : colors.secondary,
                  ),
                ),
                const Spacer(),
                // Checkmark
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? accent : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? accent : colors.border,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 12,
                          color: isDark ? Colors.black : Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const Spacer(),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: isSelected
                    ? (isDark ? accent : accent.withValues(alpha: 0.85))
                    : colors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: colors.secondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
