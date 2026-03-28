// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harmonic_packet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HarmonicPacketDto {

/// The harmonic value for this packet.
 int get value;/// Duration in milliseconds.
 int get durationMs;/// Whether this packet harmonizes only once (in the first cycle).
 bool get isOneShot;
/// Create a copy of HarmonicPacketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarmonicPacketDtoCopyWith<HarmonicPacketDto> get copyWith => _$HarmonicPacketDtoCopyWithImpl<HarmonicPacketDto>(this as HarmonicPacketDto, _$identity);

  /// Serializes this HarmonicPacketDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarmonicPacketDto&&(identical(other.value, value) || other.value == value)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.isOneShot, isOneShot) || other.isOneShot == isOneShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,durationMs,isOneShot);

@override
String toString() {
  return 'HarmonicPacketDto(value: $value, durationMs: $durationMs, isOneShot: $isOneShot)';
}


}

/// @nodoc
abstract mixin class $HarmonicPacketDtoCopyWith<$Res>  {
  factory $HarmonicPacketDtoCopyWith(HarmonicPacketDto value, $Res Function(HarmonicPacketDto) _then) = _$HarmonicPacketDtoCopyWithImpl;
@useResult
$Res call({
 int value, int durationMs, bool isOneShot
});




}
/// @nodoc
class _$HarmonicPacketDtoCopyWithImpl<$Res>
    implements $HarmonicPacketDtoCopyWith<$Res> {
  _$HarmonicPacketDtoCopyWithImpl(this._self, this._then);

  final HarmonicPacketDto _self;
  final $Res Function(HarmonicPacketDto) _then;

/// Create a copy of HarmonicPacketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? durationMs = null,Object? isOneShot = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,isOneShot: null == isOneShot ? _self.isOneShot : isOneShot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HarmonicPacketDto].
extension HarmonicPacketDtoPatterns on HarmonicPacketDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarmonicPacketDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarmonicPacketDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarmonicPacketDto value)  $default,){
final _that = this;
switch (_that) {
case _HarmonicPacketDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarmonicPacketDto value)?  $default,){
final _that = this;
switch (_that) {
case _HarmonicPacketDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int value,  int durationMs,  bool isOneShot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarmonicPacketDto() when $default != null:
return $default(_that.value,_that.durationMs,_that.isOneShot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int value,  int durationMs,  bool isOneShot)  $default,) {final _that = this;
switch (_that) {
case _HarmonicPacketDto():
return $default(_that.value,_that.durationMs,_that.isOneShot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int value,  int durationMs,  bool isOneShot)?  $default,) {final _that = this;
switch (_that) {
case _HarmonicPacketDto() when $default != null:
return $default(_that.value,_that.durationMs,_that.isOneShot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarmonicPacketDto implements HarmonicPacketDto {
  const _HarmonicPacketDto({required this.value, required this.durationMs, required this.isOneShot});
  factory _HarmonicPacketDto.fromJson(Map<String, dynamic> json) => _$HarmonicPacketDtoFromJson(json);

/// The harmonic value for this packet.
@override final  int value;
/// Duration in milliseconds.
@override final  int durationMs;
/// Whether this packet harmonizes only once (in the first cycle).
@override final  bool isOneShot;

/// Create a copy of HarmonicPacketDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarmonicPacketDtoCopyWith<_HarmonicPacketDto> get copyWith => __$HarmonicPacketDtoCopyWithImpl<_HarmonicPacketDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarmonicPacketDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarmonicPacketDto&&(identical(other.value, value) || other.value == value)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.isOneShot, isOneShot) || other.isOneShot == isOneShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,durationMs,isOneShot);

@override
String toString() {
  return 'HarmonicPacketDto(value: $value, durationMs: $durationMs, isOneShot: $isOneShot)';
}


}

/// @nodoc
abstract mixin class _$HarmonicPacketDtoCopyWith<$Res> implements $HarmonicPacketDtoCopyWith<$Res> {
  factory _$HarmonicPacketDtoCopyWith(_HarmonicPacketDto value, $Res Function(_HarmonicPacketDto) _then) = __$HarmonicPacketDtoCopyWithImpl;
@override @useResult
$Res call({
 int value, int durationMs, bool isOneShot
});




}
/// @nodoc
class __$HarmonicPacketDtoCopyWithImpl<$Res>
    implements _$HarmonicPacketDtoCopyWith<$Res> {
  __$HarmonicPacketDtoCopyWithImpl(this._self, this._then);

  final _HarmonicPacketDto _self;
  final $Res Function(_HarmonicPacketDto) _then;

/// Create a copy of HarmonicPacketDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? durationMs = null,Object? isOneShot = null,}) {
  return _then(_HarmonicPacketDto(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,isOneShot: null == isOneShot ? _self.isOneShot : isOneShot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
