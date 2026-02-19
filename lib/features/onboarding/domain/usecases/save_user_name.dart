import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class SaveUserNameUseCase {
  final OnboardingRepository repository;

  SaveUserNameUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String name) {
    return repository.saveUserName(name);
  }
}
