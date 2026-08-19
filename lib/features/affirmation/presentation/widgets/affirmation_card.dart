import 'package:flutter/material.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';

class AffirmationCard extends StatelessWidget {
  final Affirmation affirmation;
  final String userName;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final Color? textColor;
  final Color? buttonBg;
  final Color? buttonIconColor;

  const AffirmationCard({
    super.key,
    required this.affirmation,
    required this.userName,
    required this.onFavorite,
    required this.onShare,
    this.textColor,
    this.buttonBg,
    this.buttonIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? AppStyle.ink;
    final effectiveButtonBg = buttonBg ?? Colors.transparent;
    final effectiveButtonIconColor =
        buttonIconColor ?? AppStyle.ink.withValues(alpha: 0.65);
    final displayText = affirmation.text
        .replaceAll('{name}', userName);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            displayText,
            textAlign: TextAlign.center,
            style: AppStyle.display(size: 26).copyWith(
              color: effectiveTextColor,
              height: 1.45,
            ),
          ),
        ),
        if (affirmation.author != null && affirmation.author!.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            '— ${affirmation.author}',
            textAlign: TextAlign.center,
            style: AppStyle.displayItalic(size: 16).copyWith(
              color: effectiveTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LikeButton(
              isFavorite: affirmation.isFavorite,
              onTap: onFavorite,
              bg: effectiveButtonBg,
              iconColor: effectiveButtonIconColor,
            ),
            const SizedBox(width: 16),
            _ActionButton(
              icon: Icons.share_outlined,
              color: effectiveButtonIconColor,
              bg: effectiveButtonBg,
              onTap: onShare,
            ),
          ],
        ),
      ],
    );
  }
}

/// Bouton like avec animation bounce
class _LikeButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final Color bg;
  final Color iconColor;

  const _LikeButton({
    required this.isFavorite,
    required this.onTap,
    required this.bg,
    required this.iconColor,
  });

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.45)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.45, end: 0.88)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
      TweenSequenceItem(
          tween: Tween(begin: 0.88, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 30),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    _ctrl.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: widget.bg,
            shape: BoxShape.circle,
            border: widget.bg == Colors.transparent
                ? Border.all(color: AppStyle.hairline)
                : null,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? Colors.red.shade400 : widget.iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: bg == Colors.transparent
              ? Border.all(color: AppStyle.hairline)
              : null,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
