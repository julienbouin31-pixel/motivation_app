import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

abstract class AffirmationRepository {
  Future<Either<Failure, Affirmation>> getNextAffirmation({
    List<AffirmationCategory>? categories,
  });
  Future<Either<Failure, List<Affirmation>>> getFavorites();
  Future<Either<Failure, void>> markAsViewed(int id);
  Future<Either<Failure, void>> toggleFavorite(int id);
  Future<void> weeklyRefreshInBackground();
}
