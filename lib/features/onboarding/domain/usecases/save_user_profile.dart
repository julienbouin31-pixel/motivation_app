import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

@lazySingleton
class SaveUserProfileUseCase {
  final OnboardingRepository repository;

  SaveUserProfileUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UserProfile profile) {
    return repository.saveUserProfile(profile);
  }
}
