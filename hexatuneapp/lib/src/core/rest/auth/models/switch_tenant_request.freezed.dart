// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'switch_tenant_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwitchTenantRequest {

 String get tenantId;
/// Create a copy of SwitchTenantRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchTenantRequestCopyWith<SwitchTenantRequest> get copyWith => _$SwitchTenantRequestCopyWithImpl<SwitchTenantRequest>(this as SwitchTenantRequest, _$identity);

  /// Serializes this SwitchTenantRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchTenantRequest&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tenantId);

@override
String toString() {
  return 'SwitchTenantRequest(tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class $SwitchTenantRequestCopyWith<$Res>  {
  factory $SwitchTenantRequestCopyWith(SwitchTenantRequest value, $Res Function(SwitchTenantRequest) _then) = _$SwitchTenantRequestCopyWithImpl;
@useResult
$Res call({
 String tenantId
});




}
/// @nodoc
class _$SwitchTenantRequestCopyWithImpl<$Res>
    implements $SwitchTenantRequestCopyWith<$Res> {
  _$SwitchTenantRequestCopyWithImpl(this._self, this._then);

  final SwitchTenantRequest _self;
  final $Res Function(SwitchTenantRequest) _then;

/// Create a copy of SwitchTenantRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tenantId = null,}) {
  return _then(_self.copyWith(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SwitchTenantRequest].
extension SwitchTenantRequestPatterns on SwitchTenantRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwitchTenantRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwitchTenantRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwitchTenantRequest value)  $default,){
final _that = this;
switch (_that) {
case _SwitchTenantRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwitchTenantRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SwitchTenantRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tenantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwitchTenantRequest() when $default != null:
return $default(_that.tenantId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tenantId)  $default,) {final _that = this;
switch (_that) {
case _SwitchTenantRequest():
return $default(_that.tenantId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tenantId)?  $default,) {final _that = this;
switch (_that) {
case _SwitchTenantRequest() when $default != null:
return $default(_that.tenantId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwitchTenantRequest implements SwitchTenantRequest {
  const _SwitchTenantRequest({required this.tenantId});
  factory _SwitchTenantRequest.fromJson(Map<String, dynamic> json) => _$SwitchTenantRequestFromJson(json);

@override final  String tenantId;

/// Create a copy of SwitchTenantRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchTenantRequestCopyWith<_SwitchTenantRequest> get copyWith => __$SwitchTenantRequestCopyWithImpl<_SwitchTenantRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwitchTenantRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchTenantRequest&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tenantId);

@override
String toString() {
  return 'SwitchTenantRequest(tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class _$SwitchTenantRequestCopyWith<$Res> implements $SwitchTenantRequestCopyWith<$Res> {
  factory _$SwitchTenantRequestCopyWith(_SwitchTenantRequest value, $Res Function(_SwitchTenantRequest) _then) = __$SwitchTenantRequestCopyWithImpl;
@override @useResult
$Res call({
 String tenantId
});




}
/// @nodoc
class __$SwitchTenantRequestCopyWithImpl<$Res>
    implements _$SwitchTenantRequestCopyWith<$Res> {
  __$SwitchTenantRequestCopyWithImpl(this._self, this._then);

  final _SwitchTenantRequest _self;
  final $Res Function(_SwitchTenantRequest) _then;

/// Create a copy of SwitchTenantRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tenantId = null,}) {
  return _then(_SwitchTenantRequest(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
