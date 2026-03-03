// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_approval_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateApprovalRequestDto {

 String get requestingDeviceId; String get operationType; Map<String, dynamic>? get operationMetadata;
/// Create a copy of CreateApprovalRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateApprovalRequestDtoCopyWith<CreateApprovalRequestDto> get copyWith => _$CreateApprovalRequestDtoCopyWithImpl<CreateApprovalRequestDto>(this as CreateApprovalRequestDto, _$identity);

  /// Serializes this CreateApprovalRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateApprovalRequestDto&&(identical(other.requestingDeviceId, requestingDeviceId) || other.requestingDeviceId == requestingDeviceId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&const DeepCollectionEquality().equals(other.operationMetadata, operationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestingDeviceId,operationType,const DeepCollectionEquality().hash(operationMetadata));

@override
String toString() {
  return 'CreateApprovalRequestDto(requestingDeviceId: $requestingDeviceId, operationType: $operationType, operationMetadata: $operationMetadata)';
}


}

/// @nodoc
abstract mixin class $CreateApprovalRequestDtoCopyWith<$Res>  {
  factory $CreateApprovalRequestDtoCopyWith(CreateApprovalRequestDto value, $Res Function(CreateApprovalRequestDto) _then) = _$CreateApprovalRequestDtoCopyWithImpl;
@useResult
$Res call({
 String requestingDeviceId, String operationType, Map<String, dynamic>? operationMetadata
});




}
/// @nodoc
class _$CreateApprovalRequestDtoCopyWithImpl<$Res>
    implements $CreateApprovalRequestDtoCopyWith<$Res> {
  _$CreateApprovalRequestDtoCopyWithImpl(this._self, this._then);

  final CreateApprovalRequestDto _self;
  final $Res Function(CreateApprovalRequestDto) _then;

/// Create a copy of CreateApprovalRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestingDeviceId = null,Object? operationType = null,Object? operationMetadata = freezed,}) {
  return _then(_self.copyWith(
requestingDeviceId: null == requestingDeviceId ? _self.requestingDeviceId : requestingDeviceId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,operationMetadata: freezed == operationMetadata ? _self.operationMetadata : operationMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateApprovalRequestDto].
extension CreateApprovalRequestDtoPatterns on CreateApprovalRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateApprovalRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateApprovalRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateApprovalRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateApprovalRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateApprovalRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateApprovalRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestingDeviceId,  String operationType,  Map<String, dynamic>? operationMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateApprovalRequestDto() when $default != null:
return $default(_that.requestingDeviceId,_that.operationType,_that.operationMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestingDeviceId,  String operationType,  Map<String, dynamic>? operationMetadata)  $default,) {final _that = this;
switch (_that) {
case _CreateApprovalRequestDto():
return $default(_that.requestingDeviceId,_that.operationType,_that.operationMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestingDeviceId,  String operationType,  Map<String, dynamic>? operationMetadata)?  $default,) {final _that = this;
switch (_that) {
case _CreateApprovalRequestDto() when $default != null:
return $default(_that.requestingDeviceId,_that.operationType,_that.operationMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateApprovalRequestDto implements CreateApprovalRequestDto {
  const _CreateApprovalRequestDto({required this.requestingDeviceId, required this.operationType, final  Map<String, dynamic>? operationMetadata}): _operationMetadata = operationMetadata;
  factory _CreateApprovalRequestDto.fromJson(Map<String, dynamic> json) => _$CreateApprovalRequestDtoFromJson(json);

@override final  String requestingDeviceId;
@override final  String operationType;
 final  Map<String, dynamic>? _operationMetadata;
@override Map<String, dynamic>? get operationMetadata {
  final value = _operationMetadata;
  if (value == null) return null;
  if (_operationMetadata is EqualUnmodifiableMapView) return _operationMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CreateApprovalRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateApprovalRequestDtoCopyWith<_CreateApprovalRequestDto> get copyWith => __$CreateApprovalRequestDtoCopyWithImpl<_CreateApprovalRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateApprovalRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateApprovalRequestDto&&(identical(other.requestingDeviceId, requestingDeviceId) || other.requestingDeviceId == requestingDeviceId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&const DeepCollectionEquality().equals(other._operationMetadata, _operationMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestingDeviceId,operationType,const DeepCollectionEquality().hash(_operationMetadata));

@override
String toString() {
  return 'CreateApprovalRequestDto(requestingDeviceId: $requestingDeviceId, operationType: $operationType, operationMetadata: $operationMetadata)';
}


}

/// @nodoc
abstract mixin class _$CreateApprovalRequestDtoCopyWith<$Res> implements $CreateApprovalRequestDtoCopyWith<$Res> {
  factory _$CreateApprovalRequestDtoCopyWith(_CreateApprovalRequestDto value, $Res Function(_CreateApprovalRequestDto) _then) = __$CreateApprovalRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String requestingDeviceId, String operationType, Map<String, dynamic>? operationMetadata
});




}
/// @nodoc
class __$CreateApprovalRequestDtoCopyWithImpl<$Res>
    implements _$CreateApprovalRequestDtoCopyWith<$Res> {
  __$CreateApprovalRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateApprovalRequestDto _self;
  final $Res Function(_CreateApprovalRequestDto) _then;

/// Create a copy of CreateApprovalRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestingDeviceId = null,Object? operationType = null,Object? operationMetadata = freezed,}) {
  return _then(_CreateApprovalRequestDto(
requestingDeviceId: null == requestingDeviceId ? _self.requestingDeviceId : requestingDeviceId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,operationMetadata: freezed == operationMetadata ? _self._operationMetadata : operationMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
