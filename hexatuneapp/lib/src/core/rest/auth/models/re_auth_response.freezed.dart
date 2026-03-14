// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 're_auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReAuthResponse {

 String get token; String get expiresAt;
/// Create a copy of ReAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReAuthResponseCopyWith<ReAuthResponse> get copyWith => _$ReAuthResponseCopyWithImpl<ReAuthResponse>(this as ReAuthResponse, _$identity);

  /// Serializes this ReAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReAuthResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'ReAuthResponse(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ReAuthResponseCopyWith<$Res>  {
  factory $ReAuthResponseCopyWith(ReAuthResponse value, $Res Function(ReAuthResponse) _then) = _$ReAuthResponseCopyWithImpl;
@useResult
$Res call({
 String token, String expiresAt
});




}
/// @nodoc
class _$ReAuthResponseCopyWithImpl<$Res>
    implements $ReAuthResponseCopyWith<$Res> {
  _$ReAuthResponseCopyWithImpl(this._self, this._then);

  final ReAuthResponse _self;
  final $Res Function(ReAuthResponse) _then;

/// Create a copy of ReAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReAuthResponse].
extension ReAuthResponsePatterns on ReAuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReAuthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReAuthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReAuthResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReAuthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReAuthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReAuthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReAuthResponse() when $default != null:
return $default(_that.token,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ReAuthResponse():
return $default(_that.token,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ReAuthResponse() when $default != null:
return $default(_that.token,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReAuthResponse implements ReAuthResponse {
  const _ReAuthResponse({required this.token, required this.expiresAt});
  factory _ReAuthResponse.fromJson(Map<String, dynamic> json) => _$ReAuthResponseFromJson(json);

@override final  String token;
@override final  String expiresAt;

/// Create a copy of ReAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReAuthResponseCopyWith<_ReAuthResponse> get copyWith => __$ReAuthResponseCopyWithImpl<_ReAuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReAuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReAuthResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,expiresAt);

@override
String toString() {
  return 'ReAuthResponse(token: $token, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ReAuthResponseCopyWith<$Res> implements $ReAuthResponseCopyWith<$Res> {
  factory _$ReAuthResponseCopyWith(_ReAuthResponse value, $Res Function(_ReAuthResponse) _then) = __$ReAuthResponseCopyWithImpl;
@override @useResult
$Res call({
 String token, String expiresAt
});




}
/// @nodoc
class __$ReAuthResponseCopyWithImpl<$Res>
    implements _$ReAuthResponseCopyWith<$Res> {
  __$ReAuthResponseCopyWithImpl(this._self, this._then);

  final _ReAuthResponse _self;
  final $Res Function(_ReAuthResponse) _then;

/// Create a copy of ReAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? expiresAt = null,}) {
  return _then(_ReAuthResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
