import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@lazySingleton
class MarkAsViewedUseCase {
  final AffirmationRepository repository;

  MarkAsViewedUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) {
    return repository.markAsViewed(id);
  }
}
