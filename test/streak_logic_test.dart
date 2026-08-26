import 'package:flutter_test/flutter_test.dart';
import 'package:motivation_app/core/streak/streak_cubit.dart';

void main() {
  group('StreakCubit.nextStreak', () {
    final now = DateTime(2026, 8, 21, 10, 0);
    String key(DateTime d) => StreakCubit.dateKey(d);

    test('première fois (aucune date) → 1', () {
      expect(
        StreakCubit.nextStreak(lastDate: null, current: 0, now: now),
        1,
      );
    });

    test('jour consécutif (hier) → +1', () {
      final yesterday = key(now.subtract(const Duration(days: 1)));
      expect(
        StreakCubit.nextStreak(lastDate: yesterday, current: 4, now: now),
        5,
      );
    });

    test('même jour → inchangé', () {
      expect(
        StreakCubit.nextStreak(lastDate: key(now), current: 4, now: now),
        4,
      );
    });

    test('trou d\'un jour (avant-hier) → repart à 1', () {
      final twoDaysAgo = key(now.subtract(const Duration(days: 2)));
      expect(
        StreakCubit.nextStreak(lastDate: twoDaysAgo, current: 9, now: now),
        1,
      );
    });

    test('passage d\'un mois à l\'autre reste consécutif', () {
      final firstSept = DateTime(2026, 9, 1, 8);
      final lastAug = StreakCubit.dateKey(DateTime(2026, 8, 31));
      expect(
        StreakCubit.nextStreak(lastDate: lastAug, current: 10, now: firstSept),
        11,
      );
    });

    test('passage d\'une année à l\'autre reste consécutif', () {
      final firstJan = DateTime(2027, 1, 1, 8);
      final lastDec = StreakCubit.dateKey(DateTime(2026, 12, 31));
      expect(
        StreakCubit.nextStreak(lastDate: lastDec, current: 30, now: firstJan),
        31,
      );
    });
  });

  group('StreakCubit.dateKey', () {
    test('formate avec des zéros de tête', () {
      expect(StreakCubit.dateKey(DateTime(2026, 3, 5)), '2026-03-05');
    });
  });
}
