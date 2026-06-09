import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/features/onboarding/data/datasources/profile_remote_data_source.dart';

@lazySingleton
class ProfileSyncHandler implements RemoteSyncHandler {
  final ProfileRemoteDataSource _remote;

  ProfileSyncHandler(this._remote);

  @override
  String get entityType => SyncEntityType.profile;

  @override
  Future<void> apply(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    await _remote.upsertProfile(name: payload['name'] as String?);
  }
}
