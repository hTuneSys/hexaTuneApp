// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_formula_item_quantity_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateFormulaItemQuantityRequest {

 int get quantity;
/// Create a copy of UpdateFormulaItemQuantityRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateFormulaItemQuantityRequestCopyWith<UpdateFormulaItemQuantityRequest> get copyWith => _$UpdateFormulaItemQuantityRequestCopyWithImpl<UpdateFormulaItemQuantityRequest>(this as UpdateFormulaItemQuantityRequest, _$identity);

  /// Serializes this UpdateFormulaItemQuantityRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateFormulaItemQuantityRequest&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity);

@override
String toString() {
  return 'UpdateFormulaItemQuantityRequest(quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $UpdateFormulaItemQuantityRequestCopyWith<$Res>  {
  factory $UpdateFormulaItemQuantityRequestCopyWith(UpdateFormulaItemQuantityRequest value, $Res Function(UpdateFormulaItemQuantityRequest) _then) = _$UpdateFormulaItemQuantityRequestCopyWithImpl;
@useResult
$Res call({
 int quantity
});




}
/// @nodoc
class _$UpdateFormulaItemQuantityRequestCopyWithImpl<$Res>
    implements $UpdateFormulaItemQuantityRequestCopyWith<$Res> {
  _$UpdateFormulaItemQuantityRequestCopyWithImpl(this._self, this._then);

  final UpdateFormulaItemQuantityRequest _self;
  final $Res Function(UpdateFormulaItemQuantityRequest) _then;

/// Create a copy of UpdateFormulaItemQuantityRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,}) {
  return _then(_self.copyWith(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateFormulaItemQuantityRequest].
extension UpdateFormulaItemQuantityRequestPatterns on UpdateFormulaItemQuantityRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateFormulaItemQuantityRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateFormulaItemQuantityRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateFormulaItemQuantityRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest() when $default != null:
return $default(_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quantity)  $default,) {final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest():
return $default(_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quantity)?  $default,) {final _that = this;
switch (_that) {
case _UpdateFormulaItemQuantityRequest() when $default != null:
return $default(_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateFormulaItemQuantityRequest implements UpdateFormulaItemQuantityRequest {
  const _UpdateFormulaItemQuantityRequest({required this.quantity});
  factory _UpdateFormulaItemQuantityRequest.fromJson(Map<String, dynamic> json) => _$UpdateFormulaItemQuantityRequestFromJson(json);

@override final  int quantity;

/// Create a copy of UpdateFormulaItemQuantityRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateFormulaItemQuantityRequestCopyWith<_UpdateFormulaItemQuantityRequest> get copyWith => __$UpdateFormulaItemQuantityRequestCopyWithImpl<_UpdateFormulaItemQuantityRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateFormulaItemQuantityRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateFormulaItemQuantityRequest&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity);

@override
String toString() {
  return 'UpdateFormulaItemQuantityRequest(quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$UpdateFormulaItemQuantityRequestCopyWith<$Res> implements $UpdateFormulaItemQuantityRequestCopyWith<$Res> {
  factory _$UpdateFormulaItemQuantityRequestCopyWith(_UpdateFormulaItemQuantityRequest value, $Res Function(_UpdateFormulaItemQuantityRequest) _then) = __$UpdateFormulaItemQuantityRequestCopyWithImpl;
@override @useResult
$Res call({
 int quantity
});




}
/// @nodoc
class __$UpdateFormulaItemQuantityRequestCopyWithImpl<$Res>
    implements _$UpdateFormulaItemQuantityRequestCopyWith<$Res> {
  __$UpdateFormulaItemQuantityRequestCopyWithImpl(this._self, this._then);

  final _UpdateFormulaItemQuantityRequest _self;
  final $Res Function(_UpdateFormulaItemQuantityRequest) _then;

/// Create a copy of UpdateFormulaItemQuantityRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,}) {
  return _then(_UpdateFormulaItemQuantityRequest(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
