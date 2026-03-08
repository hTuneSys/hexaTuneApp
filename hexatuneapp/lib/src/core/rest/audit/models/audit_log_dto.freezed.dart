// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLogDto {

 String get id; String get tenantId; String get actorType; String? get actorId; String get action; String get resourceType; String? get resourceId; String get outcome; String get severity; String get traceId; bool get containsPii; String get occurredAt; String get createdAt;
/// Create a copy of AuditLogDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogDtoCopyWith<AuditLogDto> get copyWith => _$AuditLogDtoCopyWithImpl<AuditLogDto>(this as AuditLogDto, _$identity);

  /// Serializes this AuditLogDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.traceId, traceId) || other.traceId == traceId)&&(identical(other.containsPii, containsPii) || other.containsPii == containsPii)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,actorType,actorId,action,resourceType,resourceId,outcome,severity,traceId,containsPii,occurredAt,createdAt);

@override
String toString() {
  return 'AuditLogDto(id: $id, tenantId: $tenantId, actorType: $actorType, actorId: $actorId, action: $action, resourceType: $resourceType, resourceId: $resourceId, outcome: $outcome, severity: $severity, traceId: $traceId, containsPii: $containsPii, occurredAt: $occurredAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AuditLogDtoCopyWith<$Res>  {
  factory $AuditLogDtoCopyWith(AuditLogDto value, $Res Function(AuditLogDto) _then) = _$AuditLogDtoCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String actorType, String? actorId, String action, String resourceType, String? resourceId, String outcome, String severity, String traceId, bool containsPii, String occurredAt, String createdAt
});




}
/// @nodoc
class _$AuditLogDtoCopyWithImpl<$Res>
    implements $AuditLogDtoCopyWith<$Res> {
  _$AuditLogDtoCopyWithImpl(this._self, this._then);

  final AuditLogDto _self;
  final $Res Function(AuditLogDto) _then;

/// Create a copy of AuditLogDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? actorType = null,Object? actorId = freezed,Object? action = null,Object? resourceType = null,Object? resourceId = freezed,Object? outcome = null,Object? severity = null,Object? traceId = null,Object? containsPii = null,Object? occurredAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as String,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,containsPii: null == containsPii ? _self.containsPii : containsPii // ignore: cast_nullable_to_non_nullable
as bool,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogDto].
extension AuditLogDtoPatterns on AuditLogDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogDto value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String actorType,  String? actorId,  String action,  String resourceType,  String? resourceId,  String outcome,  String severity,  String traceId,  bool containsPii,  String occurredAt,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogDto() when $default != null:
return $default(_that.id,_that.tenantId,_that.actorType,_that.actorId,_that.action,_that.resourceType,_that.resourceId,_that.outcome,_that.severity,_that.traceId,_that.containsPii,_that.occurredAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String actorType,  String? actorId,  String action,  String resourceType,  String? resourceId,  String outcome,  String severity,  String traceId,  bool containsPii,  String occurredAt,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AuditLogDto():
return $default(_that.id,_that.tenantId,_that.actorType,_that.actorId,_that.action,_that.resourceType,_that.resourceId,_that.outcome,_that.severity,_that.traceId,_that.containsPii,_that.occurredAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String actorType,  String? actorId,  String action,  String resourceType,  String? resourceId,  String outcome,  String severity,  String traceId,  bool containsPii,  String occurredAt,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogDto() when $default != null:
return $default(_that.id,_that.tenantId,_that.actorType,_that.actorId,_that.action,_that.resourceType,_that.resourceId,_that.outcome,_that.severity,_that.traceId,_that.containsPii,_that.occurredAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogDto implements AuditLogDto {
  const _AuditLogDto({required this.id, required this.tenantId, required this.actorType, this.actorId, required this.action, required this.resourceType, this.resourceId, required this.outcome, required this.severity, required this.traceId, required this.containsPii, required this.occurredAt, required this.createdAt});
  factory _AuditLogDto.fromJson(Map<String, dynamic> json) => _$AuditLogDtoFromJson(json);

@override final  String id;
@override final  String tenantId;
@override final  String actorType;
@override final  String? actorId;
@override final  String action;
@override final  String resourceType;
@override final  String? resourceId;
@override final  String outcome;
@override final  String severity;
@override final  String traceId;
@override final  bool containsPii;
@override final  String occurredAt;
@override final  String createdAt;

/// Create a copy of AuditLogDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogDtoCopyWith<_AuditLogDto> get copyWith => __$AuditLogDtoCopyWithImpl<_AuditLogDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.traceId, traceId) || other.traceId == traceId)&&(identical(other.containsPii, containsPii) || other.containsPii == containsPii)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,actorType,actorId,action,resourceType,resourceId,outcome,severity,traceId,containsPii,occurredAt,createdAt);

@override
String toString() {
  return 'AuditLogDto(id: $id, tenantId: $tenantId, actorType: $actorType, actorId: $actorId, action: $action, resourceType: $resourceType, resourceId: $resourceId, outcome: $outcome, severity: $severity, traceId: $traceId, containsPii: $containsPii, occurredAt: $occurredAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AuditLogDtoCopyWith<$Res> implements $AuditLogDtoCopyWith<$Res> {
  factory _$AuditLogDtoCopyWith(_AuditLogDto value, $Res Function(_AuditLogDto) _then) = __$AuditLogDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String actorType, String? actorId, String action, String resourceType, String? resourceId, String outcome, String severity, String traceId, bool containsPii, String occurredAt, String createdAt
});




}
/// @nodoc
class __$AuditLogDtoCopyWithImpl<$Res>
    implements _$AuditLogDtoCopyWith<$Res> {
  __$AuditLogDtoCopyWithImpl(this._self, this._then);

  final _AuditLogDto _self;
  final $Res Function(_AuditLogDto) _then;

/// Create a copy of AuditLogDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? actorType = null,Object? actorId = freezed,Object? action = null,Object? resourceType = null,Object? resourceId = freezed,Object? outcome = null,Object? severity = null,Object? traceId = null,Object? containsPii = null,Object? occurredAt = null,Object? createdAt = null,}) {
  return _then(_AuditLogDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as String,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,containsPii: null == containsPii ? _self.containsPii : containsPii // ignore: cast_nullable_to_non_nullable
as bool,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
