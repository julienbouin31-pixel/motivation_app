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

// ─────────────────────────────────────────────────────────────────────────────

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

            // ── Grille 2 colonnes ─────────────────────────────────────────────
            for (int i = 0; i < _allItems.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CategoryCard(
                      item: _allItems[i],
                      isSelected: _selected.contains(_allItems[i].category),
                      isDark: isDark,
                      colors: colors,
                      onTap: () => _toggle(_allItems[i].category),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (i + 1 < _allItems.length)
                    Expanded(
                      child: _CategoryCard(
                        item: _allItems[i + 1],
                        isSelected: _selected.contains(_allItems[i + 1].category),
                        isDark: isDark,
                        colors: colors,
                        onTap: () => _toggle(_allItems[i + 1].category),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
              if (i + 2 < _allItems.length) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Carte catégorie ──────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final _Item item;
  final bool isSelected;
  final bool isDark;
  final AppColors colors;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = item.accent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accent.withValues(alpha: 0.7) : colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: isDark ? 0.35 : 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Zone icône ──────────────────────────────────────────────────
              AspectRatio(
                aspectRatio: 1.4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: isSelected
                            ? (isDark ? 0.45 : 0.28)
                            : (isDark ? 0.22 : 0.12)),
                        accent.withValues(alpha: isSelected
                            ? (isDark ? 0.18 : 0.1)
                            : (isDark ? 0.08 : 0.04)),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(item.icon, size: 46, color: accent),
                      if (isSelected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Zone texte ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: isSelected ? accent : colors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.secondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
