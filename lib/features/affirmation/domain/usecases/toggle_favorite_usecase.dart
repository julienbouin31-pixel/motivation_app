import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@lazySingleton
class ToggleFavoriteUseCase {
  final AffirmationRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.toggleFavorite(id);
  }
}
