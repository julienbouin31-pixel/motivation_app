import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/custom_affirmations_cubit.dart';
import 'package:motivation_app/injection_container.dart' as di;

typedef _Item = ({
  AffirmationCategory category,
  IconData icon,
  String description,
  Color accent,
});

const _gridItems = <_Item>[
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
];

const _customItem = (
  category: AffirmationCategory.custom,
  icon: Icons.edit_note_rounded,
  description: 'Mes créations perso',
  accent: Color(0xFFE06E9C),
);

// ─────────────────────────────────────────────────────────────────────────────

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomAffirmationsCubit(di.sl())..load(),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatefulWidget {
  const _CategoryView();

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<_CategoryView> {
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
    final customAffirmations = context.watch<CustomAffirmationsCubit>().state;
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
            for (int i = 0; i < _gridItems.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CategoryCard(
                      item: _gridItems[i],
                      isSelected: _selected.contains(_gridItems[i].category),
                      isDark: isDark,
                      colors: colors,
                      onTap: () => _toggle(_gridItems[i].category),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (i + 1 < _gridItems.length)
                    Expanded(
                      child: _CategoryCard(
                        item: _gridItems[i + 1],
                        isSelected: _selected.contains(_gridItems[i + 1].category),
                        isDark: isDark,
                        colors: colors,
                        onTap: () => _toggle(_gridItems[i + 1].category),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // ── Carte "Mes affirmations" pleine largeur ────────────────────────
            _CustomCategoryCard(
              item: _customItem,
              isSelected: _selected.contains(_customItem.category),
              isDark: isDark,
              colors: colors,
              affirmations: customAffirmations,
              onToggle: () => _toggle(_customItem.category),
              onDelete: (id) =>
                  context.read<CustomAffirmationsCubit>().delete(id),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Carte catégorie (grille) ─────────────────────────────────────────────────

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
                    spreadRadius: 0,
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

// ─── Carte "Mes affirmations" (pleine largeur + liste éditable) ───────────────

class _CustomCategoryCard extends StatefulWidget {
  final _Item item;
  final bool isSelected;
  final bool isDark;
  final AppColors colors;
  final List<Affirmation> affirmations;
  final VoidCallback onToggle;
  final void Function(int id) onDelete;

  const _CustomCategoryCard({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.colors,
    required this.affirmations,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<_CustomCategoryCard> createState() => _CustomCategoryCardState();
}

class _CustomCategoryCardState extends State<_CustomCategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.item.accent;
    final colors = widget.colors;
    final isDark = widget.isDark;
    final hasAffirmations = widget.affirmations.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isSelected ? accent.withValues(alpha: 0.7) : colors.border,
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: widget.isSelected
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
          children: [
            // ── Ligne principale ─────────────────────────────────────────────
            GestureDetector(
              onTap: widget.onToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icône
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accent.withValues(alpha: widget.isSelected
                                ? (isDark ? 0.45 : 0.28)
                                : (isDark ? 0.22 : 0.12)),
                            accent.withValues(alpha: widget.isSelected
                                ? (isDark ? 0.18 : 0.1)
                                : (isDark ? 0.08 : 0.04)),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.item.icon, size: 26, color: accent),
                    ),
                    const SizedBox(width: 14),

                    // Texte
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.category.label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: widget.isSelected ? accent : colors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasAffirmations
                                ? '${widget.affirmations.length} affirmation${widget.affirmations.length > 1 ? 's' : ''}'
                                : widget.item.description,
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
                        color: widget.isSelected ? accent : Colors.transparent,
                        border: Border.all(
                          color: widget.isSelected ? accent : colors.border,
                          width: 1.5,
                        ),
                      ),
                      child: widget.isSelected
                          ? const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white)
                          : null,
                    ),

                    // Chevron expand (si affirmations)
                    if (hasAffirmations) ...[
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Liste affirmations ───────────────────────────────────────────
            if (hasAffirmations && _expanded) ...[
              Divider(height: 1, thickness: 1, color: colors.border),
              for (int i = 0; i < widget.affirmations.length; i++) ...[
                _AffirmationDeleteRow(
                  affirmation: widget.affirmations[i],
                  accent: accent,
                  colors: colors,
                  onDelete: () => widget.onDelete(widget.affirmations[i].id),
                ),
                if (i < widget.affirmations.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: colors.border,
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Ligne affirmation avec suppression ───────────────────────────────────────

class _AffirmationDeleteRow extends StatelessWidget {
  final Affirmation affirmation;
  final Color accent;
  final AppColors colors;
  final VoidCallback onDelete;

  const _AffirmationDeleteRow({
    required this.affirmation,
    required this.accent,
    required this.colors,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              affirmation.text,
              style: TextStyle(
                fontSize: 13,
                color: colors.primary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Supprimer',
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Supprimer cette affirmation ?',
          style: TextStyle(color: colors.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler', style: TextStyle(color: colors.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
