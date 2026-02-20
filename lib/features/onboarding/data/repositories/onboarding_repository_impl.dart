import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';
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
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile) async {
    try {
      await localDataSource.saveProfile(UserProfileModel(
        name: profile.name ?? '',
        objectiveType: profile.objectiveType,
        stripeApiKey: profile.stripeApiKey,
        mrrTarget: profile.mrrTarget,
      ));
      return Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }
}
