import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';

part 'affirmation_state.freezed.dart';

@freezed
sealed class AffirmationState with _$AffirmationState {
  const factory AffirmationState.initial() = AffirmationInitial;
  const factory AffirmationState.loading() = AffirmationLoading;
  const factory AffirmationState.loaded({
    required Affirmation affirmation,
    required AffirmationCategory selectedCategory,
  }) = AffirmationLoaded;
  const factory AffirmationState.error(String message) = AffirmationError;
}
