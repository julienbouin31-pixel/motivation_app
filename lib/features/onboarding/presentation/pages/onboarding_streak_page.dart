import 'package:flutter/material.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/widgets/onboarding_message_page.dart';

class OnboardingStreakPage extends StatelessWidget {
  const OnboardingStreakPage({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIndex = DateTime.now().weekday - 1;

    return OnboardingMessagePage(
      route: AppRouter.onboardingStreak,
      title: Text.rich(
        TextSpan(
          style: AppStyle.display(size: 36),
          children: [
            const TextSpan(text: 'une série,\n'),
            TextSpan(
              text: 'un jour à la fois.',
              style: AppStyle.displayItalic(size: 36),
            ),
          ],
        ),
      ),
      body: 'Chaque jour où tu ouvres l\'application, ta série grandit. '
          'Pas de pression — juste un rendez-vous avec toi-même.',
      extra: Row(
        children: List.generate(7, (i) {
          final isToday = i == todayIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Text(
                  days[i],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? AppStyle.ink
                        : AppStyle.ink.withValues(alpha: 0.25),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday ? AppStyle.accent : Colors.transparent,
                    border: Border.all(
                      color: isToday ? AppStyle.accent : AppStyle.hairline,
                    ),
                  ),
                  child: isToday
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: Color(0xFF111110))
                      : null,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
