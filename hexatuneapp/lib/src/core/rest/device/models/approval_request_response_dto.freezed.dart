// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_request_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApprovalRequestResponseDto {

 String get requestId; String get accountId; String get requestingDeviceId; String get operationType; String get status; String get createdAt; String get expiresAt; bool get isExpired; String? get approvingDeviceId; String? get approvedAt; String? get rejectedAt; Map<String, dynamic>? get operationMetadata;
/// Create a copy of ApprovalRequestResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalRequestResponseDtoCopyWith<ApprovalRequestResponseDto> get copyWith => _$ApprovalRequestResponseDtoCopyWithImpl<ApprovalRequestResponseDto>(this as ApprovalRequestResponseDto, _$identity);

  /// Serializes this ApprovalRequestResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalRequestResponseDto&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.requestingDeviceId, requestingDeviceId) || other.requestingDeviceId == requestingDeviceId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.approvingDeviceId, approvingDeviceId) || other.approvingDeviceId == approvingDeviceId)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&const DeepCollectionEquality().equals(other.operationMetadata, operationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,accountId,requestingDeviceId,operationType,status,createdAt,expiresAt,isExpired,approvingDeviceId,approvedAt,rejectedAt,const DeepCollectionEquality().hash(operationMetadata));

@override
String toString() {
  return 'ApprovalRequestResponseDto(requestId: $requestId, accountId: $accountId, requestingDeviceId: $requestingDeviceId, operationType: $operationType, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, isExpired: $isExpired, approvingDeviceId: $approvingDeviceId, approvedAt: $approvedAt, rejectedAt: $rejectedAt, operationMetadata: $operationMetadata)';
}


}

/// @nodoc
abstract mixin class $ApprovalRequestResponseDtoCopyWith<$Res>  {
  factory $ApprovalRequestResponseDtoCopyWith(ApprovalRequestResponseDto value, $Res Function(ApprovalRequestResponseDto) _then) = _$ApprovalRequestResponseDtoCopyWithImpl;
@useResult
$Res call({
 String requestId, String accountId, String requestingDeviceId, String operationType, String status, String createdAt, String expiresAt, bool isExpired, String? approvingDeviceId, String? approvedAt, String? rejectedAt, Map<String, dynamic>? operationMetadata
});




}
/// @nodoc
class _$ApprovalRequestResponseDtoCopyWithImpl<$Res>
    implements $ApprovalRequestResponseDtoCopyWith<$Res> {
  _$ApprovalRequestResponseDtoCopyWithImpl(this._self, this._then);

  final ApprovalRequestResponseDto _self;
  final $Res Function(ApprovalRequestResponseDto) _then;

/// Create a copy of ApprovalRequestResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? accountId = null,Object? requestingDeviceId = null,Object? operationType = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? isExpired = null,Object? approvingDeviceId = freezed,Object? approvedAt = freezed,Object? rejectedAt = freezed,Object? operationMetadata = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,requestingDeviceId: null == requestingDeviceId ? _self.requestingDeviceId : requestingDeviceId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,approvingDeviceId: freezed == approvingDeviceId ? _self.approvingDeviceId : approvingDeviceId // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,operationMetadata: freezed == operationMetadata ? _self.operationMetadata : operationMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalRequestResponseDto].
extension ApprovalRequestResponseDtoPatterns on ApprovalRequestResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalRequestResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalRequestResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalRequestResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String accountId,  String requestingDeviceId,  String operationType,  String status,  String createdAt,  String expiresAt,  bool isExpired,  String? approvingDeviceId,  String? approvedAt,  String? rejectedAt,  Map<String, dynamic>? operationMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto() when $default != null:
return $default(_that.requestId,_that.accountId,_that.requestingDeviceId,_that.operationType,_that.status,_that.createdAt,_that.expiresAt,_that.isExpired,_that.approvingDeviceId,_that.approvedAt,_that.rejectedAt,_that.operationMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String accountId,  String requestingDeviceId,  String operationType,  String status,  String createdAt,  String expiresAt,  bool isExpired,  String? approvingDeviceId,  String? approvedAt,  String? rejectedAt,  Map<String, dynamic>? operationMetadata)  $default,) {final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto():
return $default(_that.requestId,_that.accountId,_that.requestingDeviceId,_that.operationType,_that.status,_that.createdAt,_that.expiresAt,_that.isExpired,_that.approvingDeviceId,_that.approvedAt,_that.rejectedAt,_that.operationMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String accountId,  String requestingDeviceId,  String operationType,  String status,  String createdAt,  String expiresAt,  bool isExpired,  String? approvingDeviceId,  String? approvedAt,  String? rejectedAt,  Map<String, dynamic>? operationMetadata)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalRequestResponseDto() when $default != null:
return $default(_that.requestId,_that.accountId,_that.requestingDeviceId,_that.operationType,_that.status,_that.createdAt,_that.expiresAt,_that.isExpired,_that.approvingDeviceId,_that.approvedAt,_that.rejectedAt,_that.operationMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalRequestResponseDto implements ApprovalRequestResponseDto {
  const _ApprovalRequestResponseDto({required this.requestId, required this.accountId, required this.requestingDeviceId, required this.operationType, required this.status, required this.createdAt, required this.expiresAt, required this.isExpired, this.approvingDeviceId, this.approvedAt, this.rejectedAt, final  Map<String, dynamic>? operationMetadata}): _operationMetadata = operationMetadata;
  factory _ApprovalRequestResponseDto.fromJson(Map<String, dynamic> json) => _$ApprovalRequestResponseDtoFromJson(json);

@override final  String requestId;
@override final  String accountId;
@override final  String requestingDeviceId;
@override final  String operationType;
@override final  String status;
@override final  String createdAt;
@override final  String expiresAt;
@override final  bool isExpired;
@override final  String? approvingDeviceId;
@override final  String? approvedAt;
@override final  String? rejectedAt;
 final  Map<String, dynamic>? _operationMetadata;
@override Map<String, dynamic>? get operationMetadata {
  final value = _operationMetadata;
  if (value == null) return null;
  if (_operationMetadata is EqualUnmodifiableMapView) return _operationMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ApprovalRequestResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalRequestResponseDtoCopyWith<_ApprovalRequestResponseDto> get copyWith => __$ApprovalRequestResponseDtoCopyWithImpl<_ApprovalRequestResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalRequestResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalRequestResponseDto&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.requestingDeviceId, requestingDeviceId) || other.requestingDeviceId == requestingDeviceId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.approvingDeviceId, approvingDeviceId) || other.approvingDeviceId == approvingDeviceId)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&const DeepCollectionEquality().equals(other._operationMetadata, _operationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,accountId,requestingDeviceId,operationType,status,createdAt,expiresAt,isExpired,approvingDeviceId,approvedAt,rejectedAt,const DeepCollectionEquality().hash(_operationMetadata));

@override
String toString() {
  return 'ApprovalRequestResponseDto(requestId: $requestId, accountId: $accountId, requestingDeviceId: $requestingDeviceId, operationType: $operationType, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, isExpired: $isExpired, approvingDeviceId: $approvingDeviceId, approvedAt: $approvedAt, rejectedAt: $rejectedAt, operationMetadata: $operationMetadata)';
}


}

/// @nodoc
abstract mixin class _$ApprovalRequestResponseDtoCopyWith<$Res> implements $ApprovalRequestResponseDtoCopyWith<$Res> {
  factory _$ApprovalRequestResponseDtoCopyWith(_ApprovalRequestResponseDto value, $Res Function(_ApprovalRequestResponseDto) _then) = __$ApprovalRequestResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String accountId, String requestingDeviceId, String operationType, String status, String createdAt, String expiresAt, bool isExpired, String? approvingDeviceId, String? approvedAt, String? rejectedAt, Map<String, dynamic>? operationMetadata
});




}
/// @nodoc
class __$ApprovalRequestResponseDtoCopyWithImpl<$Res>
    implements _$ApprovalRequestResponseDtoCopyWith<$Res> {
  __$ApprovalRequestResponseDtoCopyWithImpl(this._self, this._then);

  final _ApprovalRequestResponseDto _self;
  final $Res Function(_ApprovalRequestResponseDto) _then;

/// Create a copy of ApprovalRequestResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? accountId = null,Object? requestingDeviceId = null,Object? operationType = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? isExpired = null,Object? approvingDeviceId = freezed,Object? approvedAt = freezed,Object? rejectedAt = freezed,Object? operationMetadata = freezed,}) {
  return _then(_ApprovalRequestResponseDto(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,requestingDeviceId: null == requestingDeviceId ? _self.requestingDeviceId : requestingDeviceId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,approvingDeviceId: freezed == approvingDeviceId ? _self.approvingDeviceId : approvingDeviceId // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,operationMetadata: freezed == operationMetadata ? _self._operationMetadata : operationMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
