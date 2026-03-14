// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoogleAuthRequest {

 String get idToken; String? get deviceId;
/// Create a copy of GoogleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoogleAuthRequestCopyWith<GoogleAuthRequest> get copyWith => _$GoogleAuthRequestCopyWithImpl<GoogleAuthRequest>(this as GoogleAuthRequest, _$identity);

  /// Serializes this GoogleAuthRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleAuthRequest&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,deviceId);

@override
String toString() {
  return 'GoogleAuthRequest(idToken: $idToken, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $GoogleAuthRequestCopyWith<$Res>  {
  factory $GoogleAuthRequestCopyWith(GoogleAuthRequest value, $Res Function(GoogleAuthRequest) _then) = _$GoogleAuthRequestCopyWithImpl;
@useResult
$Res call({
 String idToken, String? deviceId
});




}
/// @nodoc
class _$GoogleAuthRequestCopyWithImpl<$Res>
    implements $GoogleAuthRequestCopyWith<$Res> {
  _$GoogleAuthRequestCopyWithImpl(this._self, this._then);

  final GoogleAuthRequest _self;
  final $Res Function(GoogleAuthRequest) _then;

/// Create a copy of GoogleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoogleAuthRequest].
extension GoogleAuthRequestPatterns on GoogleAuthRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoogleAuthRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoogleAuthRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoogleAuthRequest value)  $default,){
final _that = this;
switch (_that) {
case _GoogleAuthRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoogleAuthRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GoogleAuthRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoogleAuthRequest() when $default != null:
return $default(_that.idToken,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _GoogleAuthRequest():
return $default(_that.idToken,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _GoogleAuthRequest() when $default != null:
return $default(_that.idToken,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoogleAuthRequest implements GoogleAuthRequest {
  const _GoogleAuthRequest({required this.idToken, this.deviceId});
  factory _GoogleAuthRequest.fromJson(Map<String, dynamic> json) => _$GoogleAuthRequestFromJson(json);

@override final  String idToken;
@override final  String? deviceId;

/// Create a copy of GoogleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoogleAuthRequestCopyWith<_GoogleAuthRequest> get copyWith => __$GoogleAuthRequestCopyWithImpl<_GoogleAuthRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoogleAuthRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleAuthRequest&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,deviceId);

@override
String toString() {
  return 'GoogleAuthRequest(idToken: $idToken, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$GoogleAuthRequestCopyWith<$Res> implements $GoogleAuthRequestCopyWith<$Res> {
  factory _$GoogleAuthRequestCopyWith(_GoogleAuthRequest value, $Res Function(_GoogleAuthRequest) _then) = __$GoogleAuthRequestCopyWithImpl;
@override @useResult
$Res call({
 String idToken, String? deviceId
});




}
/// @nodoc
class __$GoogleAuthRequestCopyWithImpl<$Res>
    implements _$GoogleAuthRequestCopyWith<$Res> {
  __$GoogleAuthRequestCopyWithImpl(this._self, this._then);

  final _GoogleAuthRequest _self;
  final $Res Function(_GoogleAuthRequest) _then;

/// Create a copy of GoogleAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,Object? deviceId = freezed,}) {
  return _then(_GoogleAuthRequest(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
