import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';

class ActivityEvent {
  static const appOpen = 'app_open';
  static const affirmationViewed = 'affirmation_viewed';
  static const favoriteAdded = 'favorite_added';
  static const customAffirmationCreated = 'custom_affirmation_created';
}

@lazySingleton
class ActivityLogger {
  final SyncQueueDao _syncQueue;

  ActivityLogger(this._syncQueue);

  Future<void> log(String eventType, {Map<String, dynamic>? payload}) async {
    try {
      await _syncQueue.enqueue(
        entityType: SyncEntityType.activity,
        operation: SyncOperation.upsert,
        payload: {
          'event_type': eventType,
          'payload': ?payload,
        },
      );
    } catch (e) {
      debugPrint('[ActivityLogger] Erreur log $eventType: $e');
    }
  }
}
