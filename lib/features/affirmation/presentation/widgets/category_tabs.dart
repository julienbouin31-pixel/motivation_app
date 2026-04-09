import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
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
    final colors = Theme.of(context).extension<AppColors>()!;
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
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: isSelected ? colors.scaffold : colors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? colors.scaffold : colors.primary,
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

  static const _green = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? colors.surface : colors.primary;
    final fgColor = isDark ? _green : colors.scaffold;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: isDark ? Border.all(color: _green.withValues(alpha: 0.3), width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_view_rounded, size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_up, size: 14, color: fgColor.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
