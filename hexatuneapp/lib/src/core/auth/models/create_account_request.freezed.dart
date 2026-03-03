// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_account_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateAccountRequest {

 String get email; String get password;
/// Create a copy of CreateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAccountRequestCopyWith<CreateAccountRequest> get copyWith => _$CreateAccountRequestCopyWithImpl<CreateAccountRequest>(this as CreateAccountRequest, _$identity);

  /// Serializes this CreateAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAccountRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'CreateAccountRequest(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $CreateAccountRequestCopyWith<$Res>  {
  factory $CreateAccountRequestCopyWith(CreateAccountRequest value, $Res Function(CreateAccountRequest) _then) = _$CreateAccountRequestCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$CreateAccountRequestCopyWithImpl<$Res>
    implements $CreateAccountRequestCopyWith<$Res> {
  _$CreateAccountRequestCopyWithImpl(this._self, this._then);

  final CreateAccountRequest _self;
  final $Res Function(CreateAccountRequest) _then;

/// Create a copy of CreateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAccountRequest].
extension CreateAccountRequestPatterns on CreateAccountRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAccountRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAccountRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAccountRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAccountRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAccountRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAccountRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAccountRequest() when $default != null:
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _CreateAccountRequest():
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _CreateAccountRequest() when $default != null:
return $default(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAccountRequest implements CreateAccountRequest {
  const _CreateAccountRequest({required this.email, required this.password});
  factory _CreateAccountRequest.fromJson(Map<String, dynamic> json) => _$CreateAccountRequestFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of CreateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAccountRequestCopyWith<_CreateAccountRequest> get copyWith => __$CreateAccountRequestCopyWithImpl<_CreateAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAccountRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'CreateAccountRequest(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$CreateAccountRequestCopyWith<$Res> implements $CreateAccountRequestCopyWith<$Res> {
  factory _$CreateAccountRequestCopyWith(_CreateAccountRequest value, $Res Function(_CreateAccountRequest) _then) = __$CreateAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$CreateAccountRequestCopyWithImpl<$Res>
    implements _$CreateAccountRequestCopyWith<$Res> {
  __$CreateAccountRequestCopyWithImpl(this._self, this._then);

  final _CreateAccountRequest _self;
  final $Res Function(_CreateAccountRequest) _then;

/// Create a copy of CreateAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_CreateAccountRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
