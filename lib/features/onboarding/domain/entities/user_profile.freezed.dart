// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String? get name; String? get mood; String? get goal; String? get tone;// ton préféré : direct | doux | poetique | percutant
 String? get lifeArea;// ce qui pèse : travail | famille | relations | sante | argent
 String? get struggle;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.lifeArea, lifeArea) || other.lifeArea == lifeArea)&&(identical(other.struggle, struggle) || other.struggle == struggle));
}


@override
int get hashCode => Object.hash(runtimeType,name,mood,goal,tone,lifeArea,struggle);

@override
String toString() {
  return 'UserProfile(name: $name, mood: $mood, goal: $goal, tone: $tone, lifeArea: $lifeArea, struggle: $struggle)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String? name, String? mood, String? goal, String? tone, String? lifeArea, String? struggle
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? mood = freezed,Object? goal = freezed,Object? tone = freezed,Object? lifeArea = freezed,Object? struggle = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,lifeArea: freezed == lifeArea ? _self.lifeArea : lifeArea // ignore: cast_nullable_to_non_nullable
as String?,struggle: freezed == struggle ? _self.struggle : struggle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? mood,  String? goal,  String? tone,  String? lifeArea,  String? struggle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.mood,_that.goal,_that.tone,_that.lifeArea,_that.struggle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? mood,  String? goal,  String? tone,  String? lifeArea,  String? struggle)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.name,_that.mood,_that.goal,_that.tone,_that.lifeArea,_that.struggle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? mood,  String? goal,  String? tone,  String? lifeArea,  String? struggle)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.mood,_that.goal,_that.tone,_that.lifeArea,_that.struggle);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({this.name, this.mood, this.goal, this.tone, this.lifeArea, this.struggle});
  

@override final  String? name;
@override final  String? mood;
@override final  String? goal;
@override final  String? tone;
// ton préféré : direct | doux | poetique | percutant
@override final  String? lifeArea;
// ce qui pèse : travail | famille | relations | sante | argent
@override final  String? struggle;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.lifeArea, lifeArea) || other.lifeArea == lifeArea)&&(identical(other.struggle, struggle) || other.struggle == struggle));
}


@override
int get hashCode => Object.hash(runtimeType,name,mood,goal,tone,lifeArea,struggle);

@override
String toString() {
  return 'UserProfile(name: $name, mood: $mood, goal: $goal, tone: $tone, lifeArea: $lifeArea, struggle: $struggle)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? mood, String? goal, String? tone, String? lifeArea, String? struggle
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? mood = freezed,Object? goal = freezed,Object? tone = freezed,Object? lifeArea = freezed,Object? struggle = freezed,}) {
  return _then(_UserProfile(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,lifeArea: freezed == lifeArea ? _self.lifeArea : lifeArea // ignore: cast_nullable_to_non_nullable
as String?,struggle: freezed == struggle ? _self.struggle : struggle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
