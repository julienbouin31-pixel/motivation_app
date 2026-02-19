import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

class AffirmationRepositoryImpl implements AffirmationRepository {
  final AffirmationLocalDataSource localDataSource;
  final AffirmationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final String objectiveType;
  final String? mrrTarget;
  final String? userName;

  AffirmationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.objectiveType,
    this.mrrTarget,
    this.userName,
  });

  @override
  Future<Either<Failure, Affirmation>> getNextAffirmation({
    List<AffirmationCategory>? categories,
  }) async {
    try {
      // "general" = pas de filtre, on montre toutes les catégories
      final hasGeneral = categories == null ||
          categories.isEmpty ||
          categories.contains(AffirmationCategory.general);
      final categoryStrs =
          hasGeneral ? null : categories.map((c) => c.name).toList();

      final count =
          await localDataSource.countUnviewed(categories: categoryStrs);

      if (count == 0) {
        final total =
            await localDataSource.totalCount(categories: categoryStrs);

        if (total == 0) {
          // DB vide (premier lancement — ne devrait pas arriver grâce au seed)
          // ou après un clearAll explicite : on fetch depuis l'API
          final fresh = await remoteDataSource.fetchAffirmations(
            objectiveType: objectiveType,
            mrrTarget: mrrTarget,
            name: userName,
          );
          await localDataSource.saveAll(fresh);
        } else {
          // Cycle épuisé → reset isViewed sans toucher isFavorite (❤️ conservés)
          // Quand la vraie API sera prête et retournera du contenu différent,
          // remplacer par : clearAll() + saveAll(freshFromApi)
          await localDataSource.resetViewed(categories: categoryStrs);
        }
      }

      final model =
          await localDataSource.getNextUnviewed(categories: categoryStrs);
      if (model == null) return Left(CacheFailure());

      return Right(model.toEntity());
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Affirmation>>> getFavorites() async {
    try {
      final models = await localDataSource.getFavorites();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsViewed(int id) async {
    try {
      await localDataSource.markAsViewed(id);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(int id) async {
    try {
      await localDataSource.toggleFavorite(id);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
