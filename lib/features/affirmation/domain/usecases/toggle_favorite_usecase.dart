import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

class ToggleFavoriteUseCase {
  final AffirmationRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) {
    return repository.toggleFavorite(id);
  }
}
