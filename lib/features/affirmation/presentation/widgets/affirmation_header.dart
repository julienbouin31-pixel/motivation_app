import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';

class AffirmationHeader extends StatelessWidget {
  final String userName;
  final Color? avatarBg;
  final Color? avatarFg;

  const AffirmationHeader({
    super.key,
    required this.userName,
    this.avatarBg,
    this.avatarFg,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 18) return 'bonjour';
    return 'bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final streak = context.watch<StreakCubit>().state;
    // Sur un thème de carte photo/dégradé, le texte suit la couleur d'overlay
    final fg = avatarFg ?? colors.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 20, 12),
      child: Row(
        children: [
          // ── Salutation du moment ─────────────────────────────────────
          Expanded(
            child: Text(
              userName.isNotEmpty
                  ? '$_greeting, ${userName.toLowerCase()}.'
                  : '$_greeting.',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.display(size: 19)
                  .copyWith(color: fg.withValues(alpha: 0.85)),
            ),
          ),

          // ── Série ────────────────────────────────────────────────────
          if (streak >= 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: avatarBg == null
                      ? AppStyle.hairline
                      : fg.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppStyle.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$streak',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fg.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // ── Avatar ───────────────────────────────────────────────────
          GestureDetector(
            onTap: () => context.push(AppRouter.profile),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarBg ?? Colors.transparent,
                shape: BoxShape.circle,
                border: avatarBg == null
                    ? Border.all(color: colors.border)
                    : null,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
