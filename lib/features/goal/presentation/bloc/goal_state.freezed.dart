// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState()';
}


}

/// @nodoc
class $GoalStateCopyWith<$Res>  {
$GoalStateCopyWith(GoalState _, $Res Function(GoalState) __);
}


/// Adds pattern-matching-related methods to [GoalState].
extension GoalStatePatterns on GoalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GoalInitial value)?  initial,TResult Function( GoalLoading value)?  loading,TResult Function( GoalLoaded value)?  loaded,TResult Function( GoalError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial(_that);case GoalLoading() when loading != null:
return loading(_that);case GoalLoaded() when loaded != null:
return loaded(_that);case GoalError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GoalInitial value)  initial,required TResult Function( GoalLoading value)  loading,required TResult Function( GoalLoaded value)  loaded,required TResult Function( GoalError value)  error,}){
final _that = this;
switch (_that) {
case GoalInitial():
return initial(_that);case GoalLoading():
return loading(_that);case GoalLoaded():
return loaded(_that);case GoalError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GoalInitial value)?  initial,TResult? Function( GoalLoading value)?  loading,TResult? Function( GoalLoaded value)?  loaded,TResult? Function( GoalError value)?  error,}){
final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial(_that);case GoalLoading() when loading != null:
return loading(_that);case GoalLoaded() when loaded != null:
return loaded(_that);case GoalError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( GoalData data)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial();case GoalLoading() when loading != null:
return loading();case GoalLoaded() when loaded != null:
return loaded(_that.data);case GoalError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( GoalData data)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case GoalInitial():
return initial();case GoalLoading():
return loading();case GoalLoaded():
return loaded(_that.data);case GoalError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( GoalData data)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case GoalInitial() when initial != null:
return initial();case GoalLoading() when loading != null:
return loading();case GoalLoaded() when loaded != null:
return loaded(_that.data);case GoalError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class GoalInitial implements GoalState {
  const GoalInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.initial()';
}


}




/// @nodoc


class GoalLoading implements GoalState {
  const GoalLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GoalState.loading()';
}


}




/// @nodoc


class GoalLoaded implements GoalState {
  const GoalLoaded(this.data);
  

 final  GoalData data;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalLoadedCopyWith<GoalLoaded> get copyWith => _$GoalLoadedCopyWithImpl<GoalLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalLoaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'GoalState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class $GoalLoadedCopyWith<$Res> implements $GoalStateCopyWith<$Res> {
  factory $GoalLoadedCopyWith(GoalLoaded value, $Res Function(GoalLoaded) _then) = _$GoalLoadedCopyWithImpl;
@useResult
$Res call({
 GoalData data
});


$GoalDataCopyWith<$Res> get data;

}
/// @nodoc
class _$GoalLoadedCopyWithImpl<$Res>
    implements $GoalLoadedCopyWith<$Res> {
  _$GoalLoadedCopyWithImpl(this._self, this._then);

  final GoalLoaded _self;
  final $Res Function(GoalLoaded) _then;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(GoalLoaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as GoalData,
  ));
}

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalDataCopyWith<$Res> get data {
  
  return $GoalDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class GoalError implements GoalState {
  const GoalError(this.message);
  

 final  String message;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalErrorCopyWith<GoalError> get copyWith => _$GoalErrorCopyWithImpl<GoalError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GoalState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $GoalErrorCopyWith<$Res> implements $GoalStateCopyWith<$Res> {
  factory $GoalErrorCopyWith(GoalError value, $Res Function(GoalError) _then) = _$GoalErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$GoalErrorCopyWithImpl<$Res>
    implements $GoalErrorCopyWith<$Res> {
  _$GoalErrorCopyWithImpl(this._self, this._then);

  final GoalError _self;
  final $Res Function(GoalError) _then;

/// Create a copy of GoalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(GoalError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
