// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'affirmation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Affirmation {

 int get id; String get text; AffirmationCategory get category; bool get isViewed; bool get isFavorite;
/// Create a copy of Affirmation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AffirmationCopyWith<Affirmation> get copyWith => _$AffirmationCopyWithImpl<Affirmation>(this as Affirmation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Affirmation&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.category, category) || other.category == category)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,category,isViewed,isFavorite);

@override
String toString() {
  return 'Affirmation(id: $id, text: $text, category: $category, isViewed: $isViewed, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $AffirmationCopyWith<$Res>  {
  factory $AffirmationCopyWith(Affirmation value, $Res Function(Affirmation) _then) = _$AffirmationCopyWithImpl;
@useResult
$Res call({
 int id, String text, AffirmationCategory category, bool isViewed, bool isFavorite
});




}
/// @nodoc
class _$AffirmationCopyWithImpl<$Res>
    implements $AffirmationCopyWith<$Res> {
  _$AffirmationCopyWithImpl(this._self, this._then);

  final Affirmation _self;
  final $Res Function(Affirmation) _then;

/// Create a copy of Affirmation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? category = null,Object? isViewed = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AffirmationCategory,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Affirmation].
extension AffirmationPatterns on Affirmation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Affirmation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Affirmation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Affirmation value)  $default,){
final _that = this;
switch (_that) {
case _Affirmation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Affirmation value)?  $default,){
final _that = this;
switch (_that) {
case _Affirmation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String text,  AffirmationCategory category,  bool isViewed,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Affirmation() when $default != null:
return $default(_that.id,_that.text,_that.category,_that.isViewed,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String text,  AffirmationCategory category,  bool isViewed,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _Affirmation():
return $default(_that.id,_that.text,_that.category,_that.isViewed,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String text,  AffirmationCategory category,  bool isViewed,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _Affirmation() when $default != null:
return $default(_that.id,_that.text,_that.category,_that.isViewed,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _Affirmation implements Affirmation {
  const _Affirmation({required this.id, required this.text, required this.category, this.isViewed = false, this.isFavorite = false});
  

@override final  int id;
@override final  String text;
@override final  AffirmationCategory category;
@override@JsonKey() final  bool isViewed;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of Affirmation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AffirmationCopyWith<_Affirmation> get copyWith => __$AffirmationCopyWithImpl<_Affirmation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Affirmation&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.category, category) || other.category == category)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,category,isViewed,isFavorite);

@override
String toString() {
  return 'Affirmation(id: $id, text: $text, category: $category, isViewed: $isViewed, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$AffirmationCopyWith<$Res> implements $AffirmationCopyWith<$Res> {
  factory _$AffirmationCopyWith(_Affirmation value, $Res Function(_Affirmation) _then) = __$AffirmationCopyWithImpl;
@override @useResult
$Res call({
 int id, String text, AffirmationCategory category, bool isViewed, bool isFavorite
});




}
/// @nodoc
class __$AffirmationCopyWithImpl<$Res>
    implements _$AffirmationCopyWith<$Res> {
  __$AffirmationCopyWithImpl(this._self, this._then);

  final _Affirmation _self;
  final $Res Function(_Affirmation) _then;

/// Create a copy of Affirmation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? category = null,Object? isViewed = null,Object? isFavorite = null,}) {
  return _then(_Affirmation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AffirmationCategory,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
