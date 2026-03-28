// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CycleStep {

/// Frequency offset in Hz from the carrier frequency.
 double get frequencyDelta;/// Duration of this step in seconds.
 double get durationSeconds;/// If true, this step runs only in the first cycle iteration.
 bool get oneshot;
/// Create a copy of CycleStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleStepCopyWith<CycleStep> get copyWith => _$CycleStepCopyWithImpl<CycleStep>(this as CycleStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleStep&&(identical(other.frequencyDelta, frequencyDelta) || other.frequencyDelta == frequencyDelta)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.oneshot, oneshot) || other.oneshot == oneshot));
}


@override
int get hashCode => Object.hash(runtimeType,frequencyDelta,durationSeconds,oneshot);

@override
String toString() {
  return 'CycleStep(frequencyDelta: $frequencyDelta, durationSeconds: $durationSeconds, oneshot: $oneshot)';
}


}

/// @nodoc
abstract mixin class $CycleStepCopyWith<$Res>  {
  factory $CycleStepCopyWith(CycleStep value, $Res Function(CycleStep) _then) = _$CycleStepCopyWithImpl;
@useResult
$Res call({
 double frequencyDelta, double durationSeconds, bool oneshot
});




}
/// @nodoc
class _$CycleStepCopyWithImpl<$Res>
    implements $CycleStepCopyWith<$Res> {
  _$CycleStepCopyWithImpl(this._self, this._then);

  final CycleStep _self;
  final $Res Function(CycleStep) _then;

/// Create a copy of CycleStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frequencyDelta = null,Object? durationSeconds = null,Object? oneshot = null,}) {
  return _then(_self.copyWith(
frequencyDelta: null == frequencyDelta ? _self.frequencyDelta : frequencyDelta // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,oneshot: null == oneshot ? _self.oneshot : oneshot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleStep].
extension CycleStepPatterns on CycleStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleStep value)  $default,){
final _that = this;
switch (_that) {
case _CycleStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleStep value)?  $default,){
final _that = this;
switch (_that) {
case _CycleStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double frequencyDelta,  double durationSeconds,  bool oneshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleStep() when $default != null:
return $default(_that.frequencyDelta,_that.durationSeconds,_that.oneshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double frequencyDelta,  double durationSeconds,  bool oneshot)  $default,) {final _that = this;
switch (_that) {
case _CycleStep():
return $default(_that.frequencyDelta,_that.durationSeconds,_that.oneshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double frequencyDelta,  double durationSeconds,  bool oneshot)?  $default,) {final _that = this;
switch (_that) {
case _CycleStep() when $default != null:
return $default(_that.frequencyDelta,_that.durationSeconds,_that.oneshot);case _:
  return null;

}
}

}

/// @nodoc


class _CycleStep implements CycleStep {
  const _CycleStep({required this.frequencyDelta, required this.durationSeconds, this.oneshot = false});
  

/// Frequency offset in Hz from the carrier frequency.
@override final  double frequencyDelta;
/// Duration of this step in seconds.
@override final  double durationSeconds;
/// If true, this step runs only in the first cycle iteration.
@override@JsonKey() final  bool oneshot;

/// Create a copy of CycleStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleStepCopyWith<_CycleStep> get copyWith => __$CycleStepCopyWithImpl<_CycleStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleStep&&(identical(other.frequencyDelta, frequencyDelta) || other.frequencyDelta == frequencyDelta)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.oneshot, oneshot) || other.oneshot == oneshot));
}


@override
int get hashCode => Object.hash(runtimeType,frequencyDelta,durationSeconds,oneshot);

@override
String toString() {
  return 'CycleStep(frequencyDelta: $frequencyDelta, durationSeconds: $durationSeconds, oneshot: $oneshot)';
}


}

/// @nodoc
abstract mixin class _$CycleStepCopyWith<$Res> implements $CycleStepCopyWith<$Res> {
  factory _$CycleStepCopyWith(_CycleStep value, $Res Function(_CycleStep) _then) = __$CycleStepCopyWithImpl;
@override @useResult
$Res call({
 double frequencyDelta, double durationSeconds, bool oneshot
});




}
/// @nodoc
class __$CycleStepCopyWithImpl<$Res>
    implements _$CycleStepCopyWith<$Res> {
  __$CycleStepCopyWithImpl(this._self, this._then);

  final _CycleStep _self;
  final $Res Function(_CycleStep) _then;

/// Create a copy of CycleStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frequencyDelta = null,Object? durationSeconds = null,Object? oneshot = null,}) {
  return _then(_CycleStep(
frequencyDelta: null == frequencyDelta ? _self.frequencyDelta : frequencyDelta // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,oneshot: null == oneshot ? _self.oneshot : oneshot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
