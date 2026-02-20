// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      name: json['name'] as String? ?? '',
      objectiveType: json['objectiveType'] as String?,
      stripeApiKey: json['stripeApiKey'] as String?,
      mrrTarget: json['mrrTarget'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'objectiveType': instance.objectiveType,
      'stripeApiKey': instance.stripeApiKey,
      'mrrTarget': instance.mrrTarget,
    };
