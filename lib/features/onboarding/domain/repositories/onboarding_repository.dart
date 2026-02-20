import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile);
}
