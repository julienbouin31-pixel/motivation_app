import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@lazySingleton
class GetNextAffirmationUseCase {
  final AffirmationRepository repository;

  GetNextAffirmationUseCase(this.repository);

  Future<Either<Failure, Affirmation>> call({
    List<AffirmationCategory>? categories,
  }) {
    return repository.getNextAffirmation(categories: categories);
  }
}
