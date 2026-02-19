import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';

/// Peuple la DB au premier lancement, et remet à zéro si des doublons sont détectés.
/// Appelé dans main.dart avant runApp() — complètement hors ligne.
Future<void> seedAffirmationsIfEmpty(
  AppDatabase db, {
  String? name,
  String? mrrTarget,
}) async {
  final local = AffirmationLocalDataSourceImpl(db: db);
  final remote = AffirmationRemoteDataSourceImpl();

  final affirmations = await remote.fetchAffirmations(
    objectiveType: 'mrr',
    name: name,
    mrrTarget: mrrTarget,
  );
  final expectedCount = affirmations.length; // 32
  final total = await local.totalCount();

  if (total == 0) {
    // Premier lancement : peuple la DB
    await local.saveAll(affirmations);
  } else if (total > expectedCount) {
    // Doublons détectés → remise à zéro propre
    await local.clearAll();
    await local.saveAll(affirmations);
  }
  // total == expectedCount : DB propre, rien à faire
}
