import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@lazySingleton
class GetFavoritesUseCase {
  final AffirmationRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Affirmation>>> call() {
    return repository.getFavorites();
  }
}
