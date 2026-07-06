import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivation_app/config/themes/app_style.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;
  final String label;

  const ContinueButton({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.label = 'continuer',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: enabled ? AppStyle.ink : AppStyle.ink.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: enabled
                  ? const Color(0xFF111110)
                  : AppStyle.ink.withValues(alpha: 0.3),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
