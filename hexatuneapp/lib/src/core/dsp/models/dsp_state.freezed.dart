// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dsp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DspState {

/// Whether the DSP engine has been initialized.
 bool get isInitialized;/// Whether audio is currently playing.
 bool get isRendering;/// Whether a base layer has been loaded.
 bool get isBaseLoaded;/// Fixed carrier frequency in Hz (220 Hz, not configurable).
 double get carrierFrequency;/// Whether binaural mode is enabled (vs AM mono).
 bool get binauralEnabled;/// Current base gain (0.0–1.0).
 double get baseGain;/// Current texture gain (0.0–1.0).
 double get textureGain;/// Current event gain (0.0–1.0).
 double get eventGain;/// Current binaural gain (0.0–1.0).
 double get binauralGain;/// Current master gain (0.0–1.0).
 double get masterGain;/// Error message if initialization or playback failed.
 String? get error;
/// Create a copy of DspState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DspStateCopyWith<DspState> get copyWith => _$DspStateCopyWithImpl<DspState>(this as DspState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DspState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.isRendering, isRendering) || other.isRendering == isRendering)&&(identical(other.isBaseLoaded, isBaseLoaded) || other.isBaseLoaded == isBaseLoaded)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.binauralEnabled, binauralEnabled) || other.binauralEnabled == binauralEnabled)&&(identical(other.baseGain, baseGain) || other.baseGain == baseGain)&&(identical(other.textureGain, textureGain) || other.textureGain == textureGain)&&(identical(other.eventGain, eventGain) || other.eventGain == eventGain)&&(identical(other.binauralGain, binauralGain) || other.binauralGain == binauralGain)&&(identical(other.masterGain, masterGain) || other.masterGain == masterGain)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,isRendering,isBaseLoaded,carrierFrequency,binauralEnabled,baseGain,textureGain,eventGain,binauralGain,masterGain,error);

@override
String toString() {
  return 'DspState(isInitialized: $isInitialized, isRendering: $isRendering, isBaseLoaded: $isBaseLoaded, carrierFrequency: $carrierFrequency, binauralEnabled: $binauralEnabled, baseGain: $baseGain, textureGain: $textureGain, eventGain: $eventGain, binauralGain: $binauralGain, masterGain: $masterGain, error: $error)';
}


}

/// @nodoc
abstract mixin class $DspStateCopyWith<$Res>  {
  factory $DspStateCopyWith(DspState value, $Res Function(DspState) _then) = _$DspStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialized, bool isRendering, bool isBaseLoaded, double carrierFrequency, bool binauralEnabled, double baseGain, double textureGain, double eventGain, double binauralGain, double masterGain, String? error
});




}
/// @nodoc
class _$DspStateCopyWithImpl<$Res>
    implements $DspStateCopyWith<$Res> {
  _$DspStateCopyWithImpl(this._self, this._then);

  final DspState _self;
  final $Res Function(DspState) _then;

/// Create a copy of DspState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialized = null,Object? isRendering = null,Object? isBaseLoaded = null,Object? carrierFrequency = null,Object? binauralEnabled = null,Object? baseGain = null,Object? textureGain = null,Object? eventGain = null,Object? binauralGain = null,Object? masterGain = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,isRendering: null == isRendering ? _self.isRendering : isRendering // ignore: cast_nullable_to_non_nullable
as bool,isBaseLoaded: null == isBaseLoaded ? _self.isBaseLoaded : isBaseLoaded // ignore: cast_nullable_to_non_nullable
as bool,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,binauralEnabled: null == binauralEnabled ? _self.binauralEnabled : binauralEnabled // ignore: cast_nullable_to_non_nullable
as bool,baseGain: null == baseGain ? _self.baseGain : baseGain // ignore: cast_nullable_to_non_nullable
as double,textureGain: null == textureGain ? _self.textureGain : textureGain // ignore: cast_nullable_to_non_nullable
as double,eventGain: null == eventGain ? _self.eventGain : eventGain // ignore: cast_nullable_to_non_nullable
as double,binauralGain: null == binauralGain ? _self.binauralGain : binauralGain // ignore: cast_nullable_to_non_nullable
as double,masterGain: null == masterGain ? _self.masterGain : masterGain // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DspState].
extension DspStatePatterns on DspState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DspState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DspState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DspState value)  $default,){
final _that = this;
switch (_that) {
case _DspState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DspState value)?  $default,){
final _that = this;
switch (_that) {
case _DspState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isInitialized,  bool isRendering,  bool isBaseLoaded,  double carrierFrequency,  bool binauralEnabled,  double baseGain,  double textureGain,  double eventGain,  double binauralGain,  double masterGain,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DspState() when $default != null:
return $default(_that.isInitialized,_that.isRendering,_that.isBaseLoaded,_that.carrierFrequency,_that.binauralEnabled,_that.baseGain,_that.textureGain,_that.eventGain,_that.binauralGain,_that.masterGain,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isInitialized,  bool isRendering,  bool isBaseLoaded,  double carrierFrequency,  bool binauralEnabled,  double baseGain,  double textureGain,  double eventGain,  double binauralGain,  double masterGain,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DspState():
return $default(_that.isInitialized,_that.isRendering,_that.isBaseLoaded,_that.carrierFrequency,_that.binauralEnabled,_that.baseGain,_that.textureGain,_that.eventGain,_that.binauralGain,_that.masterGain,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isInitialized,  bool isRendering,  bool isBaseLoaded,  double carrierFrequency,  bool binauralEnabled,  double baseGain,  double textureGain,  double eventGain,  double binauralGain,  double masterGain,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DspState() when $default != null:
return $default(_that.isInitialized,_that.isRendering,_that.isBaseLoaded,_that.carrierFrequency,_that.binauralEnabled,_that.baseGain,_that.textureGain,_that.eventGain,_that.binauralGain,_that.masterGain,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DspState extends DspState {
  const _DspState({this.isInitialized = false, this.isRendering = false, this.isBaseLoaded = false, this.carrierFrequency = 220.0, this.binauralEnabled = true, this.baseGain = 0.6, this.textureGain = 0.3, this.eventGain = 0.4, this.binauralGain = 0.15, this.masterGain = 1.0, this.error}): super._();
  

/// Whether the DSP engine has been initialized.
@override@JsonKey() final  bool isInitialized;
/// Whether audio is currently playing.
@override@JsonKey() final  bool isRendering;
/// Whether a base layer has been loaded.
@override@JsonKey() final  bool isBaseLoaded;
/// Fixed carrier frequency in Hz (220 Hz, not configurable).
@override@JsonKey() final  double carrierFrequency;
/// Whether binaural mode is enabled (vs AM mono).
@override@JsonKey() final  bool binauralEnabled;
/// Current base gain (0.0–1.0).
@override@JsonKey() final  double baseGain;
/// Current texture gain (0.0–1.0).
@override@JsonKey() final  double textureGain;
/// Current event gain (0.0–1.0).
@override@JsonKey() final  double eventGain;
/// Current binaural gain (0.0–1.0).
@override@JsonKey() final  double binauralGain;
/// Current master gain (0.0–1.0).
@override@JsonKey() final  double masterGain;
/// Error message if initialization or playback failed.
@override final  String? error;

/// Create a copy of DspState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DspStateCopyWith<_DspState> get copyWith => __$DspStateCopyWithImpl<_DspState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DspState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.isRendering, isRendering) || other.isRendering == isRendering)&&(identical(other.isBaseLoaded, isBaseLoaded) || other.isBaseLoaded == isBaseLoaded)&&(identical(other.carrierFrequency, carrierFrequency) || other.carrierFrequency == carrierFrequency)&&(identical(other.binauralEnabled, binauralEnabled) || other.binauralEnabled == binauralEnabled)&&(identical(other.baseGain, baseGain) || other.baseGain == baseGain)&&(identical(other.textureGain, textureGain) || other.textureGain == textureGain)&&(identical(other.eventGain, eventGain) || other.eventGain == eventGain)&&(identical(other.binauralGain, binauralGain) || other.binauralGain == binauralGain)&&(identical(other.masterGain, masterGain) || other.masterGain == masterGain)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,isRendering,isBaseLoaded,carrierFrequency,binauralEnabled,baseGain,textureGain,eventGain,binauralGain,masterGain,error);

@override
String toString() {
  return 'DspState(isInitialized: $isInitialized, isRendering: $isRendering, isBaseLoaded: $isBaseLoaded, carrierFrequency: $carrierFrequency, binauralEnabled: $binauralEnabled, baseGain: $baseGain, textureGain: $textureGain, eventGain: $eventGain, binauralGain: $binauralGain, masterGain: $masterGain, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DspStateCopyWith<$Res> implements $DspStateCopyWith<$Res> {
  factory _$DspStateCopyWith(_DspState value, $Res Function(_DspState) _then) = __$DspStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialized, bool isRendering, bool isBaseLoaded, double carrierFrequency, bool binauralEnabled, double baseGain, double textureGain, double eventGain, double binauralGain, double masterGain, String? error
});




}
/// @nodoc
class __$DspStateCopyWithImpl<$Res>
    implements _$DspStateCopyWith<$Res> {
  __$DspStateCopyWithImpl(this._self, this._then);

  final _DspState _self;
  final $Res Function(_DspState) _then;

/// Create a copy of DspState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialized = null,Object? isRendering = null,Object? isBaseLoaded = null,Object? carrierFrequency = null,Object? binauralEnabled = null,Object? baseGain = null,Object? textureGain = null,Object? eventGain = null,Object? binauralGain = null,Object? masterGain = null,Object? error = freezed,}) {
  return _then(_DspState(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,isRendering: null == isRendering ? _self.isRendering : isRendering // ignore: cast_nullable_to_non_nullable
as bool,isBaseLoaded: null == isBaseLoaded ? _self.isBaseLoaded : isBaseLoaded // ignore: cast_nullable_to_non_nullable
as bool,carrierFrequency: null == carrierFrequency ? _self.carrierFrequency : carrierFrequency // ignore: cast_nullable_to_non_nullable
as double,binauralEnabled: null == binauralEnabled ? _self.binauralEnabled : binauralEnabled // ignore: cast_nullable_to_non_nullable
as bool,baseGain: null == baseGain ? _self.baseGain : baseGain // ignore: cast_nullable_to_non_nullable
as double,textureGain: null == textureGain ? _self.textureGain : textureGain // ignore: cast_nullable_to_non_nullable
as double,eventGain: null == eventGain ? _self.eventGain : eventGain // ignore: cast_nullable_to_non_nullable
as double,binauralGain: null == binauralGain ? _self.binauralGain : binauralGain // ignore: cast_nullable_to_non_nullable
as double,masterGain: null == masterGain ? _self.masterGain : masterGain // ignore: cast_nullable_to_non_nullable
as double,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
