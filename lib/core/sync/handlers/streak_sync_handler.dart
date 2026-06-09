import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/streak/streak_remote_data_source.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';

@lazySingleton
class StreakSyncHandler implements RemoteSyncHandler {
  final StreakRemoteDataSource _remote;

  StreakSyncHandler(this._remote);

  @override
  String get entityType => SyncEntityType.streak;

  @override
  Future<void> apply(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    await _remote.upsertStreak(
      count: payload['count'] as int,
      lastDate: payload['last_date'] as String,
    );
  }
}
