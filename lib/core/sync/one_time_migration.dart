import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';

@lazySingleton
class OneTimeMigration {
  final SecureStorage _storage;
  final SyncQueueDao _syncQueue;
  final OnboardingLocalDataSource _onboarding;
  final AffirmationLocalDataSource _affirmations;
  final AppDatabase _db;

  OneTimeMigration(
    this._storage,
    this._syncQueue,
    this._onboarding,
    this._affirmations,
    this._db,
  );

  Future<void> runIfNeeded() async {
    if (await _storage.readMigratedToSupabase()) return;
    try {
      await _migrateProfile();
      await _migrateStreak();
      await _migrateCustomAffirmations();
      await _migrateFavorites();
      await _storage.setMigratedToSupabase();
    } catch (e) {
      debugPrint('[OneTimeMigration] Erreur: $e');
    }
  }

  Future<void> _migrateProfile() async {
    final profile = await _onboarding.getUserProfile();
    if (profile.name.isEmpty) return;
    await _syncQueue.enqueue(
      entityType: SyncEntityType.profile,
      operation: SyncOperation.upsert,
      payload: {'name': profile.name},
    );
  }

  Future<void> _migrateStreak() async {
    final count = await _storage.readStreak();
    final lastDate = await _storage.readStreakLastDate();
    if (count == 0 || lastDate == null) return;
    await _syncQueue.enqueue(
      entityType: SyncEntityType.streak,
      operation: SyncOperation.upsert,
      payload: {'count': count, 'last_date': lastDate},
    );
  }

  Future<void> _migrateCustomAffirmations() async {
    final customs = await _affirmations.getCustomAffirmations();
    for (final c in customs) {
      await _syncQueue.enqueue(
        entityType: SyncEntityType.customAffirmation,
        operation: SyncOperation.upsert,
        entityLocalId: c.id,
        payload: {'content': c.text},
      );
    }
  }

  Future<void> _migrateFavorites() async {
    final rows = await (_db.select(_db.affirmationItems)
          ..where((t) => t.isFavorite.equals(true)))
        .get();
    for (final r in rows) {
      await _syncQueue.enqueue(
        entityType: SyncEntityType.favorite,
        operation: SyncOperation.upsert,
        entityLocalId: r.id,
        payload: {
          'content': r.content,
          'category': r.category,
          'is_custom': r.isCustom,
        },
      );
    }
  }
}
