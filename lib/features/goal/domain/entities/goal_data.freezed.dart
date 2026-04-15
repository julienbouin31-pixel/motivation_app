// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalData {

 double get current; double get target; double get changePct; String get objectiveType;// 'mrr' | 'analytics'
 DateTime get lastUpdated;
/// Create a copy of GoalData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalDataCopyWith<GoalData> get copyWith => _$GoalDataCopyWithImpl<GoalData>(this as GoalData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalData&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.changePct, changePct) || other.changePct == changePct)&&(identical(other.objectiveType, objectiveType) || other.objectiveType == objectiveType)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,current,target,changePct,objectiveType,lastUpdated);

@override
String toString() {
  return 'GoalData(current: $current, target: $target, changePct: $changePct, objectiveType: $objectiveType, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $GoalDataCopyWith<$Res>  {
  factory $GoalDataCopyWith(GoalData value, $Res Function(GoalData) _then) = _$GoalDataCopyWithImpl;
@useResult
$Res call({
 double current, double target, double changePct, String objectiveType, DateTime lastUpdated
});




}
/// @nodoc
class _$GoalDataCopyWithImpl<$Res>
    implements $GoalDataCopyWith<$Res> {
  _$GoalDataCopyWithImpl(this._self, this._then);

  final GoalData _self;
  final $Res Function(GoalData) _then;

/// Create a copy of GoalData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? target = null,Object? changePct = null,Object? objectiveType = null,Object? lastUpdated = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,changePct: null == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double,objectiveType: null == objectiveType ? _self.objectiveType : objectiveType // ignore: cast_nullable_to_non_nullable
as String,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalData].
extension GoalDataPatterns on GoalData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalData value)  $default,){
final _that = this;
switch (_that) {
case _GoalData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalData value)?  $default,){
final _that = this;
switch (_that) {
case _GoalData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double current,  double target,  double changePct,  String objectiveType,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalData() when $default != null:
return $default(_that.current,_that.target,_that.changePct,_that.objectiveType,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double current,  double target,  double changePct,  String objectiveType,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _GoalData():
return $default(_that.current,_that.target,_that.changePct,_that.objectiveType,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double current,  double target,  double changePct,  String objectiveType,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _GoalData() when $default != null:
return $default(_that.current,_that.target,_that.changePct,_that.objectiveType,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _GoalData implements GoalData {
  const _GoalData({required this.current, required this.target, required this.changePct, required this.objectiveType, required this.lastUpdated});
  

@override final  double current;
@override final  double target;
@override final  double changePct;
@override final  String objectiveType;
// 'mrr' | 'analytics'
@override final  DateTime lastUpdated;

/// Create a copy of GoalData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalDataCopyWith<_GoalData> get copyWith => __$GoalDataCopyWithImpl<_GoalData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalData&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.changePct, changePct) || other.changePct == changePct)&&(identical(other.objectiveType, objectiveType) || other.objectiveType == objectiveType)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,current,target,changePct,objectiveType,lastUpdated);

@override
String toString() {
  return 'GoalData(current: $current, target: $target, changePct: $changePct, objectiveType: $objectiveType, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$GoalDataCopyWith<$Res> implements $GoalDataCopyWith<$Res> {
  factory _$GoalDataCopyWith(_GoalData value, $Res Function(_GoalData) _then) = __$GoalDataCopyWithImpl;
@override @useResult
$Res call({
 double current, double target, double changePct, String objectiveType, DateTime lastUpdated
});




}
/// @nodoc
class __$GoalDataCopyWithImpl<$Res>
    implements _$GoalDataCopyWith<$Res> {
  __$GoalDataCopyWithImpl(this._self, this._then);

  final _GoalData _self;
  final $Res Function(_GoalData) _then;

/// Create a copy of GoalData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? target = null,Object? changePct = null,Object? objectiveType = null,Object? lastUpdated = null,}) {
  return _then(_GoalData(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,changePct: null == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double,objectiveType: null == objectiveType ? _self.objectiveType : objectiveType // ignore: cast_nullable_to_non_nullable
as String,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
