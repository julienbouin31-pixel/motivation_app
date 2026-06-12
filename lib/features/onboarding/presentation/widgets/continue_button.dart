import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_theme.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;
  final String label;

  const ContinueButton({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.label = 'Continuer',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? colors.primary : colors.border,
          foregroundColor: colors.scaffold,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
