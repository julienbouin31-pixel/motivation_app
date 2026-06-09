import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/custom_affirmation_remote_data_source.dart';

@lazySingleton
class CustomAffirmationSyncHandler implements RemoteSyncHandler {
  final CustomAffirmationRemoteDataSource _remote;
  final AffirmationLocalDataSource _local;

  CustomAffirmationSyncHandler(this._remote, this._local);

  @override
  String get entityType => SyncEntityType.customAffirmation;

  @override
  Future<void> apply(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final localId = item.entityLocalId;

    if (item.operation == SyncOperation.delete) {
      final remoteId = payload['remote_id'] as String?;
      if (remoteId == null) return;
      await _remote.delete(remoteId);
      return;
    }

    if (localId == null) {
      throw StateError('entityLocalId manquant pour custom_affirmation upsert');
    }

    final content = payload['content'] as String;
    final existingRemoteId = await _local.getRemoteId(localId);
    if (existingRemoteId == null) {
      final newRemoteId = await _remote.insert(content);
      await _local.setRemoteId(localId, newRemoteId);
    } else {
      await _remote.update(existingRemoteId, content);
    }
  }
}
