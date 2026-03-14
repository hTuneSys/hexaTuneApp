// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'formula_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormulaResponse {

 String get id; String get name; List<String> get labels; String get createdAt; String get updatedAt;
/// Create a copy of FormulaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormulaResponseCopyWith<FormulaResponse> get copyWith => _$FormulaResponseCopyWithImpl<FormulaResponse>(this as FormulaResponse, _$identity);

  /// Serializes this FormulaResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(labels),createdAt,updatedAt);

@override
String toString() {
  return 'FormulaResponse(id: $id, name: $name, labels: $labels, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FormulaResponseCopyWith<$Res>  {
  factory $FormulaResponseCopyWith(FormulaResponse value, $Res Function(FormulaResponse) _then) = _$FormulaResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> labels, String createdAt, String updatedAt
});




}
/// @nodoc
class _$FormulaResponseCopyWithImpl<$Res>
    implements $FormulaResponseCopyWith<$Res> {
  _$FormulaResponseCopyWithImpl(this._self, this._then);

  final FormulaResponse _self;
  final $Res Function(FormulaResponse) _then;

/// Create a copy of FormulaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? labels = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FormulaResponse].
extension FormulaResponsePatterns on FormulaResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormulaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormulaResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormulaResponse value)  $default,){
final _that = this;
switch (_that) {
case _FormulaResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormulaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FormulaResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> labels,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormulaResponse() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> labels,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FormulaResponse():
return $default(_that.id,_that.name,_that.labels,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> labels,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FormulaResponse() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormulaResponse implements FormulaResponse {
  const _FormulaResponse({required this.id, required this.name, required final  List<String> labels, required this.createdAt, required this.updatedAt}): _labels = labels;
  factory _FormulaResponse.fromJson(Map<String, dynamic> json) => _$FormulaResponseFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _labels;
@override List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of FormulaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormulaResponseCopyWith<_FormulaResponse> get copyWith => __$FormulaResponseCopyWithImpl<_FormulaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormulaResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormulaResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_labels),createdAt,updatedAt);

@override
String toString() {
  return 'FormulaResponse(id: $id, name: $name, labels: $labels, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FormulaResponseCopyWith<$Res> implements $FormulaResponseCopyWith<$Res> {
  factory _$FormulaResponseCopyWith(_FormulaResponse value, $Res Function(_FormulaResponse) _then) = __$FormulaResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> labels, String createdAt, String updatedAt
});




}
/// @nodoc
class __$FormulaResponseCopyWithImpl<$Res>
    implements _$FormulaResponseCopyWith<$Res> {
  __$FormulaResponseCopyWithImpl(this._self, this._then);

  final _FormulaResponse _self;
  final $Res Function(_FormulaResponse) _then;

/// Create a copy of FormulaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? labels = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FormulaResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
