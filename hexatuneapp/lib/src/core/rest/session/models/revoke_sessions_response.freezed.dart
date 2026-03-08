// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revoke_sessions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevokeSessionsResponse {

 int get revokedCount;
/// Create a copy of RevokeSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevokeSessionsResponseCopyWith<RevokeSessionsResponse> get copyWith => _$RevokeSessionsResponseCopyWithImpl<RevokeSessionsResponse>(this as RevokeSessionsResponse, _$identity);

  /// Serializes this RevokeSessionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevokeSessionsResponse&&(identical(other.revokedCount, revokedCount) || other.revokedCount == revokedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revokedCount);

@override
String toString() {
  return 'RevokeSessionsResponse(revokedCount: $revokedCount)';
}


}

/// @nodoc
abstract mixin class $RevokeSessionsResponseCopyWith<$Res>  {
  factory $RevokeSessionsResponseCopyWith(RevokeSessionsResponse value, $Res Function(RevokeSessionsResponse) _then) = _$RevokeSessionsResponseCopyWithImpl;
@useResult
$Res call({
 int revokedCount
});




}
/// @nodoc
class _$RevokeSessionsResponseCopyWithImpl<$Res>
    implements $RevokeSessionsResponseCopyWith<$Res> {
  _$RevokeSessionsResponseCopyWithImpl(this._self, this._then);

  final RevokeSessionsResponse _self;
  final $Res Function(RevokeSessionsResponse) _then;

/// Create a copy of RevokeSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revokedCount = null,}) {
  return _then(_self.copyWith(
revokedCount: null == revokedCount ? _self.revokedCount : revokedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevokeSessionsResponse].
extension RevokeSessionsResponsePatterns on RevokeSessionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevokeSessionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevokeSessionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevokeSessionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _RevokeSessionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevokeSessionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RevokeSessionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int revokedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevokeSessionsResponse() when $default != null:
return $default(_that.revokedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int revokedCount)  $default,) {final _that = this;
switch (_that) {
case _RevokeSessionsResponse():
return $default(_that.revokedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int revokedCount)?  $default,) {final _that = this;
switch (_that) {
case _RevokeSessionsResponse() when $default != null:
return $default(_that.revokedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevokeSessionsResponse implements RevokeSessionsResponse {
  const _RevokeSessionsResponse({required this.revokedCount});
  factory _RevokeSessionsResponse.fromJson(Map<String, dynamic> json) => _$RevokeSessionsResponseFromJson(json);

@override final  int revokedCount;

/// Create a copy of RevokeSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevokeSessionsResponseCopyWith<_RevokeSessionsResponse> get copyWith => __$RevokeSessionsResponseCopyWithImpl<_RevokeSessionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevokeSessionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevokeSessionsResponse&&(identical(other.revokedCount, revokedCount) || other.revokedCount == revokedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revokedCount);

@override
String toString() {
  return 'RevokeSessionsResponse(revokedCount: $revokedCount)';
}


}

/// @nodoc
abstract mixin class _$RevokeSessionsResponseCopyWith<$Res> implements $RevokeSessionsResponseCopyWith<$Res> {
  factory _$RevokeSessionsResponseCopyWith(_RevokeSessionsResponse value, $Res Function(_RevokeSessionsResponse) _then) = __$RevokeSessionsResponseCopyWithImpl;
@override @useResult
$Res call({
 int revokedCount
});




}
/// @nodoc
class __$RevokeSessionsResponseCopyWithImpl<$Res>
    implements _$RevokeSessionsResponseCopyWith<$Res> {
  __$RevokeSessionsResponseCopyWithImpl(this._self, this._then);

  final _RevokeSessionsResponse _self;
  final $Res Function(_RevokeSessionsResponse) _then;

/// Create a copy of RevokeSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revokedCount = null,}) {
  return _then(_RevokeSessionsResponse(
revokedCount: null == revokedCount ? _self.revokedCount : revokedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
