import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivation_app/config/themes/app_style.dart';

/// Bandeau de célébration qui descend du haut quand la série augmente,
/// reste quelques secondes, puis remonte et se retire. Style éditorial.
class StreakCelebration extends StatefulWidget {
  final int count;
  final VoidCallback onDismiss;

  const StreakCelebration({
    super.key,
    required this.count,
    required this.onDismiss,
  });

  @override
  State<StreakCelebration> createState() => _StreakCelebrationState();
}

class _StreakCelebrationState extends State<StreakCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _in;
  Timer? _timer;

  static const _visible = Duration(milliseconds: 2600);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _in = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);

    _ctrl.forward();
    HapticFeedback.mediumImpact();

    _timer = Timer(_visible, () async {
      if (!mounted) return;
      await _ctrl.reverse();
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  String get _label {
    switch (widget.count) {
      case 1:
        return 'série lancée';
      case 7:
        return 'une semaine d\'affilée';
      case 30:
        return 'un mois entier';
      default:
        return '${widget.count} jours de série';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _in,
      builder: (context, child) {
        final t = _in.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * -28),
            child: Transform.scale(
              scale: 0.94 + 0.06 * t,
              alignment: Alignment.topCenter,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF161615),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppStyle.accent.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: AppStyle.accent.withValues(alpha: 0.10),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              size: 16,
              color: AppStyle.accent,
            ),
            const SizedBox(width: 8),
            Text(
              _label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppStyle.ink.withValues(alpha: 0.9),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
