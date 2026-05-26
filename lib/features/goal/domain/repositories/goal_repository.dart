import 'package:dartz/dartz.dart';
import 'package:motivation_app/features/goal/domain/entities/goal_data.dart';

abstract class GoalRepository {
  Future<Either<String, GoalData>> fetchGoalData({
    String? stripeApiKey,
    String? target,
  });
}
