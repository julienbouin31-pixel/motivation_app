import 'dart:async';

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

  // ID réservé pour la notif "streak en danger" (hors plage des notifs
  // quotidiennes, qui utilisent slot*100+day, max ~504 pour freq=5/30j).
  static const int _streakDangerId = 90000;

  // ─── Tap sur notification ────────────────────────────────────────────────
  // payload = id de l'affirmation (String d'un int), ou vide pour les notifs
  // sans cible précise (ex: streak en danger → ouvre juste l'app).
  static final _tapController = StreamController<String>.broadcast();
  static Stream<String> get onNotificationTap => _tapController.stream;

  static void _onTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      _tapController.add(payload);
    }
  }

  // ─── Init ─────────────────────────────────────────────────────────────────

  /// Retourne le payload de la notif ayant lancé l'app à froid, s'il y en a une.
  static Future<String?> init() async {
    if (_initialized) return null;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );
    _initialized = true;

    if (launchDetails?.didNotificationLaunchApp == true) {
      return launchDetails?.notificationResponse?.payload;
    }
    return null;
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

  /// [affirmations] : (id, texte déjà résolu sans placeholders {name}/{target})
  /// [frequency]   : 1, 3 ou 5 notifications par jour
  /// [startHour]   : heure de début de la plage (ex: 8)
  /// [endHour]     : heure de fin de la plage (ex: 21)
  ///
  /// Ne touche pas à la notif "streak en danger" (id dédié, hors de cette plage).
  static Future<void> schedule({
    required List<(int id, String text)> affirmations,
    required int frequency,
    required int startHour,
    required int endHour,
  }) async {
    await _cancelDailyAffirmations();
    if (affirmations.isEmpty) return;

    final times = _distributeTimes(frequency, startHour, endHour);
    const daysAhead = 30;
    int textIndex = 0;
    int scheduled = 0;

    final now = tz.TZDateTime.now(tz.local);

    for (int slot = 0; slot < times.length; slot++) {
      final (hour, minute) = times[slot];
      for (int day = 0; day < daysAhead; day++) {
        final when = _occurrence(hour, minute, day);
        // Créneau déjà passé (uniquement possible aujourd'hui) → on saute,
        // sinon il collisionnerait avec le même créneau de demain.
        if (!when.isAfter(now)) continue;

        final id = slot * 100 + day;
        final entry = affirmations[textIndex % affirmations.length];
        textIndex++;
        scheduled++;

        try {
          await _plugin.zonedSchedule(
            id,
            'Motivation',
            entry.$2,
            when,
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
            payload: entry.$1.toString(),
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
      '[NotificationService] Scheduled $scheduled notifications '
      '(${times.length}x/day, ${startHour}h→${endHour}h)',
    );
  }

  /// Annule uniquement les notifs quotidiennes (ids 0..~504), sans toucher
  /// à la notif "streak en danger".
  static Future<void> _cancelDailyAffirmations() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final n in pending) {
      if (n.id != _streakDangerId) {
        await _plugin.cancel(n.id);
      }
    }
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

  // ─── Streak en danger ─────────────────────────────────────────────────────

  /// Programme un rappel pour demain [hour]h : "ta série de X jours expire
  /// ce soir". Annulé/reprogrammé à chaque ouverture de l'app (voir StreakCubit) :
  /// s'il n'est jamais annulé, c'est qu'on n'est pas revenu → il part.
  static Future<void> scheduleStreakDanger(int streak, {int hour = 20}) async {
    await _plugin.cancel(_streakDangerId);
    if (streak <= 0) return;

    final now = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour)
        .add(const Duration(days: 1));

    final label = streak == 1 ? '1 jour' : '$streak jours';
    try {
      await _plugin.zonedSchedule(
        _streakDangerId,
        'Ta série est en jeu',
        'Ta série de $label expire ce soir — ouvre l\'app pour la garder.',
        date,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_danger',
            'Série en danger',
            channelDescription: 'Rappel avant la fin de ta série',
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
    } catch (e) {
      debugPrint('[NotificationService] scheduleStreakDanger error: $e');
    }
  }

  // ─── Rappel de fin d'essai ─────────────────────────────────────────────────

  static const int _trialReminderId = 90001;

  /// Programme un rappel [inDays] jours avant la fin de l'essai gratuit.
  static Future<void> scheduleTrialReminder({required int inDays}) async {
    await _plugin.cancel(_trialReminderId);
    if (inDays <= 0) return;
    final when = tz.TZDateTime.now(tz.local).add(Duration(days: inDays));
    try {
      await _plugin.zonedSchedule(
        _trialReminderId,
        'Ton essai gratuit se termine bientôt',
        'Ton essai Curves Premium se termine bientôt — annule quand tu veux.',
        when,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'trial_reminder',
            'Fin d\'essai',
            channelDescription: 'Rappel avant la fin de l\'essai gratuit',
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
    } catch (e) {
      debugPrint('[NotificationService] scheduleTrialReminder error: $e');
    }
  }

  static Future<void> cancelTrialReminder() => _plugin.cancel(_trialReminderId);

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

  /// Date du créneau [hour]:[minute] sur le jour civil (aujourd'hui + [daysOffset]).
  /// Ne décale JAMAIS d'un jour : un créneau déjà passé aujourd'hui est
  /// simplement ignoré par l'appelant (sinon il entrerait en collision avec
  /// le même créneau du lendemain → notification en double).
  static tz.TZDateTime _occurrence(int hour, int minute, int daysOffset) {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute)
        .add(Duration(days: daysOffset));
  }
}
