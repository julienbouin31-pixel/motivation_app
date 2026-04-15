import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_data.freezed.dart';

@freezed
abstract class GoalData with _$GoalData {
  const factory GoalData({
    required double current,
    required double target,
    required double changePct,
    required String objectiveType, // 'mrr' | 'analytics'
    required DateTime lastUpdated,
  }) = _GoalData;
}
