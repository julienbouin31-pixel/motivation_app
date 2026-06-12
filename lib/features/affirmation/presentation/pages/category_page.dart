import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    icon: Icons.all_inclusive,
    description: 'Du quotidien',
    accent: Color(0xFF8FA1D0),
  ),
  (
    category: AffirmationCategory.confidence,
    icon: Icons.diamond_outlined,
    description: 'Croire en toi',
    accent: Color(0xFFD4C27F),
  ),
  (
    category: AffirmationCategory.mindset,
    icon: Icons.water_drop_outlined,
    description: 'Tes croyances',
    accent: Color(0xFFB19CD9),
  ),
  (
    category: AffirmationCategory.action,
    icon: Icons.bolt_outlined,
    description: "Passe à l'acte",
    accent: Color(0xFFE29B76),
  ),
  (
    category: AffirmationCategory.focus,
    icon: Icons.lens_blur,
    description: 'Reste dans le flow',
    accent: Color(0xFF7CB8A9),
  ),
  (
    category: AffirmationCategory.resilience,
    icon: Icons.waves,
    description: 'Rebondir toujours',
    accent: Color(0xFFD6A25C),
  ),
  (
    category: AffirmationCategory.vision,
    icon: Icons.visibility_outlined,
    description: 'Voir grand',
    accent: Color(0xFF86BBD8),
  ),
  (
    category: AffirmationCategory.custom,
    icon: Icons.gesture,
    description: 'Mes créations',
    accent: Color(0xFFD48B9E),
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

  void _reset() {
    setState(() => _selected = []);
    context.read<AffirmationCubit>().setCategories([]);
  }

  @override
  Widget build(BuildContext context) {
    final total = AffirmationCategory.values.length;
    final activeCount = _selected.isEmpty ? total : _selected.length;
    final progress = _selected.isEmpty ? 1.0 : _selected.length / total;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFD3D3D3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'Catégories',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ),
                          Text(
                            'Personnalise ton fil d\'affirmations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selected.isNotEmpty)
                      GestureDetector(
                        onTap: _reset,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Barre de progression ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$activeCount actif${activeCount > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.35),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '$total catégories',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.25),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.white.withValues(alpha: 0.06),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF8FA1D0)),
                          minHeight: 2.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Grille ─────────────────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _allItems.length,
                  itemBuilder: (context, index) {
                    final item = _allItems[index];
                    return _CategoryCard(
                      item: item,
                      isSelected: _selected.contains(item.category),
                      onTap: () => _toggle(item.category),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Floating bottom bar ─────────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        selected: _selected,
        total: total,
        onBack: () => context.pop(),
      ),
    );
  }
}

// ─── Carte catégorie ──────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final _Item item;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = item.accent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [accent.withValues(alpha: 0.14), accent.withValues(alpha: 0.04), Colors.transparent]
                : [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.02)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? accent.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.07),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.22),
                    blurRadius: 28,
                    spreadRadius: -6,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // ── Orbe décoratif en coin haut-droite ─────────────────────────
            Positioned(
              top: -18,
              right: -18,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: isSelected ? 0.18 : 0.05),
                ),
              ),
            ),
            // ── Second orbe plus petit ──────────────────────────────────────
            Positioned(
              bottom: -12,
              left: -8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: isSelected ? 0.08 : 0.02),
                ),
              ),
            ),

            // ── Contenu ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accent.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isSelected ? accent : Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isSelected
                            ? Container(
                                key: const ValueKey('check'),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_rounded, size: 13, color: accent),
                              )
                            : const SizedBox(key: ValueKey('empty'), width: 22, height: 22),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    item.category.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.75),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? accent.withValues(alpha: 0.85)
                          : Colors.white.withValues(alpha: 0.38),
                      height: 1.3,
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

// ─── Floating bottom bar ──────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final List<AffirmationCategory> selected;
  final int total;
  final VoidCallback onBack;

  const _BottomBar({
    required this.selected,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final count = selected.isEmpty ? total : selected.length;
    final isAll = selected.isEmpty;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.95)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: GestureDetector(
        onTap: onBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8FA1D0).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8FA1D0),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAll
                    ? 'Toutes les catégories actives'
                    : 'catégorie${count > 1 ? 's' : ''} sélectionnée${count > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
