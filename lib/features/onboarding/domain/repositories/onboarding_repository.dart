import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, Unit>> saveUserName(String name);
  Future<Either<Failure, Unit>> saveObjectiveType(String objectiveType);
  Future<Either<Failure, Unit>> saveStripeApiKey(String key);
  Future<Either<Failure, Unit>> saveMrrTarget(String target);
}
