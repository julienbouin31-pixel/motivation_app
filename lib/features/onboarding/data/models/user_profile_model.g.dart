// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      name: json['name'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mood': instance.mood,
      'goal': instance.goal,
    };
