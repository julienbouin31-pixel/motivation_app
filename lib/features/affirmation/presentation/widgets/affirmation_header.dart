import 'package:flutter/material.dart';

class AffirmationHeader extends StatelessWidget {
  final String userName;

  const AffirmationHeader({super.key, required this.userName});

  String _getFormattedDate() {
    final now = DateTime.now();
    const days = ['LUN.', 'MAR.', 'MER.', 'JEU.', 'VEN.', 'SAM.', 'DIM.'];
    const months = [
      'JANV.', 'FÉVR.', 'MARS', 'AVR.', 'MAI', 'JUIN',
      'JUIL.', 'AOÛT', 'SEPT.', 'OCT.', 'NOV.', 'DÉC.'
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined, size: 24, color: Colors.black87),
          const Spacer(),
          Column(
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                _getFormattedDate(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.phone_iphone_outlined, size: 24, color: Colors.black87),
        ],
      ),
    );
  }
}
