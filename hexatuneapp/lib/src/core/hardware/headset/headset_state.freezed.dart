// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'headset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeadsetState {

 bool get wiredConnected; bool get wirelessConnected;
/// Create a copy of HeadsetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadsetStateCopyWith<HeadsetState> get copyWith => _$HeadsetStateCopyWithImpl<HeadsetState>(this as HeadsetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadsetState&&(identical(other.wiredConnected, wiredConnected) || other.wiredConnected == wiredConnected)&&(identical(other.wirelessConnected, wirelessConnected) || other.wirelessConnected == wirelessConnected));
}


@override
int get hashCode => Object.hash(runtimeType,wiredConnected,wirelessConnected);

@override
String toString() {
  return 'HeadsetState(wiredConnected: $wiredConnected, wirelessConnected: $wirelessConnected)';
}


}

/// @nodoc
abstract mixin class $HeadsetStateCopyWith<$Res>  {
  factory $HeadsetStateCopyWith(HeadsetState value, $Res Function(HeadsetState) _then) = _$HeadsetStateCopyWithImpl;
@useResult
$Res call({
 bool wiredConnected, bool wirelessConnected
});




}
/// @nodoc
class _$HeadsetStateCopyWithImpl<$Res>
    implements $HeadsetStateCopyWith<$Res> {
  _$HeadsetStateCopyWithImpl(this._self, this._then);

  final HeadsetState _self;
  final $Res Function(HeadsetState) _then;

/// Create a copy of HeadsetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wiredConnected = null,Object? wirelessConnected = null,}) {
  return _then(_self.copyWith(
wiredConnected: null == wiredConnected ? _self.wiredConnected : wiredConnected // ignore: cast_nullable_to_non_nullable
as bool,wirelessConnected: null == wirelessConnected ? _self.wirelessConnected : wirelessConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadsetState].
extension HeadsetStatePatterns on HeadsetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadsetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadsetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadsetState value)  $default,){
final _that = this;
switch (_that) {
case _HeadsetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadsetState value)?  $default,){
final _that = this;
switch (_that) {
case _HeadsetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool wiredConnected,  bool wirelessConnected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadsetState() when $default != null:
return $default(_that.wiredConnected,_that.wirelessConnected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool wiredConnected,  bool wirelessConnected)  $default,) {final _that = this;
switch (_that) {
case _HeadsetState():
return $default(_that.wiredConnected,_that.wirelessConnected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool wiredConnected,  bool wirelessConnected)?  $default,) {final _that = this;
switch (_that) {
case _HeadsetState() when $default != null:
return $default(_that.wiredConnected,_that.wirelessConnected);case _:
  return null;

}
}

}

/// @nodoc


class _HeadsetState extends HeadsetState {
  const _HeadsetState({this.wiredConnected = false, this.wirelessConnected = false}): super._();
  

@override@JsonKey() final  bool wiredConnected;
@override@JsonKey() final  bool wirelessConnected;

/// Create a copy of HeadsetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadsetStateCopyWith<_HeadsetState> get copyWith => __$HeadsetStateCopyWithImpl<_HeadsetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadsetState&&(identical(other.wiredConnected, wiredConnected) || other.wiredConnected == wiredConnected)&&(identical(other.wirelessConnected, wirelessConnected) || other.wirelessConnected == wirelessConnected));
}


@override
int get hashCode => Object.hash(runtimeType,wiredConnected,wirelessConnected);

@override
String toString() {
  return 'HeadsetState(wiredConnected: $wiredConnected, wirelessConnected: $wirelessConnected)';
}


}

/// @nodoc
abstract mixin class _$HeadsetStateCopyWith<$Res> implements $HeadsetStateCopyWith<$Res> {
  factory _$HeadsetStateCopyWith(_HeadsetState value, $Res Function(_HeadsetState) _then) = __$HeadsetStateCopyWithImpl;
@override @useResult
$Res call({
 bool wiredConnected, bool wirelessConnected
});




}
/// @nodoc
class __$HeadsetStateCopyWithImpl<$Res>
    implements _$HeadsetStateCopyWith<$Res> {
  __$HeadsetStateCopyWithImpl(this._self, this._then);

  final _HeadsetState _self;
  final $Res Function(_HeadsetState) _then;

/// Create a copy of HeadsetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wiredConnected = null,Object? wirelessConnected = null,}) {
  return _then(_HeadsetState(
wiredConnected: null == wiredConnected ? _self.wiredConnected : wiredConnected // ignore: cast_nullable_to_non_nullable
as bool,wirelessConnected: null == wirelessConnected ? _self.wirelessConnected : wirelessConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
