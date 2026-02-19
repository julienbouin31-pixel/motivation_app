import 'package:flutter/material.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

class CategoryPanel extends StatelessWidget {
  final AffirmationCategory selectedCategory;
  final ValueChanged<AffirmationCategory> onCategorySelected;

  const CategoryPanel({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const _categories = [
    (Icons.auto_awesome, AffirmationCategory.general),
    (Icons.psychology_outlined, AffirmationCategory.mindset),
    (Icons.rocket_launch_outlined, AffirmationCategory.action),
    (Icons.center_focus_strong_outlined, AffirmationCategory.focus),
    (Icons.trending_up, AffirmationCategory.mrr),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _categories.map((tab) {
          final (icon, category) = tab;
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final AffirmationCategory category;
  final bool isOpen;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.category,
    required this.isOpen,
    required this.onTap,
  });

  static const _icons = {
    AffirmationCategory.general: Icons.auto_awesome,
    AffirmationCategory.mindset: Icons.psychology_outlined,
    AffirmationCategory.action: Icons.rocket_launch_outlined,
    AffirmationCategory.focus: Icons.center_focus_strong_outlined,
    AffirmationCategory.mrr: Icons.trending_up,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icons[category]!, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_up, size: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
