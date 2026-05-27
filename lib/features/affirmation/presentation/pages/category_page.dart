import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';

typedef _Item = ({
  AffirmationCategory category,
  String emoji,
  String description,
  Color accent,
});

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late List<AffirmationCategory> _selected;

  static final _specialItems = <_Item>[
    (
      category: AffirmationCategory.general,
      emoji: '💬',
      description: 'Du quotidien',
      accent: const Color(0xFF6C8EF5),
    ),
    (
      category: AffirmationCategory.confidence,
      emoji: '⚡',
      description: 'Croire en toi',
      accent: const Color(0xFFE8C84A),
    ),
  ];

  static final _popularItems = <_Item>[
    (
      category: AffirmationCategory.mindset,
      emoji: '🧠',
      description: 'Tes croyances',
      accent: const Color(0xFFB06EF5),
    ),
    (
      category: AffirmationCategory.action,
      emoji: '🚀',
      description: "Passe à l'acte",
      accent: const Color(0xFFF57C45),
    ),
    (
      category: AffirmationCategory.focus,
      emoji: '🎯',
      description: 'Reste dans le flow',
      accent: const Color(0xFF45C4B0),
    ),
    (
      category: AffirmationCategory.mrr,
      emoji: '📈',
      description: 'Scale ton CA',
      accent: const Color(0xFF4CAF50),
    ),
  ];

  static final _growthItems = <_Item>[
    (
      category: AffirmationCategory.resilience,
      emoji: '🛡️',
      description: 'Rebondir toujours',
      accent: const Color(0xFFF5A623),
    ),
    (
      category: AffirmationCategory.vision,
      emoji: '🔭',
      description: 'Voir grand',
      accent: const Color(0xFF5EC4F5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = List.of(context.read<AffirmationCubit>().selectedCategories);
    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  List<_Item> _filter(List<_Item> items) {
    if (_searchQuery.isEmpty) return items;
    return items
        .where((i) => i.category.label.toLowerCase().contains(_searchQuery))
        .toList();
  }

  SliverGrid _grid(List<_Item> items, bool isDark, AppColors colors) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildListDelegate(
        items
            .map(
              (item) => _CategoryCard(
                item: item,
                isSelected: _selected.contains(item.category),
                isDark: isDark,
                colors: colors,
                onTap: () => _toggle(item.category),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredSpecial = _filter(_specialItems);
    final filteredPopular = _filter(_popularItems);
    final filteredGrowth = _filter(_growthItems);
    final isSearching = _searchQuery.isNotEmpty;
    final allFiltered = [...filteredSpecial, ...filteredPopular, ...filteredGrowth];

    final activeCount =
        _selected.isEmpty ? AffirmationCategory.values.length : _selected.length;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: colors.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            '$activeCount actif${activeCount > 1 ? 's' : ''}',
                            style: TextStyle(fontSize: 12, color: colors.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Info sélection ───────────────────────────────────────────────
            if (_selected.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
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
                ),
              ),

            // ── Barre de recherche ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 14, color: colors.primary),
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      hintStyle: TextStyle(color: colors.secondary, fontSize: 14),
                      prefixIcon:
                          Icon(Icons.search_rounded, size: 20, color: colors.secondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),
            ),

            // ── Contenu ───────────────────────────────────────────────────────
            if (isSearching) ...[
              if (allFiltered.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: _grid(allFiltered, isDark, colors),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Text(
                        'Aucune catégorie trouvée',
                        style: TextStyle(color: colors.secondary),
                      ),
                    ),
                  ),
                ),
            ] else ...[
              if (filteredSpecial.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: _grid(filteredSpecial, isDark, colors),
                ),
              if (filteredPopular.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _SectionTitle(title: 'Les plus populaires', colors: colors),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: _grid(filteredPopular, isDark, colors),
                ),
              ],
              if (filteredGrowth.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _SectionTitle(title: 'Croissance', colors: colors),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: _grid(filteredGrowth, isDark, colors),
                ),
              ],
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final AppColors colors;

  const _SectionTitle({required this.title, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: colors.primary,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}

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
    final shadowColor = isSelected
        ? accent.withValues(alpha: isDark ? 0.45 : 0.25)
        : Colors.black.withValues(alpha: isDark ? 0.45 : 0.08);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? accent.withValues(alpha: isDark ? 0.75 : 0.55)
                : colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: isSelected ? 22 : 14,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Zone illustration ────────────────────────────────────────
              Expanded(
                flex: 62,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: isDark ? 0.38 : 0.2),
                        accent.withValues(alpha: isDark ? 0.14 : 0.07),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Zone label ───────────────────────────────────────────────
              Expanded(
                flex: 38,
                child: Container(
                  color: colors.card,
                  padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.category.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: isSelected
                              ? (isDark ? accent : accent.withValues(alpha: 0.85))
                              : colors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondary,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
