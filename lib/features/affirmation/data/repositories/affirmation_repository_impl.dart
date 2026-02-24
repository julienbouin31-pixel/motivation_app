import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart';

@LazySingleton(as: AffirmationRepository)
class AffirmationRepositoryImpl implements AffirmationRepository {
  final AffirmationLocalDataSource localDataSource;
  final AffirmationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final GetUserProfileUseCase getUserProfile;

  AffirmationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.getUserProfile,
  });

  // ─── Gestion de la date du dernier fetch ────────────────────────────────────

  Future<bool> _shouldWeeklyRefresh() async {
    final lastFetch = await localDataSource.getLastFetchDate();
    if (lastFetch == null) return true;
    return DateTime.now().difference(lastFetch).inDays >= 7;
  }

  Future<void> _markRefreshed() async {
    await localDataSource.setLastFetchDate(DateTime.now());
  }

  // ─── Fetch depuis le remote + déduplication via UNIQUE constraint ────────────

  /// Télécharge de nouvelles affirmations et les insère en DB.
  /// Les doublons sont ignorés automatiquement grâce à la contrainte UNIQUE sur content.
  Future<void> _fetchAndSaveNew() async {
    try {
      final profileEither = await getUserProfile();
      final profile = profileEither.fold((_) => null, (p) => p);

      final fresh = await remoteDataSource.fetchAffirmations(
        objectiveType: profile?.objectiveType ?? 'mrr',
        mrrTarget: profile?.mrrTarget,
        name: profile?.name?.isNotEmpty == true ? profile!.name : null,
      );
      if (fresh.isEmpty) {
        debugPrint('[WeeklyRefresh] Remote retourne 0 affirmations.');
        return;
      }

      await localDataSource.saveAll(fresh);
      debugPrint('[WeeklyRefresh] ${fresh.length} affirmations insérées (doublons ignorés).');
    } catch (e) {
      debugPrint('[WeeklyRefresh] Erreur fetch: $e');
    }
  }

  // ─── Refresh hebdomadaire en arrière-plan (appelé depuis main.dart) ─────────

  @override
  Future<void> weeklyRefreshInBackground() async {
    try {
      if (!await _shouldWeeklyRefresh()) {
        debugPrint('[WeeklyRefresh] Pas encore 7 jours depuis le dernier fetch.');
        return;
      }
      if (!await networkInfo.isConnected) {
        debugPrint('[WeeklyRefresh] Pas de réseau.');
        return;
      }
      await _fetchAndSaveNew();
      await _markRefreshed();
    } catch (e) {
      debugPrint('[WeeklyRefresh] Erreur inattendue: $e');
    }
  }

  // ─── getNextAffirmation ──────────────────────────────────────────────────────

  /// Retourne toujours la carte la moins récemment vue (lastViewedAt ASC NULLS FIRST).
  /// Plus de logique de "cycle épuisé" — l'algorithme temporal gère tout.
  @override
  Future<Either<Failure, Affirmation>> getNextAffirmation({
    List<AffirmationCategory>? categories,
  }) async {
    try {
      final categoryStrs = (categories == null || categories.isEmpty)
          ? null
          : categories.map((c) => c.name).toList();

      final model = await localDataSource.getNextUnviewed(categories: categoryStrs);
      if (model == null) return Left(CacheFailure());

      return Right(model.toEntity());
    } catch (e) {
      debugPrint('[getNextAffirmation] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  // ─── Autres méthodes ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Affirmation>>> getFavorites() async {
    try {
      final models = await localDataSource.getFavorites();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      debugPrint('[getFavorites] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAsViewed(int id) async {
    try {
      await localDataSource.markAsViewed(id);
      return Right(null);
    } catch (e) {
      debugPrint('[markAsViewed] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(int id) async {
    try {
      await localDataSource.toggleFavorite(id);
      return Right(null);
    } catch (e) {
      debugPrint('[toggleFavorite] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<AffirmationCategory>>> getSavedCategories() async {
    try {
      final categories = await localDataSource.getSavedCategories();
      return Right(categories);
    } catch (e) {
      debugPrint('[getSavedCategories] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveCategories(List<AffirmationCategory> categories) async {
    try {
      await localDataSource.saveCategories(categories);
      return Right(null);
    } catch (e) {
      debugPrint('[saveCategories] Erreur: $e');
      return Left(CacheFailure());
    }
  }
}
