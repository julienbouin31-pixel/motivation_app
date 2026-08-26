import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/notifications/notification_service.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';

@lazySingleton
class StreakCubit extends Cubit<int> {
  final SecureStorage _storage;
  final SyncQueueDao _syncQueue;
  StreakCubit(this._storage, this._syncQueue) : super(0);

  // Signal à usage unique : renseigné quand la série vient d'augmenter lors du
  // dernier load() (nouveau jour actif), pour déclencher l'animation de
  // célébration à l'arrivée sur l'écran d'accueil. Consommé par l'UI.
  int? _celebration;
  int? get celebration => _celebration;
  void consumeCelebration() => _celebration = null;

  Future<void> load() async {
    final now = DateTime.now();
    final today = dateKey(now);
    final lastDate = await _storage.readStreakLastDate();
    final current = await _storage.readStreak();

    if (lastDate == today) {
      emit(current);
      // Déjà chargé aujourd'hui (ex: retour au premier plan) : le rappel
      // "en danger" programmé pour ce soir n'a plus lieu d'être.
      if (await _storage.readNotificationEnabled()) {
        await NotificationService.scheduleStreakDanger(current);
      }
      return;
    }

    final next = nextStreak(lastDate: lastDate, current: current, now: now);
    await _storage.saveStreak(next);
    await _storage.saveStreakLastDate(today);
    await _storage.saveTotalActiveDays(await _storage.readTotalActiveDays() + 1);
    await _syncQueue.enqueue(
      entityType: SyncEntityType.streak,
      operation: SyncOperation.upsert,
      payload: {'count': next, 'last_date': today},
    );
    // Nouveau jour actif → à célébrer.
    _celebration = next;
    emit(next);

    // Reprogramme le rappel "série en danger" pour demain soir. S'il n'est
    // jamais annulé/reprogrammé par un nouvel appel à load(), il partira —
    // signe qu'on n'est pas revenu dans l'app le lendemain.
    if (await _storage.readNotificationEnabled()) {
      await NotificationService.scheduleStreakDanger(next);
    }
  }

  /// Clé de jour "AAAA-MM-JJ" (comparaison de journées locales).
  @visibleForTesting
  static String dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Nouveau compteur de série selon la dernière journée active :
  /// - même jour → inchangé
  /// - hier → +1
  /// - trou (ou toute première fois) → repart à 1
  @visibleForTesting
  static int nextStreak({
    required String? lastDate,
    required int current,
    required DateTime now,
  }) {
    if (lastDate == dateKey(now)) return current;
    if (lastDate == dateKey(now.subtract(const Duration(days: 1)))) {
      return current + 1;
    }
    return 1;
  }
}
