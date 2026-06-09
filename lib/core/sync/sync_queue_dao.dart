import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';

part 'sync_queue_dao.g.dart';

@LazySingleton()
@DriftAccessor(tables: [SyncQueueItems])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<int> enqueue({
    required String entityType,
    required String operation,
    required Map<String, dynamic> payload,
    int? entityLocalId,
  }) {
    return into(syncQueueItems).insert(
      SyncQueueItemsCompanion.insert(
        entityType: entityType,
        operation: operation,
        payload: jsonEncode(payload),
        createdAt: DateTime.now(),
        entityLocalId: Value(entityLocalId),
      ),
    );
  }

  Future<List<SyncQueueItem>> pending({int limit = 50}) {
    final now = DateTime.now();
    return (select(syncQueueItems)
          ..where((t) =>
              t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerThanValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> countPending() async {
    final count = countAll();
    final row = await (selectOnly(syncQueueItems)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> markDone(int id) async {
    await (delete(syncQueueItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markFailed(int id, String error) async {
    final row = await (select(syncQueueItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    final nextAttempts = row.attempts + 1;
    final backoffSeconds = (1 << nextAttempts.clamp(0, 11)) * 5;
    final cappedSeconds = backoffSeconds.clamp(5, 3600);
    final nextAt = DateTime.now().add(Duration(seconds: cappedSeconds));
    await (update(syncQueueItems)..where((t) => t.id.equals(id))).write(
      SyncQueueItemsCompanion(
        attempts: Value(nextAttempts),
        lastError: Value(error),
        nextAttemptAt: Value(nextAt),
      ),
    );
  }

  Future<List<SyncQueueItem>> pendingForEntity({
    required String entityType,
    int? entityLocalId,
  }) {
    final query = select(syncQueueItems)
      ..where((t) => t.entityType.equals(entityType));
    if (entityLocalId != null) {
      query.where((t) => t.entityLocalId.equals(entityLocalId));
    }
    return query.get();
  }
}
