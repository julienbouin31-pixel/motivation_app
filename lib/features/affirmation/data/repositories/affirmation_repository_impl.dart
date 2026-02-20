import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

const _kLastFetchKey = 'affirmation_last_fetch_date';

@LazySingleton(as: AffirmationRepository)
class AffirmationRepositoryImpl implements AffirmationRepository {
  final AffirmationLocalDataSource localDataSource;
  final AffirmationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;
  final UserProfileModel userProfile;

  AffirmationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorage,
    required this.userProfile,
  });

  // ─── Gestion de la date du dernier fetch ────────────────────────────────────

  Future<bool> _shouldWeeklyRefresh() async {
    try {
      final raw = await secureStorage.read(key: _kLastFetchKey);
      if (raw == null) return true;
      final lastFetch = DateTime.tryParse(raw);
      if (lastFetch == null) return true;
      return DateTime.now().difference(lastFetch).inDays >= 7;
    } catch (_) {
      return true;
    }
  }

  Future<void> _markRefreshed() async {
    try {
      await secureStorage.write(
        key: _kLastFetchKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (_) {}
  }

  // ─── Fetch + déduplication ──────────────────────────────────────────────────

  /// Récupère les nouvelles affirmations depuis le remote, filtre les doublons,
  /// et les insère en DB. Retourne true si du nouveau contenu a été ajouté.
  Future<bool> _fetchAndSaveNew() async {
    try {
      final fresh = await remoteDataSource.fetchAffirmations(
        objectiveType: userProfile.objectiveType ?? 'mrr',
        mrrTarget: userProfile.mrrTarget,
        name: userProfile.name.isNotEmpty ? userProfile.name : null,
      );
      if (fresh.isEmpty) {
        print('[WeeklyRefresh] Remote retourne 0 affirmations.');
        return false;
      }

      final existing = await localDataSource.getAllContents();
      final newOnes = fresh.where((a) => !existing.contains(a.text)).toList();
      if (newOnes.isEmpty) {
        print('[WeeklyRefresh] Aucun nouveau contenu (tout déjà en DB).');
        return false;
      }

      await localDataSource.saveAll(newOnes);
      print('[WeeklyRefresh] ${newOnes.length} nouvelles affirmations ajoutées en DB.');
      return true;
    } catch (e) {
      print('[WeeklyRefresh] Erreur fetch: $e');
      return false;
    }
  }

  // ─── Refresh hebdomadaire en arrière-plan (appelé depuis main.dart) ─────────

  /// Fire-and-forget : récupère de nouvelles affirmations si 7+ jours écoulés.
  /// N'affecte pas la navigation en cours.
  @override
  Future<void> weeklyRefreshInBackground() async {
    try {
      if (!await _shouldWeeklyRefresh()) {
        print('[WeeklyRefresh] Pas encore 7 jours depuis le dernier fetch.');
        return;
      }
      if (!await networkInfo.isConnected) {
        print('[WeeklyRefresh] Pas de réseau.');
        return;
      }
      await _fetchAndSaveNew();
      await _markRefreshed();
    } catch (_) {}
  }

  // ─── getNextAffirmation ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Affirmation>> getNextAffirmation({
    List<AffirmationCategory>? categories,
  }) async {
    try {
      final categoryStrs = (categories == null || categories.isEmpty)
          ? null
          : categories.map((c) => c.name).toList();

      final count =
          await localDataSource.countUnviewed(categories: categoryStrs);

      if (count == 0) {
        final total =
            await localDataSource.totalCount(categories: categoryStrs);

        if (total == 0) {
          // DB vide (ne devrait pas arriver grâce au seed)
          return Left(CacheFailure());
        }

        // Cycle épuisé → essayer de récupérer du nouveau contenu si réseau dispo
        // Le check réseau est isolé pour ne jamais bloquer le reset du cycle
        bool addedNew = false;
        try {
          final connected = await networkInfo.isConnected;
          print('[CycleEpuisé] isConnected=$connected');
          if (connected) {
            addedNew = await _fetchAndSaveNew();
            print('[CycleEpuisé] addedNew=$addedNew');
            if (addedNew) await _markRefreshed();
          }
        } catch (e) {
          print('[CycleEpuisé] Erreur check réseau: $e');
          // Pas de réseau ou erreur → on passe au reset du cycle
        }

        if (!addedNew) {
          // Pas de nouveau contenu (ou pas de réseau) → reset du cycle
          await localDataSource.resetViewed(categories: categoryStrs);
        }
        // Si addedNew == true : les nouvelles cartes sont déjà isViewed=false,
        // on les pioche directement sans reset.
      }

      final model =
          await localDataSource.getNextUnviewed(categories: categoryStrs);
      if (model == null) return Left(CacheFailure());

      return Right(model.toEntity());
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  // ─── Autres méthodes ────────────────────────────────────────────────────────

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
  Future<Either<Failure, void>> markAsViewed(int id) async {
    try {
      await localDataSource.markAsViewed(id);
      return Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(int id) async {
    try {
      await localDataSource.toggleFavorite(id);
      return Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
