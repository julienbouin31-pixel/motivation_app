import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class AgeOptionCard extends StatelessWidget {
  final String ageRange;
  final bool isSelected;
  final VoidCallback onTap;

  const AgeOptionCard({
    super.key,
    required this.ageRange,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                ageRange,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.scaffold : colors.primary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colors.scaffold,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
