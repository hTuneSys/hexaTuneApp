// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unregister_push_token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnregisterPushTokenRequest {

 String get appId;
/// Create a copy of UnregisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnregisterPushTokenRequestCopyWith<UnregisterPushTokenRequest> get copyWith => _$UnregisterPushTokenRequestCopyWithImpl<UnregisterPushTokenRequest>(this as UnregisterPushTokenRequest, _$identity);

  /// Serializes this UnregisterPushTokenRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnregisterPushTokenRequest&&(identical(other.appId, appId) || other.appId == appId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appId);

@override
String toString() {
  return 'UnregisterPushTokenRequest(appId: $appId)';
}


}

/// @nodoc
abstract mixin class $UnregisterPushTokenRequestCopyWith<$Res>  {
  factory $UnregisterPushTokenRequestCopyWith(UnregisterPushTokenRequest value, $Res Function(UnregisterPushTokenRequest) _then) = _$UnregisterPushTokenRequestCopyWithImpl;
@useResult
$Res call({
 String appId
});




}
/// @nodoc
class _$UnregisterPushTokenRequestCopyWithImpl<$Res>
    implements $UnregisterPushTokenRequestCopyWith<$Res> {
  _$UnregisterPushTokenRequestCopyWithImpl(this._self, this._then);

  final UnregisterPushTokenRequest _self;
  final $Res Function(UnregisterPushTokenRequest) _then;

/// Create a copy of UnregisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,}) {
  return _then(_self.copyWith(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnregisterPushTokenRequest].
extension UnregisterPushTokenRequestPatterns on UnregisterPushTokenRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnregisterPushTokenRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnregisterPushTokenRequest value)  $default,){
final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnregisterPushTokenRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest() when $default != null:
return $default(_that.appId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appId)  $default,) {final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest():
return $default(_that.appId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appId)?  $default,) {final _that = this;
switch (_that) {
case _UnregisterPushTokenRequest() when $default != null:
return $default(_that.appId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnregisterPushTokenRequest implements UnregisterPushTokenRequest {
  const _UnregisterPushTokenRequest({required this.appId});
  factory _UnregisterPushTokenRequest.fromJson(Map<String, dynamic> json) => _$UnregisterPushTokenRequestFromJson(json);

@override final  String appId;

/// Create a copy of UnregisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnregisterPushTokenRequestCopyWith<_UnregisterPushTokenRequest> get copyWith => __$UnregisterPushTokenRequestCopyWithImpl<_UnregisterPushTokenRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnregisterPushTokenRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnregisterPushTokenRequest&&(identical(other.appId, appId) || other.appId == appId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appId);

@override
String toString() {
  return 'UnregisterPushTokenRequest(appId: $appId)';
}


}

/// @nodoc
abstract mixin class _$UnregisterPushTokenRequestCopyWith<$Res> implements $UnregisterPushTokenRequestCopyWith<$Res> {
  factory _$UnregisterPushTokenRequestCopyWith(_UnregisterPushTokenRequest value, $Res Function(_UnregisterPushTokenRequest) _then) = __$UnregisterPushTokenRequestCopyWithImpl;
@override @useResult
$Res call({
 String appId
});




}
/// @nodoc
class __$UnregisterPushTokenRequestCopyWithImpl<$Res>
    implements _$UnregisterPushTokenRequestCopyWith<$Res> {
  __$UnregisterPushTokenRequestCopyWithImpl(this._self, this._then);

  final _UnregisterPushTokenRequest _self;
  final $Res Function(_UnregisterPushTokenRequest) _then;

/// Create a copy of UnregisterPushTokenRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,}) {
  return _then(_UnregisterPushTokenRequest(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
