import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/goal/domain/entities/goal_data.dart';

part 'goal_state.freezed.dart';

@freezed
sealed class GoalState with _$GoalState {
  const factory GoalState.initial() = GoalInitial;
  const factory GoalState.loading() = GoalLoading;
  const factory GoalState.loaded(GoalData data) = GoalLoaded;
  const factory GoalState.error(String message) = GoalError;
}
