import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class SaveObjectiveTypeUseCase {
  final OnboardingRepository repository;

  SaveObjectiveTypeUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String objectiveType) {
    return repository.saveObjectiveType(objectiveType);
  }
}
