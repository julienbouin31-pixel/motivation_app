import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/sync/sync_entity_type.dart';
import 'package:motivation_app/core/sync/sync_queue_dao.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;
  final SyncQueueDao syncQueue;

  OnboardingRepositoryImpl({
    required this.localDataSource,
    required this.syncQueue,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = await localDataSource.getUserProfile();
      return Right(model.toEntity());
    } catch (e) {
      debugPrint('[OnboardingRepository] Erreur: $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile) async {
    try {
      final name = profile.name ?? '';
      await localDataSource.saveProfile(UserProfileModel(name: name));
      await syncQueue.enqueue(
        entityType: SyncEntityType.profile,
        operation: SyncOperation.upsert,
        payload: {'name': name},
      );
      return Right(null);
    } catch (e) {
      debugPrint('[OnboardingRepository] Erreur: $e');
      return Left(CacheFailure());
    }
  }
}
