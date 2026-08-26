import 'package:flutter_test/flutter_test.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';

int _mins((int, int) t) => t.$1 * 60 + t.$2;

void main() {
  group('NotificationService.distributeTimes', () {
    test('freq=1 → un seul créneau à startHour', () {
      expect(NotificationService.distributeTimes(1, 8, 21), [(8, 0)]);
    });

    test('freq=3 → début, milieu, fin', () {
      final t = NotificationService.distributeTimes(3, 8, 20);
      expect(t.length, 3);
      expect(t.first, (8, 0));
      expect(t.last, (20, 0));
      expect(t[1].$1, 14); // milieu = 14h
    });

    test('freq=5 → 5 créneaux strictement croissants', () {
      final t = NotificationService.distributeTimes(5, 8, 21);
      expect(t.length, 5);
      expect(t.first, (8, 0));
      expect(t.last, (21, 0));
      for (var i = 1; i < t.length; i++) {
        expect(_mins(t[i]), greaterThan(_mins(t[i - 1])));
      }
    });

    test('tous les créneaux restent dans la plage [start, end]', () {
      final t = NotificationService.distributeTimes(5, 9, 18);
      for (final slot in t) {
        expect(_mins(slot), greaterThanOrEqualTo(9 * 60));
        expect(_mins(slot), lessThanOrEqualTo(18 * 60));
      }
    });

    test('aucun doublon d\'horaire dans une même journée', () {
      final t = NotificationService.distributeTimes(5, 8, 21);
      final uniq = t.map(_mins).toSet();
      expect(uniq.length, t.length);
    });
  });
}
