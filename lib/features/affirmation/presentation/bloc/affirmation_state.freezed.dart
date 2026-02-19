// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'affirmation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AffirmationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffirmationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AffirmationState()';
}


}

/// @nodoc
class $AffirmationStateCopyWith<$Res>  {
$AffirmationStateCopyWith(AffirmationState _, $Res Function(AffirmationState) __);
}


/// Adds pattern-matching-related methods to [AffirmationState].
extension AffirmationStatePatterns on AffirmationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AffirmationInitial value)?  initial,TResult Function( AffirmationLoading value)?  loading,TResult Function( AffirmationLoaded value)?  loaded,TResult Function( AffirmationError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AffirmationInitial() when initial != null:
return initial(_that);case AffirmationLoading() when loading != null:
return loading(_that);case AffirmationLoaded() when loaded != null:
return loaded(_that);case AffirmationError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AffirmationInitial value)  initial,required TResult Function( AffirmationLoading value)  loading,required TResult Function( AffirmationLoaded value)  loaded,required TResult Function( AffirmationError value)  error,}){
final _that = this;
switch (_that) {
case AffirmationInitial():
return initial(_that);case AffirmationLoading():
return loading(_that);case AffirmationLoaded():
return loaded(_that);case AffirmationError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AffirmationInitial value)?  initial,TResult? Function( AffirmationLoading value)?  loading,TResult? Function( AffirmationLoaded value)?  loaded,TResult? Function( AffirmationError value)?  error,}){
final _that = this;
switch (_that) {
case AffirmationInitial() when initial != null:
return initial(_that);case AffirmationLoading() when loading != null:
return loading(_that);case AffirmationLoaded() when loaded != null:
return loaded(_that);case AffirmationError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Affirmation affirmation,  AffirmationCategory selectedCategory)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AffirmationInitial() when initial != null:
return initial();case AffirmationLoading() when loading != null:
return loading();case AffirmationLoaded() when loaded != null:
return loaded(_that.affirmation,_that.selectedCategory);case AffirmationError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Affirmation affirmation,  AffirmationCategory selectedCategory)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AffirmationInitial():
return initial();case AffirmationLoading():
return loading();case AffirmationLoaded():
return loaded(_that.affirmation,_that.selectedCategory);case AffirmationError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Affirmation affirmation,  AffirmationCategory selectedCategory)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AffirmationInitial() when initial != null:
return initial();case AffirmationLoading() when loading != null:
return loading();case AffirmationLoaded() when loaded != null:
return loaded(_that.affirmation,_that.selectedCategory);case AffirmationError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AffirmationInitial implements AffirmationState {
  const AffirmationInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffirmationInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AffirmationState.initial()';
}


}




/// @nodoc


class AffirmationLoading implements AffirmationState {
  const AffirmationLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffirmationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AffirmationState.loading()';
}


}




/// @nodoc


class AffirmationLoaded implements AffirmationState {
  const AffirmationLoaded({required this.affirmation, required this.selectedCategory});
  

 final  Affirmation affirmation;
 final  AffirmationCategory selectedCategory;

/// Create a copy of AffirmationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AffirmationLoadedCopyWith<AffirmationLoaded> get copyWith => _$AffirmationLoadedCopyWithImpl<AffirmationLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffirmationLoaded&&(identical(other.affirmation, affirmation) || other.affirmation == affirmation)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory));
}


@override
int get hashCode => Object.hash(runtimeType,affirmation,selectedCategory);

@override
String toString() {
  return 'AffirmationState.loaded(affirmation: $affirmation, selectedCategory: $selectedCategory)';
}


}

/// @nodoc
abstract mixin class $AffirmationLoadedCopyWith<$Res> implements $AffirmationStateCopyWith<$Res> {
  factory $AffirmationLoadedCopyWith(AffirmationLoaded value, $Res Function(AffirmationLoaded) _then) = _$AffirmationLoadedCopyWithImpl;
@useResult
$Res call({
 Affirmation affirmation, AffirmationCategory selectedCategory
});


$AffirmationCopyWith<$Res> get affirmation;

}
/// @nodoc
class _$AffirmationLoadedCopyWithImpl<$Res>
    implements $AffirmationLoadedCopyWith<$Res> {
  _$AffirmationLoadedCopyWithImpl(this._self, this._then);

  final AffirmationLoaded _self;
  final $Res Function(AffirmationLoaded) _then;

/// Create a copy of AffirmationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? affirmation = null,Object? selectedCategory = null,}) {
  return _then(AffirmationLoaded(
affirmation: null == affirmation ? _self.affirmation : affirmation // ignore: cast_nullable_to_non_nullable
as Affirmation,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as AffirmationCategory,
  ));
}

/// Create a copy of AffirmationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AffirmationCopyWith<$Res> get affirmation {
  
  return $AffirmationCopyWith<$Res>(_self.affirmation, (value) {
    return _then(_self.copyWith(affirmation: value));
  });
}
}

/// @nodoc


class AffirmationError implements AffirmationState {
  const AffirmationError(this.message);
  

 final  String message;

/// Create a copy of AffirmationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AffirmationErrorCopyWith<AffirmationError> get copyWith => _$AffirmationErrorCopyWithImpl<AffirmationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffirmationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AffirmationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AffirmationErrorCopyWith<$Res> implements $AffirmationStateCopyWith<$Res> {
  factory $AffirmationErrorCopyWith(AffirmationError value, $Res Function(AffirmationError) _then) = _$AffirmationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AffirmationErrorCopyWithImpl<$Res>
    implements $AffirmationErrorCopyWith<$Res> {
  _$AffirmationErrorCopyWithImpl(this._self, this._then);

  final AffirmationError _self;
  final $Res Function(AffirmationError) _then;

/// Create a copy of AffirmationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AffirmationError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
