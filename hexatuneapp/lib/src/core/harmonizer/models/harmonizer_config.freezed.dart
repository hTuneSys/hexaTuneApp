// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harmonizer_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HarmonizerConfig {

/// The generation type to use.
 GenerationType get type;/// Optional ambience config ID (monaural / binaural only).
 String? get ambienceId;/// The harmonic packet sequence to harmonize (from API response).
 List<HarmonicPacketDto> get steps;/// The formula ID that generated this sequence (for UI state restoration).
 String? get formulaId;
/// Create a copy of HarmonizerConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarmonizerConfigCopyWith<HarmonizerConfig> get copyWith => _$HarmonizerConfigCopyWithImpl<HarmonizerConfig>(this as HarmonizerConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarmonizerConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.formulaId, formulaId) || other.formulaId == formulaId));
}


@override
int get hashCode => Object.hash(runtimeType,type,ambienceId,const DeepCollectionEquality().hash(steps),formulaId);

@override
String toString() {
  return 'HarmonizerConfig(type: $type, ambienceId: $ambienceId, steps: $steps, formulaId: $formulaId)';
}


}

/// @nodoc
abstract mixin class $HarmonizerConfigCopyWith<$Res>  {
  factory $HarmonizerConfigCopyWith(HarmonizerConfig value, $Res Function(HarmonizerConfig) _then) = _$HarmonizerConfigCopyWithImpl;
@useResult
$Res call({
 GenerationType type, String? ambienceId, List<HarmonicPacketDto> steps, String? formulaId
});




}
/// @nodoc
class _$HarmonizerConfigCopyWithImpl<$Res>
    implements $HarmonizerConfigCopyWith<$Res> {
  _$HarmonizerConfigCopyWithImpl(this._self, this._then);

  final HarmonizerConfig _self;
  final $Res Function(HarmonizerConfig) _then;

/// Create a copy of HarmonizerConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? ambienceId = freezed,Object? steps = null,Object? formulaId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GenerationType,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<HarmonicPacketDto>,formulaId: freezed == formulaId ? _self.formulaId : formulaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HarmonizerConfig].
extension HarmonizerConfigPatterns on HarmonizerConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarmonizerConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarmonizerConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarmonizerConfig value)  $default,){
final _that = this;
switch (_that) {
case _HarmonizerConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarmonizerConfig value)?  $default,){
final _that = this;
switch (_that) {
case _HarmonizerConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GenerationType type,  String? ambienceId,  List<HarmonicPacketDto> steps,  String? formulaId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarmonizerConfig() when $default != null:
return $default(_that.type,_that.ambienceId,_that.steps,_that.formulaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GenerationType type,  String? ambienceId,  List<HarmonicPacketDto> steps,  String? formulaId)  $default,) {final _that = this;
switch (_that) {
case _HarmonizerConfig():
return $default(_that.type,_that.ambienceId,_that.steps,_that.formulaId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GenerationType type,  String? ambienceId,  List<HarmonicPacketDto> steps,  String? formulaId)?  $default,) {final _that = this;
switch (_that) {
case _HarmonizerConfig() when $default != null:
return $default(_that.type,_that.ambienceId,_that.steps,_that.formulaId);case _:
  return null;

}
}

}

/// @nodoc


class _HarmonizerConfig implements HarmonizerConfig {
  const _HarmonizerConfig({required this.type, this.ambienceId, required final  List<HarmonicPacketDto> steps, this.formulaId}): _steps = steps;
  

/// The generation type to use.
@override final  GenerationType type;
/// Optional ambience config ID (monaural / binaural only).
@override final  String? ambienceId;
/// The harmonic packet sequence to harmonize (from API response).
 final  List<HarmonicPacketDto> _steps;
/// The harmonic packet sequence to harmonize (from API response).
@override List<HarmonicPacketDto> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

/// The formula ID that generated this sequence (for UI state restoration).
@override final  String? formulaId;

/// Create a copy of HarmonizerConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarmonizerConfigCopyWith<_HarmonizerConfig> get copyWith => __$HarmonizerConfigCopyWithImpl<_HarmonizerConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarmonizerConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.formulaId, formulaId) || other.formulaId == formulaId));
}


@override
int get hashCode => Object.hash(runtimeType,type,ambienceId,const DeepCollectionEquality().hash(_steps),formulaId);

@override
String toString() {
  return 'HarmonizerConfig(type: $type, ambienceId: $ambienceId, steps: $steps, formulaId: $formulaId)';
}


}

/// @nodoc
abstract mixin class _$HarmonizerConfigCopyWith<$Res> implements $HarmonizerConfigCopyWith<$Res> {
  factory _$HarmonizerConfigCopyWith(_HarmonizerConfig value, $Res Function(_HarmonizerConfig) _then) = __$HarmonizerConfigCopyWithImpl;
@override @useResult
$Res call({
 GenerationType type, String? ambienceId, List<HarmonicPacketDto> steps, String? formulaId
});




}
/// @nodoc
class __$HarmonizerConfigCopyWithImpl<$Res>
    implements _$HarmonizerConfigCopyWith<$Res> {
  __$HarmonizerConfigCopyWithImpl(this._self, this._then);

  final _HarmonizerConfig _self;
  final $Res Function(_HarmonizerConfig) _then;

/// Create a copy of HarmonizerConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? ambienceId = freezed,Object? steps = null,Object? formulaId = freezed,}) {
  return _then(_HarmonizerConfig(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GenerationType,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<HarmonicPacketDto>,formulaId: freezed == formulaId ? _self.formulaId : formulaId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
