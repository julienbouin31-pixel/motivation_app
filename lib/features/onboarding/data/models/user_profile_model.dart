import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @Default('') String name,
    @Default('') String mood,
    @Default('') String goal,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  UserProfile toEntity() => UserProfile(
        name: name,
        mood: mood.isEmpty ? null : mood,
        goal: goal.isEmpty ? null : goal,
      );
}
