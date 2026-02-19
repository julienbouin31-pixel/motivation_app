import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';

/// Peuple la DB avec les 32 affirmations au premier lancement.
/// Appelé dans main.dart avant runApp() — complètement hors ligne.
Future<void> seedAffirmationsIfEmpty(
  AppDatabase db, {
  String? name,
  String? mrrTarget,
}) async {
  final local = AffirmationLocalDataSourceImpl(db: db);
  final total = await local.totalCount();
  if (total > 0) return; // Déjà peuplé, rien à faire

  final remote = AffirmationRemoteDataSourceImpl();
  final affirmations = await remote.fetchAffirmations(
    objectiveType: 'mrr',
    name: name,
    mrrTarget: mrrTarget,
  );
  await local.saveAll(affirmations);
}
