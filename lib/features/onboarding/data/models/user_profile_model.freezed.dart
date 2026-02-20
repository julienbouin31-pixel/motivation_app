// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileModel {

 String get name; String? get objectiveType; String? get stripeApiKey; String? get mrrTarget;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.objectiveType, objectiveType) || other.objectiveType == objectiveType)&&(identical(other.stripeApiKey, stripeApiKey) || other.stripeApiKey == stripeApiKey)&&(identical(other.mrrTarget, mrrTarget) || other.mrrTarget == mrrTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,objectiveType,stripeApiKey,mrrTarget);

@override
String toString() {
  return 'UserProfileModel(name: $name, objectiveType: $objectiveType, stripeApiKey: $stripeApiKey, mrrTarget: $mrrTarget)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String name, String? objectiveType, String? stripeApiKey, String? mrrTarget
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? objectiveType = freezed,Object? stripeApiKey = freezed,Object? mrrTarget = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,objectiveType: freezed == objectiveType ? _self.objectiveType : objectiveType // ignore: cast_nullable_to_non_nullable
as String?,stripeApiKey: freezed == stripeApiKey ? _self.stripeApiKey : stripeApiKey // ignore: cast_nullable_to_non_nullable
as String?,mrrTarget: freezed == mrrTarget ? _self.mrrTarget : mrrTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? objectiveType,  String? stripeApiKey,  String? mrrTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.name,_that.objectiveType,_that.stripeApiKey,_that.mrrTarget);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? objectiveType,  String? stripeApiKey,  String? mrrTarget)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.name,_that.objectiveType,_that.stripeApiKey,_that.mrrTarget);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? objectiveType,  String? stripeApiKey,  String? mrrTarget)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.name,_that.objectiveType,_that.stripeApiKey,_that.mrrTarget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileModel extends UserProfileModel {
  const _UserProfileModel({this.name = '', this.objectiveType, this.stripeApiKey, this.mrrTarget}): super._();
  factory _UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

@override@JsonKey() final  String name;
@override final  String? objectiveType;
@override final  String? stripeApiKey;
@override final  String? mrrTarget;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.objectiveType, objectiveType) || other.objectiveType == objectiveType)&&(identical(other.stripeApiKey, stripeApiKey) || other.stripeApiKey == stripeApiKey)&&(identical(other.mrrTarget, mrrTarget) || other.mrrTarget == mrrTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,objectiveType,stripeApiKey,mrrTarget);

@override
String toString() {
  return 'UserProfileModel(name: $name, objectiveType: $objectiveType, stripeApiKey: $stripeApiKey, mrrTarget: $mrrTarget)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? objectiveType, String? stripeApiKey, String? mrrTarget
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? objectiveType = freezed,Object? stripeApiKey = freezed,Object? mrrTarget = freezed,}) {
  return _then(_UserProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,objectiveType: freezed == objectiveType ? _self.objectiveType : objectiveType // ignore: cast_nullable_to_non_nullable
as String?,stripeApiKey: freezed == stripeApiKey ? _self.stripeApiKey : stripeApiKey // ignore: cast_nullable_to_non_nullable
as String?,mrrTarget: freezed == mrrTarget ? _self.mrrTarget : mrrTarget // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
