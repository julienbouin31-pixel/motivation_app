import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    required String name,
    String? objectiveType,
    String? stripeApiKey,
    String? mrrTarget,
  }) = _UserProfileModel;

  UserProfile toEntity() => UserProfile(
        name: name,
        objectiveType: objectiveType,
        stripeApiKey: stripeApiKey,
        mrrTarget: mrrTarget,
      );
}
