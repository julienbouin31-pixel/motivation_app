import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? name,
    String? objectiveType, // 'mrr' | 'analytics' | 'none'
    String? stripeApiKey,
    String? mrrTarget,
  }) = _UserProfile;
}
