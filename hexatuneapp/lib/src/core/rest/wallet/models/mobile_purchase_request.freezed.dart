// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MobilePurchaseRequest {

 String get packageId; String get receiptData;
/// Create a copy of MobilePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobilePurchaseRequestCopyWith<MobilePurchaseRequest> get copyWith => _$MobilePurchaseRequestCopyWithImpl<MobilePurchaseRequest>(this as MobilePurchaseRequest, _$identity);

  /// Serializes this MobilePurchaseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobilePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.receiptData, receiptData) || other.receiptData == receiptData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,receiptData);

@override
String toString() {
  return 'MobilePurchaseRequest(packageId: $packageId, receiptData: $receiptData)';
}


}

/// @nodoc
abstract mixin class $MobilePurchaseRequestCopyWith<$Res>  {
  factory $MobilePurchaseRequestCopyWith(MobilePurchaseRequest value, $Res Function(MobilePurchaseRequest) _then) = _$MobilePurchaseRequestCopyWithImpl;
@useResult
$Res call({
 String packageId, String receiptData
});




}
/// @nodoc
class _$MobilePurchaseRequestCopyWithImpl<$Res>
    implements $MobilePurchaseRequestCopyWith<$Res> {
  _$MobilePurchaseRequestCopyWithImpl(this._self, this._then);

  final MobilePurchaseRequest _self;
  final $Res Function(MobilePurchaseRequest) _then;

/// Create a copy of MobilePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageId = null,Object? receiptData = null,}) {
  return _then(_self.copyWith(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,receiptData: null == receiptData ? _self.receiptData : receiptData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MobilePurchaseRequest].
extension MobilePurchaseRequestPatterns on MobilePurchaseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobilePurchaseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobilePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobilePurchaseRequest value)  $default,){
final _that = this;
switch (_that) {
case _MobilePurchaseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobilePurchaseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MobilePurchaseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageId,  String receiptData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobilePurchaseRequest() when $default != null:
return $default(_that.packageId,_that.receiptData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageId,  String receiptData)  $default,) {final _that = this;
switch (_that) {
case _MobilePurchaseRequest():
return $default(_that.packageId,_that.receiptData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageId,  String receiptData)?  $default,) {final _that = this;
switch (_that) {
case _MobilePurchaseRequest() when $default != null:
return $default(_that.packageId,_that.receiptData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MobilePurchaseRequest implements MobilePurchaseRequest {
  const _MobilePurchaseRequest({required this.packageId, required this.receiptData});
  factory _MobilePurchaseRequest.fromJson(Map<String, dynamic> json) => _$MobilePurchaseRequestFromJson(json);

@override final  String packageId;
@override final  String receiptData;

/// Create a copy of MobilePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobilePurchaseRequestCopyWith<_MobilePurchaseRequest> get copyWith => __$MobilePurchaseRequestCopyWithImpl<_MobilePurchaseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MobilePurchaseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobilePurchaseRequest&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.receiptData, receiptData) || other.receiptData == receiptData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,receiptData);

@override
String toString() {
  return 'MobilePurchaseRequest(packageId: $packageId, receiptData: $receiptData)';
}


}

/// @nodoc
abstract mixin class _$MobilePurchaseRequestCopyWith<$Res> implements $MobilePurchaseRequestCopyWith<$Res> {
  factory _$MobilePurchaseRequestCopyWith(_MobilePurchaseRequest value, $Res Function(_MobilePurchaseRequest) _then) = __$MobilePurchaseRequestCopyWithImpl;
@override @useResult
$Res call({
 String packageId, String receiptData
});




}
/// @nodoc
class __$MobilePurchaseRequestCopyWithImpl<$Res>
    implements _$MobilePurchaseRequestCopyWith<$Res> {
  __$MobilePurchaseRequestCopyWithImpl(this._self, this._then);

  final _MobilePurchaseRequest _self;
  final $Res Function(_MobilePurchaseRequest) _then;

/// Create a copy of MobilePurchaseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageId = null,Object? receiptData = null,}) {
  return _then(_MobilePurchaseRequest(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,receiptData: null == receiptData ? _self.receiptData : receiptData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
