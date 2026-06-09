import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';
import 'package:motivation_app/core/sync/remote_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';

@lazySingleton
class ActivitySyncHandler implements RemoteSyncHandler {
  @override
  String get entityType => SyncEntityType.activity;

  @override
  Future<void> apply(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final client = supabaseClient;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Pas de session Supabase pour activity_log');
    }
    await client.from('activity_log').insert({
      'user_id': userId,
      'event_type': payload['event_type'],
      'payload': payload['payload'],
    });
  }
}
