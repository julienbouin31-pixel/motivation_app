import 'package:flutter/material.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';

class AffirmationCard extends StatelessWidget {
  final Affirmation affirmation;
  final String userName;
  final String mrrTarget;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const AffirmationCard({
    super.key,
    required this.affirmation,
    required this.userName,
    required this.mrrTarget,
    required this.onFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = affirmation.text
        .replaceAll('{name}', userName)
        .replaceAll('{target}', mrrTarget);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            '"$displayText"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.4,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LikeButton(
              isFavorite: affirmation.isFavorite,
              onTap: onFavorite,
            ),
            const SizedBox(width: 16),
            _ActionButton(
              icon: Icons.share_outlined,
              color: Colors.black54,
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

  const _LikeButton({required this.isFavorite, required this.onTap});

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
            color: widget.isFavorite
                ? Colors.red.shade50
                : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? Colors.red : Colors.black54,
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
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
