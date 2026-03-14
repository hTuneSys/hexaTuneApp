// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apple_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppleAuthRequest {

 String get idToken; String? get authorizationCode; String? get deviceId;
/// Create a copy of AppleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppleAuthRequestCopyWith<AppleAuthRequest> get copyWith => _$AppleAuthRequestCopyWithImpl<AppleAuthRequest>(this as AppleAuthRequest, _$identity);

  /// Serializes this AppleAuthRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppleAuthRequest&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.authorizationCode, authorizationCode) || other.authorizationCode == authorizationCode)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,authorizationCode,deviceId);

@override
String toString() {
  return 'AppleAuthRequest(idToken: $idToken, authorizationCode: $authorizationCode, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $AppleAuthRequestCopyWith<$Res>  {
  factory $AppleAuthRequestCopyWith(AppleAuthRequest value, $Res Function(AppleAuthRequest) _then) = _$AppleAuthRequestCopyWithImpl;
@useResult
$Res call({
 String idToken, String? authorizationCode, String? deviceId
});




}
/// @nodoc
class _$AppleAuthRequestCopyWithImpl<$Res>
    implements $AppleAuthRequestCopyWith<$Res> {
  _$AppleAuthRequestCopyWithImpl(this._self, this._then);

  final AppleAuthRequest _self;
  final $Res Function(AppleAuthRequest) _then;

/// Create a copy of AppleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,Object? authorizationCode = freezed,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,authorizationCode: freezed == authorizationCode ? _self.authorizationCode : authorizationCode // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppleAuthRequest].
extension AppleAuthRequestPatterns on AppleAuthRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppleAuthRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppleAuthRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppleAuthRequest value)  $default,){
final _that = this;
switch (_that) {
case _AppleAuthRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppleAuthRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AppleAuthRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken,  String? authorizationCode,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppleAuthRequest() when $default != null:
return $default(_that.idToken,_that.authorizationCode,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken,  String? authorizationCode,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _AppleAuthRequest():
return $default(_that.idToken,_that.authorizationCode,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken,  String? authorizationCode,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _AppleAuthRequest() when $default != null:
return $default(_that.idToken,_that.authorizationCode,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppleAuthRequest implements AppleAuthRequest {
  const _AppleAuthRequest({required this.idToken, this.authorizationCode, this.deviceId});
  factory _AppleAuthRequest.fromJson(Map<String, dynamic> json) => _$AppleAuthRequestFromJson(json);

@override final  String idToken;
@override final  String? authorizationCode;
@override final  String? deviceId;

/// Create a copy of AppleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppleAuthRequestCopyWith<_AppleAuthRequest> get copyWith => __$AppleAuthRequestCopyWithImpl<_AppleAuthRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppleAuthRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppleAuthRequest&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.authorizationCode, authorizationCode) || other.authorizationCode == authorizationCode)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,authorizationCode,deviceId);

@override
String toString() {
  return 'AppleAuthRequest(idToken: $idToken, authorizationCode: $authorizationCode, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$AppleAuthRequestCopyWith<$Res> implements $AppleAuthRequestCopyWith<$Res> {
  factory _$AppleAuthRequestCopyWith(_AppleAuthRequest value, $Res Function(_AppleAuthRequest) _then) = __$AppleAuthRequestCopyWithImpl;
@override @useResult
$Res call({
 String idToken, String? authorizationCode, String? deviceId
});




}
/// @nodoc
class __$AppleAuthRequestCopyWithImpl<$Res>
    implements _$AppleAuthRequestCopyWith<$Res> {
  __$AppleAuthRequestCopyWithImpl(this._self, this._then);

  final _AppleAuthRequest _self;
  final $Res Function(_AppleAuthRequest) _then;

/// Create a copy of AppleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,Object? authorizationCode = freezed,Object? deviceId = freezed,}) {
  return _then(_AppleAuthRequest(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,authorizationCode: freezed == authorizationCode ? _self.authorizationCode : authorizationCode // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
