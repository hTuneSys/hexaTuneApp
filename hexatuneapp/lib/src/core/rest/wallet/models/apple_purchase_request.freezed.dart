// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apple_purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplePurchaseRequest {

 String get packageId; String get transactionId;
/// Create a copy of ApplePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplePurchaseRequestCopyWith<ApplePurchaseRequest> get copyWith => _$ApplePurchaseRequestCopyWithImpl<ApplePurchaseRequest>(this as ApplePurchaseRequest, _$identity);

  /// Serializes this ApplePurchaseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,transactionId);

@override
String toString() {
  return 'ApplePurchaseRequest(packageId: $packageId, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $ApplePurchaseRequestCopyWith<$Res>  {
  factory $ApplePurchaseRequestCopyWith(ApplePurchaseRequest value, $Res Function(ApplePurchaseRequest) _then) = _$ApplePurchaseRequestCopyWithImpl;
@useResult
$Res call({
 String packageId, String transactionId
});




}
/// @nodoc
class _$ApplePurchaseRequestCopyWithImpl<$Res>
    implements $ApplePurchaseRequestCopyWith<$Res> {
  _$ApplePurchaseRequestCopyWithImpl(this._self, this._then);

  final ApplePurchaseRequest _self;
  final $Res Function(ApplePurchaseRequest) _then;

/// Create a copy of ApplePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageId = null,Object? transactionId = null,}) {
  return _then(_self.copyWith(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplePurchaseRequest].
extension ApplePurchaseRequestPatterns on ApplePurchaseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplePurchaseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplePurchaseRequest value)  $default,){
final _that = this;
switch (_that) {
case _ApplePurchaseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplePurchaseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ApplePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageId,  String transactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplePurchaseRequest() when $default != null:
return $default(_that.packageId,_that.transactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageId,  String transactionId)  $default,) {final _that = this;
switch (_that) {
case _ApplePurchaseRequest():
return $default(_that.packageId,_that.transactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageId,  String transactionId)?  $default,) {final _that = this;
switch (_that) {
case _ApplePurchaseRequest() when $default != null:
return $default(_that.packageId,_that.transactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplePurchaseRequest implements ApplePurchaseRequest {
  const _ApplePurchaseRequest({required this.packageId, required this.transactionId});
  factory _ApplePurchaseRequest.fromJson(Map<String, dynamic> json) => _$ApplePurchaseRequestFromJson(json);

@override final  String packageId;
@override final  String transactionId;

/// Create a copy of ApplePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplePurchaseRequestCopyWith<_ApplePurchaseRequest> get copyWith => __$ApplePurchaseRequestCopyWithImpl<_ApplePurchaseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplePurchaseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,transactionId);

@override
String toString() {
  return 'ApplePurchaseRequest(packageId: $packageId, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class _$ApplePurchaseRequestCopyWith<$Res> implements $ApplePurchaseRequestCopyWith<$Res> {
  factory _$ApplePurchaseRequestCopyWith(_ApplePurchaseRequest value, $Res Function(_ApplePurchaseRequest) _then) = __$ApplePurchaseRequestCopyWithImpl;
@override @useResult
$Res call({
 String packageId, String transactionId
});




}
/// @nodoc
class __$ApplePurchaseRequestCopyWithImpl<$Res>
    implements _$ApplePurchaseRequestCopyWith<$Res> {
  __$ApplePurchaseRequestCopyWithImpl(this._self, this._then);

  final _ApplePurchaseRequest _self;
  final $Res Function(_ApplePurchaseRequest) _then;

/// Create a copy of ApplePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageId = null,Object? transactionId = null,}) {
  return _then(_ApplePurchaseRequest(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
