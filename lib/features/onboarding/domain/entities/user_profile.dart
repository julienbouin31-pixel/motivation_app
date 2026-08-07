import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? name,
    String? mood,
    String? goal,
    String? tone, // ton préféré : direct | doux | poetique | percutant
    String? lifeArea, // ce qui pèse : travail | famille | relations | sante | argent
    String? struggle, // difficulté principale
  }) = _UserProfile;
}
