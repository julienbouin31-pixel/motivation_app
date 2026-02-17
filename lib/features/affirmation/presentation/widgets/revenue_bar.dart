import 'package:flutter/material.dart';

class RevenueBar extends StatelessWidget {
  final double currentRevenue;
  final double targetRevenue;
  final VoidCallback? onTap;

  const RevenueBar({
    super.key,
    required this.currentRevenue,
    required this.targetRevenue,
    this.onTap,
  });

  String _formatRevenue(double amount) {
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}K€';
    return '${amount.toStringAsFixed(0)}€';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.trending_up,
                color: Color(0xFF4CAF50),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _formatRevenue(currentRevenue),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${_formatRevenue(targetRevenue)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
          ],
        ),
      ),
    );
  }
}
