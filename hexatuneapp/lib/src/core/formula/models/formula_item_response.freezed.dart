// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'formula_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormulaItemResponse {

 String get id; String get inventoryId; int get sortOrder; int get quantity;
/// Create a copy of FormulaItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormulaItemResponseCopyWith<FormulaItemResponse> get copyWith => _$FormulaItemResponseCopyWithImpl<FormulaItemResponse>(this as FormulaItemResponse, _$identity);

  /// Serializes this FormulaItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,sortOrder,quantity);

@override
String toString() {
  return 'FormulaItemResponse(id: $id, inventoryId: $inventoryId, sortOrder: $sortOrder, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $FormulaItemResponseCopyWith<$Res>  {
  factory $FormulaItemResponseCopyWith(FormulaItemResponse value, $Res Function(FormulaItemResponse) _then) = _$FormulaItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String inventoryId, int sortOrder, int quantity
});




}
/// @nodoc
class _$FormulaItemResponseCopyWithImpl<$Res>
    implements $FormulaItemResponseCopyWith<$Res> {
  _$FormulaItemResponseCopyWithImpl(this._self, this._then);

  final FormulaItemResponse _self;
  final $Res Function(FormulaItemResponse) _then;

/// Create a copy of FormulaItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inventoryId = null,Object? sortOrder = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FormulaItemResponse].
extension FormulaItemResponsePatterns on FormulaItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormulaItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormulaItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormulaItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _FormulaItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormulaItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FormulaItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inventoryId,  int sortOrder,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormulaItemResponse() when $default != null:
return $default(_that.id,_that.inventoryId,_that.sortOrder,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inventoryId,  int sortOrder,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _FormulaItemResponse():
return $default(_that.id,_that.inventoryId,_that.sortOrder,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inventoryId,  int sortOrder,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _FormulaItemResponse() when $default != null:
return $default(_that.id,_that.inventoryId,_that.sortOrder,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormulaItemResponse implements FormulaItemResponse {
  const _FormulaItemResponse({required this.id, required this.inventoryId, required this.sortOrder, required this.quantity});
  factory _FormulaItemResponse.fromJson(Map<String, dynamic> json) => _$FormulaItemResponseFromJson(json);

@override final  String id;
@override final  String inventoryId;
@override final  int sortOrder;
@override final  int quantity;

/// Create a copy of FormulaItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormulaItemResponseCopyWith<_FormulaItemResponse> get copyWith => __$FormulaItemResponseCopyWithImpl<_FormulaItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormulaItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormulaItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,sortOrder,quantity);

@override
String toString() {
  return 'FormulaItemResponse(id: $id, inventoryId: $inventoryId, sortOrder: $sortOrder, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$FormulaItemResponseCopyWith<$Res> implements $FormulaItemResponseCopyWith<$Res> {
  factory _$FormulaItemResponseCopyWith(_FormulaItemResponse value, $Res Function(_FormulaItemResponse) _then) = __$FormulaItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String inventoryId, int sortOrder, int quantity
});




}
/// @nodoc
class __$FormulaItemResponseCopyWithImpl<$Res>
    implements _$FormulaItemResponseCopyWith<$Res> {
  __$FormulaItemResponseCopyWithImpl(this._self, this._then);

  final _FormulaItemResponse _self;
  final $Res Function(_FormulaItemResponse) _then;

/// Create a copy of FormulaItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inventoryId = null,Object? sortOrder = null,Object? quantity = null,}) {
  return _then(_FormulaItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
