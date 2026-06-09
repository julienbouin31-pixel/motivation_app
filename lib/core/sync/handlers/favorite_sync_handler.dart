import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/favorite_remote_data_source.dart';

@lazySingleton
class FavoriteSyncHandler implements RemoteSyncHandler {
  final FavoriteRemoteDataSource _remote;
  final AffirmationLocalDataSource _local;

  FavoriteSyncHandler(this._remote, this._local);

  @override
  String get entityType => SyncEntityType.favorite;

  @override
  Future<void> apply(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final content = payload['content'] as String;

    if (item.operation == SyncOperation.delete) {
      await _remote.deleteByContent(content);
      return;
    }

    final isCustom = payload['is_custom'] as bool? ?? false;
    var customRemoteId = payload['custom_remote_id'] as String?;
    if (isCustom && customRemoteId == null && item.entityLocalId != null) {
      customRemoteId = await _local.getRemoteId(item.entityLocalId!);
      if (customRemoteId == null) {
        throw StateError('custom affirmation pas encore synced, retry plus tard');
      }
    }

    await _remote.upsert(
      content: content,
      category: payload['category'] as String,
      isCustom: isCustom,
      customAffirmationId: customRemoteId,
    );
  }
}
