// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reject_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RejectRequestDto {

 String get rejectingDeviceId;
/// Create a copy of RejectRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RejectRequestDtoCopyWith<RejectRequestDto> get copyWith => _$RejectRequestDtoCopyWithImpl<RejectRequestDto>(this as RejectRequestDto, _$identity);

  /// Serializes this RejectRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RejectRequestDto&&(identical(other.rejectingDeviceId, rejectingDeviceId) || other.rejectingDeviceId == rejectingDeviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rejectingDeviceId);

@override
String toString() {
  return 'RejectRequestDto(rejectingDeviceId: $rejectingDeviceId)';
}


}

/// @nodoc
abstract mixin class $RejectRequestDtoCopyWith<$Res>  {
  factory $RejectRequestDtoCopyWith(RejectRequestDto value, $Res Function(RejectRequestDto) _then) = _$RejectRequestDtoCopyWithImpl;
@useResult
$Res call({
 String rejectingDeviceId
});




}
/// @nodoc
class _$RejectRequestDtoCopyWithImpl<$Res>
    implements $RejectRequestDtoCopyWith<$Res> {
  _$RejectRequestDtoCopyWithImpl(this._self, this._then);

  final RejectRequestDto _self;
  final $Res Function(RejectRequestDto) _then;

/// Create a copy of RejectRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rejectingDeviceId = null,}) {
  return _then(_self.copyWith(
rejectingDeviceId: null == rejectingDeviceId ? _self.rejectingDeviceId : rejectingDeviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RejectRequestDto].
extension RejectRequestDtoPatterns on RejectRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RejectRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RejectRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RejectRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RejectRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RejectRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RejectRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rejectingDeviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RejectRequestDto() when $default != null:
return $default(_that.rejectingDeviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rejectingDeviceId)  $default,) {final _that = this;
switch (_that) {
case _RejectRequestDto():
return $default(_that.rejectingDeviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rejectingDeviceId)?  $default,) {final _that = this;
switch (_that) {
case _RejectRequestDto() when $default != null:
return $default(_that.rejectingDeviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RejectRequestDto implements RejectRequestDto {
  const _RejectRequestDto({required this.rejectingDeviceId});
  factory _RejectRequestDto.fromJson(Map<String, dynamic> json) => _$RejectRequestDtoFromJson(json);

@override final  String rejectingDeviceId;

/// Create a copy of RejectRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectRequestDtoCopyWith<_RejectRequestDto> get copyWith => __$RejectRequestDtoCopyWithImpl<_RejectRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RejectRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectRequestDto&&(identical(other.rejectingDeviceId, rejectingDeviceId) || other.rejectingDeviceId == rejectingDeviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rejectingDeviceId);

@override
String toString() {
  return 'RejectRequestDto(rejectingDeviceId: $rejectingDeviceId)';
}


}

/// @nodoc
abstract mixin class _$RejectRequestDtoCopyWith<$Res> implements $RejectRequestDtoCopyWith<$Res> {
  factory _$RejectRequestDtoCopyWith(_RejectRequestDto value, $Res Function(_RejectRequestDto) _then) = __$RejectRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String rejectingDeviceId
});




}
/// @nodoc
class __$RejectRequestDtoCopyWithImpl<$Res>
    implements _$RejectRequestDtoCopyWith<$Res> {
  __$RejectRequestDtoCopyWithImpl(this._self, this._then);

  final _RejectRequestDto _self;
  final $Res Function(_RejectRequestDto) _then;

/// Create a copy of RejectRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rejectingDeviceId = null,}) {
  return _then(_RejectRequestDto(
rejectingDeviceId: null == rejectingDeviceId ? _self.rejectingDeviceId : rejectingDeviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
