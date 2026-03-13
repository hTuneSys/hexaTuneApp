// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initiate_purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InitiatePurchaseRequest {

 String get packageId;
/// Create a copy of InitiatePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitiatePurchaseRequestCopyWith<InitiatePurchaseRequest> get copyWith => _$InitiatePurchaseRequestCopyWithImpl<InitiatePurchaseRequest>(this as InitiatePurchaseRequest, _$identity);

  /// Serializes this InitiatePurchaseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitiatePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId);

@override
String toString() {
  return 'InitiatePurchaseRequest(packageId: $packageId)';
}


}

/// @nodoc
abstract mixin class $InitiatePurchaseRequestCopyWith<$Res>  {
  factory $InitiatePurchaseRequestCopyWith(InitiatePurchaseRequest value, $Res Function(InitiatePurchaseRequest) _then) = _$InitiatePurchaseRequestCopyWithImpl;
@useResult
$Res call({
 String packageId
});




}
/// @nodoc
class _$InitiatePurchaseRequestCopyWithImpl<$Res>
    implements $InitiatePurchaseRequestCopyWith<$Res> {
  _$InitiatePurchaseRequestCopyWithImpl(this._self, this._then);

  final InitiatePurchaseRequest _self;
  final $Res Function(InitiatePurchaseRequest) _then;

/// Create a copy of InitiatePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageId = null,}) {
  return _then(_self.copyWith(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InitiatePurchaseRequest].
extension InitiatePurchaseRequestPatterns on InitiatePurchaseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InitiatePurchaseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitiatePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InitiatePurchaseRequest value)  $default,){
final _that = this;
switch (_that) {
case _InitiatePurchaseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InitiatePurchaseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _InitiatePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitiatePurchaseRequest() when $default != null:
return $default(_that.packageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageId)  $default,) {final _that = this;
switch (_that) {
case _InitiatePurchaseRequest():
return $default(_that.packageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageId)?  $default,) {final _that = this;
switch (_that) {
case _InitiatePurchaseRequest() when $default != null:
return $default(_that.packageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InitiatePurchaseRequest implements InitiatePurchaseRequest {
  const _InitiatePurchaseRequest({required this.packageId});
  factory _InitiatePurchaseRequest.fromJson(Map<String, dynamic> json) => _$InitiatePurchaseRequestFromJson(json);

@override final  String packageId;

/// Create a copy of InitiatePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitiatePurchaseRequestCopyWith<_InitiatePurchaseRequest> get copyWith => __$InitiatePurchaseRequestCopyWithImpl<_InitiatePurchaseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InitiatePurchaseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitiatePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId);

@override
String toString() {
  return 'InitiatePurchaseRequest(packageId: $packageId)';
}


}

/// @nodoc
abstract mixin class _$InitiatePurchaseRequestCopyWith<$Res> implements $InitiatePurchaseRequestCopyWith<$Res> {
  factory _$InitiatePurchaseRequestCopyWith(_InitiatePurchaseRequest value, $Res Function(_InitiatePurchaseRequest) _then) = __$InitiatePurchaseRequestCopyWithImpl;
@override @useResult
$Res call({
 String packageId
});




}
/// @nodoc
class __$InitiatePurchaseRequestCopyWithImpl<$Res>
    implements _$InitiatePurchaseRequestCopyWith<$Res> {
  __$InitiatePurchaseRequestCopyWithImpl(this._self, this._then);

  final _InitiatePurchaseRequest _self;
  final $Res Function(_InitiatePurchaseRequest) _then;

/// Create a copy of InitiatePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageId = null,}) {
  return _then(_InitiatePurchaseRequest(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
