import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

part 'onboarding_state.freezed.dart';

@freezed
sealed class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = OnboardingInitial;
  const factory OnboardingState.loading() = OnboardingLoading;
  const factory OnboardingState.profileLoaded(UserProfile profile) = OnboardingProfileLoaded;
  const factory OnboardingState.dataSaved(UserProfile profile) = OnboardingDataSaved;
  const factory OnboardingState.error(String message) = OnboardingError;
}
