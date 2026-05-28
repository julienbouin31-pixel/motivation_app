import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service de notifications locales.
///
/// Distribue les notifications uniformément dans une plage horaire :
///   freq=1 → une notif à startHour
///   freq=3 → start, milieu, end
///   freq=5 → 5 points équidistants entre start et end
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // ─── Init ─────────────────────────────────────────────────────────────────

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  // ─── Permissions ──────────────────────────────────────────────────────────

  static Future<bool> requestPermissions() async {
    try {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
    } catch (e) {
      debugPrint('[NotificationService] requestPermissions error: $e');
    }
    return false;
  }

  // ─── Scheduling ───────────────────────────────────────────────────────────

  /// [affirmations] : textes déjà résolus (sans placeholders {name}/{target})
  /// [frequency]   : 1, 3 ou 5 notifications par jour
  /// [startHour]   : heure de début de la plage (ex: 8)
  /// [endHour]     : heure de fin de la plage (ex: 21)
  static Future<void> schedule({
    required List<String> affirmations,
    required int frequency,
    required int startHour,
    required int endHour,
  }) async {
    await _plugin.cancelAll();
    if (affirmations.isEmpty) return;

    final times = _distributeTimes(frequency, startHour, endHour);
    const daysAhead = 30;
    int textIndex = 0;

    for (int slot = 0; slot < times.length; slot++) {
      final (hour, minute) = times[slot];
      for (int day = 0; day < daysAhead; day++) {
        final id = slot * 100 + day;
        final text = affirmations[textIndex % affirmations.length];
        textIndex++;

        try {
          await _plugin.zonedSchedule(
            id,
            'Motivation',
            text,
            _nextOccurrence(hour, minute, day),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'daily_affirmations',
                'Rappels quotidiens',
                channelDescription: 'Tes affirmations du jour',
                importance: Importance.high,
                priority: Priority.high,
                styleInformation: BigTextStyleInformation(''),
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: false,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e) {
          debugPrint('[NotificationService] schedule error (id=$id): $e');
        }
      }
    }

    debugPrint(
      '[NotificationService] Scheduled ${times.length * daysAhead} notifications '
      '(${times.length}x/day, ${startHour}h→${endHour}h)',
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Test uniquement — déclenche une notif dans 5 secondes avec [text].
  static Future<void> scheduleTestIn5Seconds(String text) async {
    final now = tz.TZDateTime.now(tz.local);
    await _plugin.zonedSchedule(
      9999,
      'Motivation',
      text,
      now.add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_affirmations',
          'Rappels quotidiens',
          channelDescription: 'Tes affirmations du jour',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('[NotificationService] Test notification scheduled in 5s');
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Distribue [freq] créneaux entre [startH]h et [endH]h.
  static List<(int hour, int minute)> _distributeTimes(
      int freq, int startH, int endH) {
    if (freq <= 1) return [(startH, 0)];
    final totalMins = (endH - startH) * 60;
    final step = totalMins / (freq - 1);
    return List.generate(freq, (i) {
      final mins = (startH * 60 + i * step).round();
      return (mins ~/ 60, mins % 60);
    });
  }

  static tz.TZDateTime _nextOccurrence(int hour, int minute, int daysOffset) {
    final now = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).add(Duration(days: daysOffset));

    if (daysOffset == 0 && date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }
}
