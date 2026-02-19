import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  static const _categories = [
    (Icons.auto_awesome, AffirmationCategory.general),
    (Icons.psychology_outlined, AffirmationCategory.mindset),
    (Icons.rocket_launch_outlined, AffirmationCategory.action),
    (Icons.center_focus_strong_outlined, AffirmationCategory.focus),
    (Icons.trending_up, AffirmationCategory.mrr),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 26),
                onPressed: () => context.pop(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Text(
                'Catégories',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _categories.map((tab) {
                  final (icon, category) = tab;
                  final isSelected = _selected.contains(category);
                  return _CategoryItem(
                    icon: icon,
                    category: category,
                    isSelected: isSelected,
                    onTap: () => _toggle(category),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final AffirmationCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: isSelected ? Colors.white : Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                category.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: isSelected
                  ? const Icon(Icons.check_circle,
                      key: ValueKey(true), size: 22, color: Colors.white)
                  : Icon(Icons.circle_outlined,
                      key: ValueKey(false),
                      size: 22,
                      color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
