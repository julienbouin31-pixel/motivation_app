import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_style.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Icon(
          Icons.arrow_back,
          size: 22,
          color: AppStyle.ink.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}
