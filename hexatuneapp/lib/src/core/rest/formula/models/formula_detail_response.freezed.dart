// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'formula_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormulaDetailResponse {

 String get id; String get name; List<String> get labels; List<FormulaItemResponse> get items; String get createdAt; String get updatedAt;
/// Create a copy of FormulaDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormulaDetailResponseCopyWith<FormulaDetailResponse> get copyWith => _$FormulaDetailResponseCopyWithImpl<FormulaDetailResponse>(this as FormulaDetailResponse, _$identity);

  /// Serializes this FormulaDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaDetailResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(items),createdAt,updatedAt);

@override
String toString() {
  return 'FormulaDetailResponse(id: $id, name: $name, labels: $labels, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FormulaDetailResponseCopyWith<$Res>  {
  factory $FormulaDetailResponseCopyWith(FormulaDetailResponse value, $Res Function(FormulaDetailResponse) _then) = _$FormulaDetailResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> labels, List<FormulaItemResponse> items, String createdAt, String updatedAt
});




}
/// @nodoc
class _$FormulaDetailResponseCopyWithImpl<$Res>
    implements $FormulaDetailResponseCopyWith<$Res> {
  _$FormulaDetailResponseCopyWithImpl(this._self, this._then);

  final FormulaDetailResponse _self;
  final $Res Function(FormulaDetailResponse) _then;

/// Create a copy of FormulaDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? labels = null,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FormulaItemResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FormulaDetailResponse].
extension FormulaDetailResponsePatterns on FormulaDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormulaDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormulaDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormulaDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _FormulaDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormulaDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FormulaDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> labels,  List<FormulaItemResponse> items,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormulaDetailResponse() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> labels,  List<FormulaItemResponse> items,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FormulaDetailResponse():
return $default(_that.id,_that.name,_that.labels,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> labels,  List<FormulaItemResponse> items,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FormulaDetailResponse() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.items,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormulaDetailResponse implements FormulaDetailResponse {
  const _FormulaDetailResponse({required this.id, required this.name, required final  List<String> labels, required final  List<FormulaItemResponse> items, required this.createdAt, required this.updatedAt}): _labels = labels,_items = items;
  factory _FormulaDetailResponse.fromJson(Map<String, dynamic> json) => _$FormulaDetailResponseFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _labels;
@override List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<FormulaItemResponse> _items;
@override List<FormulaItemResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of FormulaDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormulaDetailResponseCopyWith<_FormulaDetailResponse> get copyWith => __$FormulaDetailResponseCopyWithImpl<_FormulaDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormulaDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormulaDetailResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_items),createdAt,updatedAt);

@override
String toString() {
  return 'FormulaDetailResponse(id: $id, name: $name, labels: $labels, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FormulaDetailResponseCopyWith<$Res> implements $FormulaDetailResponseCopyWith<$Res> {
  factory _$FormulaDetailResponseCopyWith(_FormulaDetailResponse value, $Res Function(_FormulaDetailResponse) _then) = __$FormulaDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> labels, List<FormulaItemResponse> items, String createdAt, String updatedAt
});




}
/// @nodoc
class __$FormulaDetailResponseCopyWithImpl<$Res>
    implements _$FormulaDetailResponseCopyWith<$Res> {
  __$FormulaDetailResponseCopyWithImpl(this._self, this._then);

  final _FormulaDetailResponse _self;
  final $Res Function(_FormulaDetailResponse) _then;

/// Create a copy of FormulaDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? labels = null,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FormulaDetailResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FormulaItemResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
