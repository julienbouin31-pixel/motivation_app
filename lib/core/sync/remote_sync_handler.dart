import 'package:motivation_app/core/database/app_database.dart';

abstract class RemoteSyncHandler {
  String get entityType;
  Future<void> apply(SyncQueueItem item);
}
