// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_task_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskResponse {

 String get taskId; String get status; String get scheduledAt; String? get executeAfter;
/// Create a copy of CreateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskResponseCopyWith<CreateTaskResponse> get copyWith => _$CreateTaskResponseCopyWithImpl<CreateTaskResponse>(this as CreateTaskResponse, _$identity);

  /// Serializes this CreateTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,scheduledAt,executeAfter);

@override
String toString() {
  return 'CreateTaskResponse(taskId: $taskId, status: $status, scheduledAt: $scheduledAt, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class $CreateTaskResponseCopyWith<$Res>  {
  factory $CreateTaskResponseCopyWith(CreateTaskResponse value, $Res Function(CreateTaskResponse) _then) = _$CreateTaskResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String status, String scheduledAt, String? executeAfter
});




}
/// @nodoc
class _$CreateTaskResponseCopyWithImpl<$Res>
    implements $CreateTaskResponseCopyWith<$Res> {
  _$CreateTaskResponseCopyWithImpl(this._self, this._then);

  final CreateTaskResponse _self;
  final $Res Function(CreateTaskResponse) _then;

/// Create a copy of CreateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,Object? scheduledAt = null,Object? executeAfter = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskResponse].
extension CreateTaskResponsePatterns on CreateTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String status,  String scheduledAt,  String? executeAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskResponse() when $default != null:
return $default(_that.taskId,_that.status,_that.scheduledAt,_that.executeAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String status,  String scheduledAt,  String? executeAfter)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskResponse():
return $default(_that.taskId,_that.status,_that.scheduledAt,_that.executeAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String status,  String scheduledAt,  String? executeAfter)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskResponse() when $default != null:
return $default(_that.taskId,_that.status,_that.scheduledAt,_that.executeAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskResponse implements CreateTaskResponse {
  const _CreateTaskResponse({required this.taskId, required this.status, required this.scheduledAt, this.executeAfter});
  factory _CreateTaskResponse.fromJson(Map<String, dynamic> json) => _$CreateTaskResponseFromJson(json);

@override final  String taskId;
@override final  String status;
@override final  String scheduledAt;
@override final  String? executeAfter;

/// Create a copy of CreateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskResponseCopyWith<_CreateTaskResponse> get copyWith => __$CreateTaskResponseCopyWithImpl<_CreateTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,scheduledAt,executeAfter);

@override
String toString() {
  return 'CreateTaskResponse(taskId: $taskId, status: $status, scheduledAt: $scheduledAt, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskResponseCopyWith<$Res> implements $CreateTaskResponseCopyWith<$Res> {
  factory _$CreateTaskResponseCopyWith(_CreateTaskResponse value, $Res Function(_CreateTaskResponse) _then) = __$CreateTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String status, String scheduledAt, String? executeAfter
});




}
/// @nodoc
class __$CreateTaskResponseCopyWithImpl<$Res>
    implements _$CreateTaskResponseCopyWith<$Res> {
  __$CreateTaskResponseCopyWithImpl(this._self, this._then);

  final _CreateTaskResponse _self;
  final $Res Function(_CreateTaskResponse) _then;

/// Create a copy of CreateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,Object? scheduledAt = null,Object? executeAfter = freezed,}) {
  return _then(_CreateTaskResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
