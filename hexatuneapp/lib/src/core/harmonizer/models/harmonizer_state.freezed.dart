// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harmonizer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HarmonizerState {

/// The generation type currently active (null when idle).
 GenerationType? get activeType;/// Current status of the harmonizer.
 HarmonizerStatus get status;/// The ambience config ID loaded for this session (monaural/binaural).
 String? get ambienceId;/// The frequency step sequence from the API.
 List<HarmonicPacketDto> get sequence;/// Current infinite-loop cycle number (0-based).
 int get currentCycle;/// Index of the step currently playing within the cycle.
 int get currentStepIndex;/// Total duration of one full cycle (excluding one-shot after first).
 Duration get totalCycleDuration;/// Duration of the very first cycle (includes one-shots).
 Duration get firstCycleDuration;/// Time remaining in the current cycle (countdown).
 Duration get remainingInCycle;/// Whether we are in the first cycle (one-shots still active).
 bool get isFirstCycle;/// Human-readable error message when status is [HarmonizerStatus.error].
 String? get errorMessage;/// True after a graceful stop has been requested.
 bool get gracefulStopRequested;
/// Create a copy of HarmonizerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarmonizerStateCopyWith<HarmonizerState> get copyWith => _$HarmonizerStateCopyWithImpl<HarmonizerState>(this as HarmonizerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarmonizerState&&(identical(other.activeType, activeType) || other.activeType == activeType)&&(identical(other.status, status) || other.status == status)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&const DeepCollectionEquality().equals(other.sequence, sequence)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.totalCycleDuration, totalCycleDuration) || other.totalCycleDuration == totalCycleDuration)&&(identical(other.firstCycleDuration, firstCycleDuration) || other.firstCycleDuration == firstCycleDuration)&&(identical(other.remainingInCycle, remainingInCycle) || other.remainingInCycle == remainingInCycle)&&(identical(other.isFirstCycle, isFirstCycle) || other.isFirstCycle == isFirstCycle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.gracefulStopRequested, gracefulStopRequested) || other.gracefulStopRequested == gracefulStopRequested));
}


@override
int get hashCode => Object.hash(runtimeType,activeType,status,ambienceId,const DeepCollectionEquality().hash(sequence),currentCycle,currentStepIndex,totalCycleDuration,firstCycleDuration,remainingInCycle,isFirstCycle,errorMessage,gracefulStopRequested);

@override
String toString() {
  return 'HarmonizerState(activeType: $activeType, status: $status, ambienceId: $ambienceId, sequence: $sequence, currentCycle: $currentCycle, currentStepIndex: $currentStepIndex, totalCycleDuration: $totalCycleDuration, firstCycleDuration: $firstCycleDuration, remainingInCycle: $remainingInCycle, isFirstCycle: $isFirstCycle, errorMessage: $errorMessage, gracefulStopRequested: $gracefulStopRequested)';
}


}

/// @nodoc
abstract mixin class $HarmonizerStateCopyWith<$Res>  {
  factory $HarmonizerStateCopyWith(HarmonizerState value, $Res Function(HarmonizerState) _then) = _$HarmonizerStateCopyWithImpl;
@useResult
$Res call({
 GenerationType? activeType, HarmonizerStatus status, String? ambienceId, List<HarmonicPacketDto> sequence, int currentCycle, int currentStepIndex, Duration totalCycleDuration, Duration firstCycleDuration, Duration remainingInCycle, bool isFirstCycle, String? errorMessage, bool gracefulStopRequested
});




}
/// @nodoc
class _$HarmonizerStateCopyWithImpl<$Res>
    implements $HarmonizerStateCopyWith<$Res> {
  _$HarmonizerStateCopyWithImpl(this._self, this._then);

  final HarmonizerState _self;
  final $Res Function(HarmonizerState) _then;

/// Create a copy of HarmonizerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeType = freezed,Object? status = null,Object? ambienceId = freezed,Object? sequence = null,Object? currentCycle = null,Object? currentStepIndex = null,Object? totalCycleDuration = null,Object? firstCycleDuration = null,Object? remainingInCycle = null,Object? isFirstCycle = null,Object? errorMessage = freezed,Object? gracefulStopRequested = null,}) {
  return _then(_self.copyWith(
activeType: freezed == activeType ? _self.activeType : activeType // ignore: cast_nullable_to_non_nullable
as GenerationType?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HarmonizerStatus,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as List<HarmonicPacketDto>,currentCycle: null == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as int,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,totalCycleDuration: null == totalCycleDuration ? _self.totalCycleDuration : totalCycleDuration // ignore: cast_nullable_to_non_nullable
as Duration,firstCycleDuration: null == firstCycleDuration ? _self.firstCycleDuration : firstCycleDuration // ignore: cast_nullable_to_non_nullable
as Duration,remainingInCycle: null == remainingInCycle ? _self.remainingInCycle : remainingInCycle // ignore: cast_nullable_to_non_nullable
as Duration,isFirstCycle: null == isFirstCycle ? _self.isFirstCycle : isFirstCycle // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gracefulStopRequested: null == gracefulStopRequested ? _self.gracefulStopRequested : gracefulStopRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HarmonizerState].
extension HarmonizerStatePatterns on HarmonizerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarmonizerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarmonizerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarmonizerState value)  $default,){
final _that = this;
switch (_that) {
case _HarmonizerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarmonizerState value)?  $default,){
final _that = this;
switch (_that) {
case _HarmonizerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GenerationType? activeType,  HarmonizerStatus status,  String? ambienceId,  List<HarmonicPacketDto> sequence,  int currentCycle,  int currentStepIndex,  Duration totalCycleDuration,  Duration firstCycleDuration,  Duration remainingInCycle,  bool isFirstCycle,  String? errorMessage,  bool gracefulStopRequested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarmonizerState() when $default != null:
return $default(_that.activeType,_that.status,_that.ambienceId,_that.sequence,_that.currentCycle,_that.currentStepIndex,_that.totalCycleDuration,_that.firstCycleDuration,_that.remainingInCycle,_that.isFirstCycle,_that.errorMessage,_that.gracefulStopRequested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GenerationType? activeType,  HarmonizerStatus status,  String? ambienceId,  List<HarmonicPacketDto> sequence,  int currentCycle,  int currentStepIndex,  Duration totalCycleDuration,  Duration firstCycleDuration,  Duration remainingInCycle,  bool isFirstCycle,  String? errorMessage,  bool gracefulStopRequested)  $default,) {final _that = this;
switch (_that) {
case _HarmonizerState():
return $default(_that.activeType,_that.status,_that.ambienceId,_that.sequence,_that.currentCycle,_that.currentStepIndex,_that.totalCycleDuration,_that.firstCycleDuration,_that.remainingInCycle,_that.isFirstCycle,_that.errorMessage,_that.gracefulStopRequested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GenerationType? activeType,  HarmonizerStatus status,  String? ambienceId,  List<HarmonicPacketDto> sequence,  int currentCycle,  int currentStepIndex,  Duration totalCycleDuration,  Duration firstCycleDuration,  Duration remainingInCycle,  bool isFirstCycle,  String? errorMessage,  bool gracefulStopRequested)?  $default,) {final _that = this;
switch (_that) {
case _HarmonizerState() when $default != null:
return $default(_that.activeType,_that.status,_that.ambienceId,_that.sequence,_that.currentCycle,_that.currentStepIndex,_that.totalCycleDuration,_that.firstCycleDuration,_that.remainingInCycle,_that.isFirstCycle,_that.errorMessage,_that.gracefulStopRequested);case _:
  return null;

}
}

}

/// @nodoc


class _HarmonizerState implements HarmonizerState {
  const _HarmonizerState({this.activeType, this.status = HarmonizerStatus.idle, this.ambienceId, final  List<HarmonicPacketDto> sequence = const [], this.currentCycle = 0, this.currentStepIndex = 0, this.totalCycleDuration = Duration.zero, this.firstCycleDuration = Duration.zero, this.remainingInCycle = Duration.zero, this.isFirstCycle = true, this.errorMessage, this.gracefulStopRequested = false}): _sequence = sequence;
  

/// The generation type currently active (null when idle).
@override final  GenerationType? activeType;
/// Current status of the harmonizer.
@override@JsonKey() final  HarmonizerStatus status;
/// The ambience config ID loaded for this session (monaural/binaural).
@override final  String? ambienceId;
/// The frequency step sequence from the API.
 final  List<HarmonicPacketDto> _sequence;
/// The frequency step sequence from the API.
@override@JsonKey() List<HarmonicPacketDto> get sequence {
  if (_sequence is EqualUnmodifiableListView) return _sequence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sequence);
}

/// Current infinite-loop cycle number (0-based).
@override@JsonKey() final  int currentCycle;
/// Index of the step currently playing within the cycle.
@override@JsonKey() final  int currentStepIndex;
/// Total duration of one full cycle (excluding one-shot after first).
@override@JsonKey() final  Duration totalCycleDuration;
/// Duration of the very first cycle (includes one-shots).
@override@JsonKey() final  Duration firstCycleDuration;
/// Time remaining in the current cycle (countdown).
@override@JsonKey() final  Duration remainingInCycle;
/// Whether we are in the first cycle (one-shots still active).
@override@JsonKey() final  bool isFirstCycle;
/// Human-readable error message when status is [HarmonizerStatus.error].
@override final  String? errorMessage;
/// True after a graceful stop has been requested.
@override@JsonKey() final  bool gracefulStopRequested;

/// Create a copy of HarmonizerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarmonizerStateCopyWith<_HarmonizerState> get copyWith => __$HarmonizerStateCopyWithImpl<_HarmonizerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarmonizerState&&(identical(other.activeType, activeType) || other.activeType == activeType)&&(identical(other.status, status) || other.status == status)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&const DeepCollectionEquality().equals(other._sequence, _sequence)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.totalCycleDuration, totalCycleDuration) || other.totalCycleDuration == totalCycleDuration)&&(identical(other.firstCycleDuration, firstCycleDuration) || other.firstCycleDuration == firstCycleDuration)&&(identical(other.remainingInCycle, remainingInCycle) || other.remainingInCycle == remainingInCycle)&&(identical(other.isFirstCycle, isFirstCycle) || other.isFirstCycle == isFirstCycle)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.gracefulStopRequested, gracefulStopRequested) || other.gracefulStopRequested == gracefulStopRequested));
}


@override
int get hashCode => Object.hash(runtimeType,activeType,status,ambienceId,const DeepCollectionEquality().hash(_sequence),currentCycle,currentStepIndex,totalCycleDuration,firstCycleDuration,remainingInCycle,isFirstCycle,errorMessage,gracefulStopRequested);

@override
String toString() {
  return 'HarmonizerState(activeType: $activeType, status: $status, ambienceId: $ambienceId, sequence: $sequence, currentCycle: $currentCycle, currentStepIndex: $currentStepIndex, totalCycleDuration: $totalCycleDuration, firstCycleDuration: $firstCycleDuration, remainingInCycle: $remainingInCycle, isFirstCycle: $isFirstCycle, errorMessage: $errorMessage, gracefulStopRequested: $gracefulStopRequested)';
}


}

/// @nodoc
abstract mixin class _$HarmonizerStateCopyWith<$Res> implements $HarmonizerStateCopyWith<$Res> {
  factory _$HarmonizerStateCopyWith(_HarmonizerState value, $Res Function(_HarmonizerState) _then) = __$HarmonizerStateCopyWithImpl;
@override @useResult
$Res call({
 GenerationType? activeType, HarmonizerStatus status, String? ambienceId, List<HarmonicPacketDto> sequence, int currentCycle, int currentStepIndex, Duration totalCycleDuration, Duration firstCycleDuration, Duration remainingInCycle, bool isFirstCycle, String? errorMessage, bool gracefulStopRequested
});




}
/// @nodoc
class __$HarmonizerStateCopyWithImpl<$Res>
    implements _$HarmonizerStateCopyWith<$Res> {
  __$HarmonizerStateCopyWithImpl(this._self, this._then);

  final _HarmonizerState _self;
  final $Res Function(_HarmonizerState) _then;

/// Create a copy of HarmonizerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeType = freezed,Object? status = null,Object? ambienceId = freezed,Object? sequence = null,Object? currentCycle = null,Object? currentStepIndex = null,Object? totalCycleDuration = null,Object? firstCycleDuration = null,Object? remainingInCycle = null,Object? isFirstCycle = null,Object? errorMessage = freezed,Object? gracefulStopRequested = null,}) {
  return _then(_HarmonizerState(
activeType: freezed == activeType ? _self.activeType : activeType // ignore: cast_nullable_to_non_nullable
as GenerationType?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HarmonizerStatus,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,sequence: null == sequence ? _self._sequence : sequence // ignore: cast_nullable_to_non_nullable
as List<HarmonicPacketDto>,currentCycle: null == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as int,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,totalCycleDuration: null == totalCycleDuration ? _self.totalCycleDuration : totalCycleDuration // ignore: cast_nullable_to_non_nullable
as Duration,firstCycleDuration: null == firstCycleDuration ? _self.firstCycleDuration : firstCycleDuration // ignore: cast_nullable_to_non_nullable
as Duration,remainingInCycle: null == remainingInCycle ? _self.remainingInCycle : remainingInCycle // ignore: cast_nullable_to_non_nullable
as Duration,isFirstCycle: null == isFirstCycle ? _self.isFirstCycle : isFirstCycle // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gracefulStopRequested: null == gracefulStopRequested ? _self.gracefulStopRequested : gracefulStopRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
