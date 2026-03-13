// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_push_token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterPushTokenRequest {

 String get token; String get platform; String get appId;
/// Create a copy of RegisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPushTokenRequestCopyWith<RegisterPushTokenRequest> get copyWith => _$RegisterPushTokenRequestCopyWithImpl<RegisterPushTokenRequest>(this as RegisterPushTokenRequest, _$identity);

  /// Serializes this RegisterPushTokenRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPushTokenRequest&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appId, appId) || other.appId == appId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,appId);

@override
String toString() {
  return 'RegisterPushTokenRequest(token: $token, platform: $platform, appId: $appId)';
}


}

/// @nodoc
abstract mixin class $RegisterPushTokenRequestCopyWith<$Res>  {
  factory $RegisterPushTokenRequestCopyWith(RegisterPushTokenRequest value, $Res Function(RegisterPushTokenRequest) _then) = _$RegisterPushTokenRequestCopyWithImpl;
@useResult
$Res call({
 String token, String platform, String appId
});




}
/// @nodoc
class _$RegisterPushTokenRequestCopyWithImpl<$Res>
    implements $RegisterPushTokenRequestCopyWith<$Res> {
  _$RegisterPushTokenRequestCopyWithImpl(this._self, this._then);

  final RegisterPushTokenRequest _self;
  final $Res Function(RegisterPushTokenRequest) _then;

/// Create a copy of RegisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? platform = null,Object? appId = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterPushTokenRequest].
extension RegisterPushTokenRequestPatterns on RegisterPushTokenRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterPushTokenRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterPushTokenRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterPushTokenRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterPushTokenRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterPushTokenRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterPushTokenRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String platform,  String appId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterPushTokenRequest() when $default != null:
return $default(_that.token,_that.platform,_that.appId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String platform,  String appId)  $default,) {final _that = this;
switch (_that) {
case _RegisterPushTokenRequest():
return $default(_that.token,_that.platform,_that.appId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String platform,  String appId)?  $default,) {final _that = this;
switch (_that) {
case _RegisterPushTokenRequest() when $default != null:
return $default(_that.token,_that.platform,_that.appId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterPushTokenRequest implements RegisterPushTokenRequest {
  const _RegisterPushTokenRequest({required this.token, required this.platform, required this.appId});
  factory _RegisterPushTokenRequest.fromJson(Map<String, dynamic> json) => _$RegisterPushTokenRequestFromJson(json);

@override final  String token;
@override final  String platform;
@override final  String appId;

/// Create a copy of RegisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterPushTokenRequestCopyWith<_RegisterPushTokenRequest> get copyWith => __$RegisterPushTokenRequestCopyWithImpl<_RegisterPushTokenRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterPushTokenRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterPushTokenRequest&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appId, appId) || other.appId == appId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,appId);

@override
String toString() {
  return 'RegisterPushTokenRequest(token: $token, platform: $platform, appId: $appId)';
}


}

/// @nodoc
abstract mixin class _$RegisterPushTokenRequestCopyWith<$Res> implements $RegisterPushTokenRequestCopyWith<$Res> {
  factory _$RegisterPushTokenRequestCopyWith(_RegisterPushTokenRequest value, $Res Function(_RegisterPushTokenRequest) _then) = __$RegisterPushTokenRequestCopyWithImpl;
@override @useResult
$Res call({
 String token, String platform, String appId
});




}
/// @nodoc
class __$RegisterPushTokenRequestCopyWithImpl<$Res>
    implements _$RegisterPushTokenRequestCopyWith<$Res> {
  __$RegisterPushTokenRequestCopyWithImpl(this._self, this._then);

  final _RegisterPushTokenRequest _self;
  final $Res Function(_RegisterPushTokenRequest) _then;

/// Create a copy of RegisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? platform = null,Object? appId = null,}) {
  return _then(_RegisterPushTokenRequest(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
