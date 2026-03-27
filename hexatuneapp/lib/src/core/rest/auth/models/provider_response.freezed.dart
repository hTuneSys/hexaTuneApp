// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderResponse {

 String get providerType; String get linkedAt; String? get email; bool? get emailVerified;
/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderResponseCopyWith<ProviderResponse> get copyWith => _$ProviderResponseCopyWithImpl<ProviderResponse>(this as ProviderResponse, _$identity);

  /// Serializes this ProviderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderResponse&&(identical(other.providerType, providerType) || other.providerType == providerType)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerType,linkedAt,email,emailVerified);

@override
String toString() {
  return 'ProviderResponse(providerType: $providerType, linkedAt: $linkedAt, email: $email, emailVerified: $emailVerified)';
}


}

/// @nodoc
abstract mixin class $ProviderResponseCopyWith<$Res>  {
  factory $ProviderResponseCopyWith(ProviderResponse value, $Res Function(ProviderResponse) _then) = _$ProviderResponseCopyWithImpl;
@useResult
$Res call({
 String providerType, String linkedAt, String? email, bool? emailVerified
});




}
/// @nodoc
class _$ProviderResponseCopyWithImpl<$Res>
    implements $ProviderResponseCopyWith<$Res> {
  _$ProviderResponseCopyWithImpl(this._self, this._then);

  final ProviderResponse _self;
  final $Res Function(ProviderResponse) _then;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providerType = null,Object? linkedAt = null,Object? email = freezed,Object? emailVerified = freezed,}) {
  return _then(_self.copyWith(
providerType: null == providerType ? _self.providerType : providerType // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: freezed == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderResponse].
extension ProviderResponsePatterns on ProviderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProviderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String providerType,  String linkedAt,  String? email,  bool? emailVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
return $default(_that.providerType,_that.linkedAt,_that.email,_that.emailVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String providerType,  String linkedAt,  String? email,  bool? emailVerified)  $default,) {final _that = this;
switch (_that) {
case _ProviderResponse():
return $default(_that.providerType,_that.linkedAt,_that.email,_that.emailVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String providerType,  String linkedAt,  String? email,  bool? emailVerified)?  $default,) {final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
return $default(_that.providerType,_that.linkedAt,_that.email,_that.emailVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderResponse implements ProviderResponse {
  const _ProviderResponse({required this.providerType, required this.linkedAt, this.email, this.emailVerified});
  factory _ProviderResponse.fromJson(Map<String, dynamic> json) => _$ProviderResponseFromJson(json);

@override final  String providerType;
@override final  String linkedAt;
@override final  String? email;
@override final  bool? emailVerified;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderResponseCopyWith<_ProviderResponse> get copyWith => __$ProviderResponseCopyWithImpl<_ProviderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderResponse&&(identical(other.providerType, providerType) || other.providerType == providerType)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerType,linkedAt,email,emailVerified);

@override
String toString() {
  return 'ProviderResponse(providerType: $providerType, linkedAt: $linkedAt, email: $email, emailVerified: $emailVerified)';
}


}

/// @nodoc
abstract mixin class _$ProviderResponseCopyWith<$Res> implements $ProviderResponseCopyWith<$Res> {
  factory _$ProviderResponseCopyWith(_ProviderResponse value, $Res Function(_ProviderResponse) _then) = __$ProviderResponseCopyWithImpl;
@override @useResult
$Res call({
 String providerType, String linkedAt, String? email, bool? emailVerified
});




}
/// @nodoc
class __$ProviderResponseCopyWithImpl<$Res>
    implements _$ProviderResponseCopyWith<$Res> {
  __$ProviderResponseCopyWithImpl(this._self, this._then);

  final _ProviderResponse _self;
  final $Res Function(_ProviderResponse) _then;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providerType = null,Object? linkedAt = null,Object? email = freezed,Object? emailVerified = freezed,}) {
  return _then(_ProviderResponse(
providerType: null == providerType ? _self.providerType : providerType // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: freezed == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
