import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

@lazySingleton
class GetUserProfileUseCase {
  final OnboardingRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call() {
    return repository.getUserProfile();
  }
}
