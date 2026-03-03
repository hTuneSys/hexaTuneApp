// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 're_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReAuthRequest {

 String get password;
/// Create a copy of ReAuthRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReAuthRequestCopyWith<ReAuthRequest> get copyWith => _$ReAuthRequestCopyWithImpl<ReAuthRequest>(this as ReAuthRequest, _$identity);

  /// Serializes this ReAuthRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReAuthRequest&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'ReAuthRequest(password: $password)';
}


}

/// @nodoc
abstract mixin class $ReAuthRequestCopyWith<$Res>  {
  factory $ReAuthRequestCopyWith(ReAuthRequest value, $Res Function(ReAuthRequest) _then) = _$ReAuthRequestCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$ReAuthRequestCopyWithImpl<$Res>
    implements $ReAuthRequestCopyWith<$Res> {
  _$ReAuthRequestCopyWithImpl(this._self, this._then);

  final ReAuthRequest _self;
  final $Res Function(ReAuthRequest) _then;

/// Create a copy of ReAuthRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,}) {
  return _then(_self.copyWith(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReAuthRequest].
extension ReAuthRequestPatterns on ReAuthRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReAuthRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReAuthRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReAuthRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReAuthRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReAuthRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReAuthRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReAuthRequest() when $default != null:
return $default(_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password)  $default,) {final _that = this;
switch (_that) {
case _ReAuthRequest():
return $default(_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password)?  $default,) {final _that = this;
switch (_that) {
case _ReAuthRequest() when $default != null:
return $default(_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReAuthRequest implements ReAuthRequest {
  const _ReAuthRequest({required this.password});
  factory _ReAuthRequest.fromJson(Map<String, dynamic> json) => _$ReAuthRequestFromJson(json);

@override final  String password;

/// Create a copy of ReAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReAuthRequestCopyWith<_ReAuthRequest> get copyWith => __$ReAuthRequestCopyWithImpl<_ReAuthRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReAuthRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReAuthRequest&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'ReAuthRequest(password: $password)';
}


}

/// @nodoc
abstract mixin class _$ReAuthRequestCopyWith<$Res> implements $ReAuthRequestCopyWith<$Res> {
  factory _$ReAuthRequestCopyWith(_ReAuthRequest value, $Res Function(_ReAuthRequest) _then) = __$ReAuthRequestCopyWithImpl;
@override @useResult
$Res call({
 String password
});




}
/// @nodoc
class __$ReAuthRequestCopyWithImpl<$Res>
    implements _$ReAuthRequestCopyWith<$Res> {
  __$ReAuthRequestCopyWithImpl(this._self, this._then);

  final _ReAuthRequest _self;
  final $Res Function(_ReAuthRequest) _then;

/// Create a copy of ReAuthRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_ReAuthRequest(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
