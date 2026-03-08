// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oauth_login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OAuthLoginResponse {

 String get accessToken; String get refreshToken; String get sessionId; String get accountId; String get expiresAt; bool get isNewAccount;
/// Create a copy of OAuthLoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OAuthLoginResponseCopyWith<OAuthLoginResponse> get copyWith => _$OAuthLoginResponseCopyWithImpl<OAuthLoginResponse>(this as OAuthLoginResponse, _$identity);

  /// Serializes this OAuthLoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OAuthLoginResponse&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isNewAccount, isNewAccount) || other.isNewAccount == isNewAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,sessionId,accountId,expiresAt,isNewAccount);

@override
String toString() {
  return 'OAuthLoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, sessionId: $sessionId, accountId: $accountId, expiresAt: $expiresAt, isNewAccount: $isNewAccount)';
}


}

/// @nodoc
abstract mixin class $OAuthLoginResponseCopyWith<$Res>  {
  factory $OAuthLoginResponseCopyWith(OAuthLoginResponse value, $Res Function(OAuthLoginResponse) _then) = _$OAuthLoginResponseCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String sessionId, String accountId, String expiresAt, bool isNewAccount
});




}
/// @nodoc
class _$OAuthLoginResponseCopyWithImpl<$Res>
    implements $OAuthLoginResponseCopyWith<$Res> {
  _$OAuthLoginResponseCopyWithImpl(this._self, this._then);

  final OAuthLoginResponse _self;
  final $Res Function(OAuthLoginResponse) _then;

/// Create a copy of OAuthLoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? sessionId = null,Object? accountId = null,Object? expiresAt = null,Object? isNewAccount = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isNewAccount: null == isNewAccount ? _self.isNewAccount : isNewAccount // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OAuthLoginResponse].
extension OAuthLoginResponsePatterns on OAuthLoginResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OAuthLoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OAuthLoginResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OAuthLoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _OAuthLoginResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OAuthLoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OAuthLoginResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String sessionId,  String accountId,  String expiresAt,  bool isNewAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OAuthLoginResponse() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.sessionId,_that.accountId,_that.expiresAt,_that.isNewAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String sessionId,  String accountId,  String expiresAt,  bool isNewAccount)  $default,) {final _that = this;
switch (_that) {
case _OAuthLoginResponse():
return $default(_that.accessToken,_that.refreshToken,_that.sessionId,_that.accountId,_that.expiresAt,_that.isNewAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  String sessionId,  String accountId,  String expiresAt,  bool isNewAccount)?  $default,) {final _that = this;
switch (_that) {
case _OAuthLoginResponse() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.sessionId,_that.accountId,_that.expiresAt,_that.isNewAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OAuthLoginResponse implements OAuthLoginResponse {
  const _OAuthLoginResponse({required this.accessToken, required this.refreshToken, required this.sessionId, required this.accountId, required this.expiresAt, required this.isNewAccount});
  factory _OAuthLoginResponse.fromJson(Map<String, dynamic> json) => _$OAuthLoginResponseFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  String sessionId;
@override final  String accountId;
@override final  String expiresAt;
@override final  bool isNewAccount;

/// Create a copy of OAuthLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OAuthLoginResponseCopyWith<_OAuthLoginResponse> get copyWith => __$OAuthLoginResponseCopyWithImpl<_OAuthLoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OAuthLoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OAuthLoginResponse&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isNewAccount, isNewAccount) || other.isNewAccount == isNewAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,sessionId,accountId,expiresAt,isNewAccount);

@override
String toString() {
  return 'OAuthLoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, sessionId: $sessionId, accountId: $accountId, expiresAt: $expiresAt, isNewAccount: $isNewAccount)';
}


}

/// @nodoc
abstract mixin class _$OAuthLoginResponseCopyWith<$Res> implements $OAuthLoginResponseCopyWith<$Res> {
  factory _$OAuthLoginResponseCopyWith(_OAuthLoginResponse value, $Res Function(_OAuthLoginResponse) _then) = __$OAuthLoginResponseCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, String sessionId, String accountId, String expiresAt, bool isNewAccount
});




}
/// @nodoc
class __$OAuthLoginResponseCopyWithImpl<$Res>
    implements _$OAuthLoginResponseCopyWith<$Res> {
  __$OAuthLoginResponseCopyWithImpl(this._self, this._then);

  final _OAuthLoginResponse _self;
  final $Res Function(_OAuthLoginResponse) _then;

/// Create a copy of OAuthLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? sessionId = null,Object? accountId = null,Object? expiresAt = null,Object? isNewAccount = null,}) {
  return _then(_OAuthLoginResponse(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isNewAccount: null == isNewAccount ? _self.isNewAccount : isNewAccount // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
