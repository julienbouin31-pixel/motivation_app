import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/supabase/supabase_bootstrap.dart';
import 'package:motivation_app/core/sync/handlers/activity_sync_handler.dart';
import 'package:motivation_app/core/sync/handlers/custom_affirmation_sync_handler.dart';
import 'package:motivation_app/core/sync/handlers/favorite_sync_handler.dart';
import 'package:motivation_app/core/sync/handlers/profile_sync_handler.dart';
import 'package:motivation_app/core/sync/handlers/streak_sync_handler.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';
import 'package:motivation_app/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class AppModule {
  @singleton
  Connectivity get connectivity => Connectivity();

  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase => openAppDatabase();

  @lazySingleton
  SupabaseClient get supabase => supabaseClient;

  @preResolve
  @singleton
  Future<SyncService> syncService(
    SyncQueueDao dao,
    Connectivity connectivity,
    ProfileSyncHandler profile,
    StreakSyncHandler streak,
    CustomAffirmationSyncHandler custom,
    FavoriteSyncHandler favorite,
    ActivitySyncHandler activity,
  ) async {
    final service = SyncService(
      dao: dao,
      connectivity: connectivity,
      handlers: [profile, streak, custom, favorite, activity],
    );
    await service.start();
    return service;
  }
}
