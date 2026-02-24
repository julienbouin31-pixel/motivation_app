import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';

@lazySingleton
class GetSavedCategoriesUseCase {
  final AffirmationRepository repository;

  GetSavedCategoriesUseCase(this.repository);

  Future<Either<Failure, List<AffirmationCategory>>> call() {
    return repository.getSavedCategories();
  }
}
