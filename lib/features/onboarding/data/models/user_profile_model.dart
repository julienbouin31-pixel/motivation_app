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
    @Default('') String tone,
    @Default('') String lifeArea,
    @Default('') String struggle,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfile p) => UserProfileModel(
        name: p.name ?? '',
        mood: p.mood ?? '',
        goal: p.goal ?? '',
        tone: p.tone ?? '',
        lifeArea: p.lifeArea ?? '',
        struggle: p.struggle ?? '',
      );

  UserProfile toEntity() => UserProfile(
        name: name,
        mood: mood.isEmpty ? null : mood,
        goal: goal.isEmpty ? null : goal,
        tone: tone.isEmpty ? null : tone,
        lifeArea: lifeArea.isEmpty ? null : lifeArea,
        struggle: struggle.isEmpty ? null : struggle,
      );
}
