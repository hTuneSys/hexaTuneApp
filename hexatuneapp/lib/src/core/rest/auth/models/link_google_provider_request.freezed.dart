// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_google_provider_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkGoogleProviderRequest {

 String get idToken;
/// Create a copy of LinkGoogleProviderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkGoogleProviderRequestCopyWith<LinkGoogleProviderRequest> get copyWith => _$LinkGoogleProviderRequestCopyWithImpl<LinkGoogleProviderRequest>(this as LinkGoogleProviderRequest, _$identity);

  /// Serializes this LinkGoogleProviderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkGoogleProviderRequest&&(identical(other.idToken, idToken) || other.idToken == idToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken);

@override
String toString() {
  return 'LinkGoogleProviderRequest(idToken: $idToken)';
}


}

/// @nodoc
abstract mixin class $LinkGoogleProviderRequestCopyWith<$Res>  {
  factory $LinkGoogleProviderRequestCopyWith(LinkGoogleProviderRequest value, $Res Function(LinkGoogleProviderRequest) _then) = _$LinkGoogleProviderRequestCopyWithImpl;
@useResult
$Res call({
 String idToken
});




}
/// @nodoc
class _$LinkGoogleProviderRequestCopyWithImpl<$Res>
    implements $LinkGoogleProviderRequestCopyWith<$Res> {
  _$LinkGoogleProviderRequestCopyWithImpl(this._self, this._then);

  final LinkGoogleProviderRequest _self;
  final $Res Function(LinkGoogleProviderRequest) _then;

/// Create a copy of LinkGoogleProviderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,}) {
  return _then(_self.copyWith(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkGoogleProviderRequest].
extension LinkGoogleProviderRequestPatterns on LinkGoogleProviderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkGoogleProviderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkGoogleProviderRequest value)  $default,){
final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkGoogleProviderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest() when $default != null:
return $default(_that.idToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken)  $default,) {final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest():
return $default(_that.idToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken)?  $default,) {final _that = this;
switch (_that) {
case _LinkGoogleProviderRequest() when $default != null:
return $default(_that.idToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkGoogleProviderRequest implements LinkGoogleProviderRequest {
  const _LinkGoogleProviderRequest({required this.idToken});
  factory _LinkGoogleProviderRequest.fromJson(Map<String, dynamic> json) => _$LinkGoogleProviderRequestFromJson(json);

@override final  String idToken;

/// Create a copy of LinkGoogleProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkGoogleProviderRequestCopyWith<_LinkGoogleProviderRequest> get copyWith => __$LinkGoogleProviderRequestCopyWithImpl<_LinkGoogleProviderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkGoogleProviderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkGoogleProviderRequest&&(identical(other.idToken, idToken) || other.idToken == idToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken);

@override
String toString() {
  return 'LinkGoogleProviderRequest(idToken: $idToken)';
}


}

/// @nodoc
abstract mixin class _$LinkGoogleProviderRequestCopyWith<$Res> implements $LinkGoogleProviderRequestCopyWith<$Res> {
  factory _$LinkGoogleProviderRequestCopyWith(_LinkGoogleProviderRequest value, $Res Function(_LinkGoogleProviderRequest) _then) = __$LinkGoogleProviderRequestCopyWithImpl;
@override @useResult
$Res call({
 String idToken
});




}
/// @nodoc
class __$LinkGoogleProviderRequestCopyWithImpl<$Res>
    implements _$LinkGoogleProviderRequestCopyWith<$Res> {
  __$LinkGoogleProviderRequestCopyWithImpl(this._self, this._then);

  final _LinkGoogleProviderRequest _self;
  final $Res Function(_LinkGoogleProviderRequest) _then;

/// Create a copy of LinkGoogleProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,}) {
  return _then(_LinkGoogleProviderRequest(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
