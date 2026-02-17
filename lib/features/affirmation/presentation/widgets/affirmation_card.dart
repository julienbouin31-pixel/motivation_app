import 'package:flutter/material.dart';

class AffirmationCard extends StatelessWidget {
  final String category;
  final String text;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final bool isFavorite;

  const AffirmationCard({
    super.key,
    required this.category,
    required this.text,
    required this.onFavorite,
    required this.onShare,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Text(
          //     category.toUpperCase(),
          //     style: const TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w600,
          //       letterSpacing: 0.5,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '"$text"',
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
              _ActionButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black54,
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
