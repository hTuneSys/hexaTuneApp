// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hexagen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HexagenState {

 bool get isConnected; bool get isInitialized; String? get deviceId; String? get deviceName; String? get firmwareVersion;
/// Create a copy of HexagenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HexagenStateCopyWith<HexagenState> get copyWith => _$HexagenStateCopyWithImpl<HexagenState>(this as HexagenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HexagenState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,isInitialized,deviceId,deviceName,firmwareVersion);

@override
String toString() {
  return 'HexagenState(isConnected: $isConnected, isInitialized: $isInitialized, deviceId: $deviceId, deviceName: $deviceName, firmwareVersion: $firmwareVersion)';
}


}

/// @nodoc
abstract mixin class $HexagenStateCopyWith<$Res>  {
  factory $HexagenStateCopyWith(HexagenState value, $Res Function(HexagenState) _then) = _$HexagenStateCopyWithImpl;
@useResult
$Res call({
 bool isConnected, bool isInitialized, String? deviceId, String? deviceName, String? firmwareVersion
});




}
/// @nodoc
class _$HexagenStateCopyWithImpl<$Res>
    implements $HexagenStateCopyWith<$Res> {
  _$HexagenStateCopyWithImpl(this._self, this._then);

  final HexagenState _self;
  final $Res Function(HexagenState) _then;

/// Create a copy of HexagenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? isInitialized = null,Object? deviceId = freezed,Object? deviceName = freezed,Object? firmwareVersion = freezed,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,firmwareVersion: freezed == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HexagenState].
extension HexagenStatePatterns on HexagenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HexagenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HexagenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HexagenState value)  $default,){
final _that = this;
switch (_that) {
case _HexagenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HexagenState value)?  $default,){
final _that = this;
switch (_that) {
case _HexagenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  bool isInitialized,  String? deviceId,  String? deviceName,  String? firmwareVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HexagenState() when $default != null:
return $default(_that.isConnected,_that.isInitialized,_that.deviceId,_that.deviceName,_that.firmwareVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  bool isInitialized,  String? deviceId,  String? deviceName,  String? firmwareVersion)  $default,) {final _that = this;
switch (_that) {
case _HexagenState():
return $default(_that.isConnected,_that.isInitialized,_that.deviceId,_that.deviceName,_that.firmwareVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  bool isInitialized,  String? deviceId,  String? deviceName,  String? firmwareVersion)?  $default,) {final _that = this;
switch (_that) {
case _HexagenState() when $default != null:
return $default(_that.isConnected,_that.isInitialized,_that.deviceId,_that.deviceName,_that.firmwareVersion);case _:
  return null;

}
}

}

/// @nodoc


class _HexagenState extends HexagenState {
  const _HexagenState({this.isConnected = false, this.isInitialized = false, this.deviceId, this.deviceName, this.firmwareVersion}): super._();
  

@override@JsonKey() final  bool isConnected;
@override@JsonKey() final  bool isInitialized;
@override final  String? deviceId;
@override final  String? deviceName;
@override final  String? firmwareVersion;

/// Create a copy of HexagenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HexagenStateCopyWith<_HexagenState> get copyWith => __$HexagenStateCopyWithImpl<_HexagenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HexagenState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,isInitialized,deviceId,deviceName,firmwareVersion);

@override
String toString() {
  return 'HexagenState(isConnected: $isConnected, isInitialized: $isInitialized, deviceId: $deviceId, deviceName: $deviceName, firmwareVersion: $firmwareVersion)';
}


}

/// @nodoc
abstract mixin class _$HexagenStateCopyWith<$Res> implements $HexagenStateCopyWith<$Res> {
  factory _$HexagenStateCopyWith(_HexagenState value, $Res Function(_HexagenState) _then) = __$HexagenStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, bool isInitialized, String? deviceId, String? deviceName, String? firmwareVersion
});




}
/// @nodoc
class __$HexagenStateCopyWithImpl<$Res>
    implements _$HexagenStateCopyWith<$Res> {
  __$HexagenStateCopyWithImpl(this._self, this._then);

  final _HexagenState _self;
  final $Res Function(_HexagenState) _then;

/// Create a copy of HexagenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? isInitialized = null,Object? deviceId = freezed,Object? deviceName = freezed,Object? firmwareVersion = freezed,}) {
  return _then(_HexagenState(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,firmwareVersion: freezed == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
