// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_membership_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TenantMembershipResponse {

 String get id; String get tenantId; String get role; String get status; bool get isOwner; String? get joinedAt;
/// Create a copy of TenantMembershipResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantMembershipResponseCopyWith<TenantMembershipResponse> get copyWith => _$TenantMembershipResponseCopyWithImpl<TenantMembershipResponse>(this as TenantMembershipResponse, _$identity);

  /// Serializes this TenantMembershipResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantMembershipResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,role,status,isOwner,joinedAt);

@override
String toString() {
  return 'TenantMembershipResponse(id: $id, tenantId: $tenantId, role: $role, status: $status, isOwner: $isOwner, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $TenantMembershipResponseCopyWith<$Res>  {
  factory $TenantMembershipResponseCopyWith(TenantMembershipResponse value, $Res Function(TenantMembershipResponse) _then) = _$TenantMembershipResponseCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String role, String status, bool isOwner, String? joinedAt
});




}
/// @nodoc
class _$TenantMembershipResponseCopyWithImpl<$Res>
    implements $TenantMembershipResponseCopyWith<$Res> {
  _$TenantMembershipResponseCopyWithImpl(this._self, this._then);

  final TenantMembershipResponse _self;
  final $Res Function(TenantMembershipResponse) _then;

/// Create a copy of TenantMembershipResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? role = null,Object? status = null,Object? isOwner = null,Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TenantMembershipResponse].
extension TenantMembershipResponsePatterns on TenantMembershipResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TenantMembershipResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TenantMembershipResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TenantMembershipResponse value)  $default,){
final _that = this;
switch (_that) {
case _TenantMembershipResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TenantMembershipResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TenantMembershipResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String role,  String status,  bool isOwner,  String? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TenantMembershipResponse() when $default != null:
return $default(_that.id,_that.tenantId,_that.role,_that.status,_that.isOwner,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String role,  String status,  bool isOwner,  String? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _TenantMembershipResponse():
return $default(_that.id,_that.tenantId,_that.role,_that.status,_that.isOwner,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String role,  String status,  bool isOwner,  String? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _TenantMembershipResponse() when $default != null:
return $default(_that.id,_that.tenantId,_that.role,_that.status,_that.isOwner,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TenantMembershipResponse implements TenantMembershipResponse {
  const _TenantMembershipResponse({required this.id, required this.tenantId, required this.role, required this.status, required this.isOwner, this.joinedAt});
  factory _TenantMembershipResponse.fromJson(Map<String, dynamic> json) => _$TenantMembershipResponseFromJson(json);

@override final  String id;
@override final  String tenantId;
@override final  String role;
@override final  String status;
@override final  bool isOwner;
@override final  String? joinedAt;

/// Create a copy of TenantMembershipResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TenantMembershipResponseCopyWith<_TenantMembershipResponse> get copyWith => __$TenantMembershipResponseCopyWithImpl<_TenantMembershipResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TenantMembershipResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TenantMembershipResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,role,status,isOwner,joinedAt);

@override
String toString() {
  return 'TenantMembershipResponse(id: $id, tenantId: $tenantId, role: $role, status: $status, isOwner: $isOwner, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$TenantMembershipResponseCopyWith<$Res> implements $TenantMembershipResponseCopyWith<$Res> {
  factory _$TenantMembershipResponseCopyWith(_TenantMembershipResponse value, $Res Function(_TenantMembershipResponse) _then) = __$TenantMembershipResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String role, String status, bool isOwner, String? joinedAt
});




}
/// @nodoc
class __$TenantMembershipResponseCopyWithImpl<$Res>
    implements _$TenantMembershipResponseCopyWith<$Res> {
  __$TenantMembershipResponseCopyWithImpl(this._self, this._then);

  final _TenantMembershipResponse _self;
  final $Res Function(_TenantMembershipResponse) _then;

/// Create a copy of TenantMembershipResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? role = null,Object? status = null,Object? isOwner = null,Object? joinedAt = freezed,}) {
  return _then(_TenantMembershipResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
