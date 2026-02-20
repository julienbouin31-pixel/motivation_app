import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = await localDataSource.getUserProfile();
      return Right(model.toEntity());
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUserName(String name) async {
    try {
      await localDataSource.saveUserName(name);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveObjectiveType(String objectiveType) async {
    try {
      await localDataSource.saveObjectiveType(objectiveType);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveStripeApiKey(String key) async {
    try {
      await localDataSource.saveStripeApiKey(key);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveMrrTarget(String target) async {
    try {
      await localDataSource.saveMrrTarget(target);
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
