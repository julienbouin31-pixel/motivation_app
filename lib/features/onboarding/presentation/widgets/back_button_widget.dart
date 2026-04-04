import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: colors.primary,
        ),
      ),
    );
  }
}
