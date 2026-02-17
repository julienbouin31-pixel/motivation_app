import 'package:flutter/material.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Construis ta liberté,',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Colors.black,
            ),
          ),
          const Text(
            'un jour à la fois.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Des affirmations quotidiennes pour les makers qui veulent changer de vie.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
