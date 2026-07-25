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

  Future<void> load() async {
    final today = _dateKey(DateTime.now());
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

    final int next;
    if (lastDate == _dateKey(DateTime.now().subtract(const Duration(days: 1)))) {
      next = current + 1;
    } else {
      next = 1;
    }
    await _storage.saveStreak(next);
    await _storage.saveStreakLastDate(today);
    await _storage.saveTotalActiveDays(await _storage.readTotalActiveDays() + 1);
    await _syncQueue.enqueue(
      entityType: SyncEntityType.streak,
      operation: SyncOperation.upsert,
      payload: {'count': next, 'last_date': today},
    );
    emit(next);

    // Reprogramme le rappel "série en danger" pour demain soir. S'il n'est
    // jamais annulé/reprogrammé par un nouvel appel à load(), il partira —
    // signe qu'on n'est pas revenu dans l'app le lendemain.
    if (await _storage.readNotificationEnabled()) {
      await NotificationService.scheduleStreakDanger(next);
    }
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
