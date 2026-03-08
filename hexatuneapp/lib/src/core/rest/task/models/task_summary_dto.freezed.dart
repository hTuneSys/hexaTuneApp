// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskSummaryDto {

 String get taskId; String get taskType; String get status; String get scheduledAt; int get retryCount; int get maxRetries; String get createdAt; String get updatedAt; String? get cronExpression; String? get executeAfter;
/// Create a copy of TaskSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSummaryDtoCopyWith<TaskSummaryDto> get copyWith => _$TaskSummaryDtoCopyWithImpl<TaskSummaryDto>(this as TaskSummaryDto, _$identity);

  /// Serializes this TaskSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSummaryDto&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskType,status,scheduledAt,retryCount,maxRetries,createdAt,updatedAt,cronExpression,executeAfter);

@override
String toString() {
  return 'TaskSummaryDto(taskId: $taskId, taskType: $taskType, status: $status, scheduledAt: $scheduledAt, retryCount: $retryCount, maxRetries: $maxRetries, createdAt: $createdAt, updatedAt: $updatedAt, cronExpression: $cronExpression, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class $TaskSummaryDtoCopyWith<$Res>  {
  factory $TaskSummaryDtoCopyWith(TaskSummaryDto value, $Res Function(TaskSummaryDto) _then) = _$TaskSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String taskId, String taskType, String status, String scheduledAt, int retryCount, int maxRetries, String createdAt, String updatedAt, String? cronExpression, String? executeAfter
});




}
/// @nodoc
class _$TaskSummaryDtoCopyWithImpl<$Res>
    implements $TaskSummaryDtoCopyWith<$Res> {
  _$TaskSummaryDtoCopyWithImpl(this._self, this._then);

  final TaskSummaryDto _self;
  final $Res Function(TaskSummaryDto) _then;

/// Create a copy of TaskSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? taskType = null,Object? status = null,Object? scheduledAt = null,Object? retryCount = null,Object? maxRetries = null,Object? createdAt = null,Object? updatedAt = null,Object? cronExpression = freezed,Object? executeAfter = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSummaryDto].
extension TaskSummaryDtoPatterns on TaskSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _TaskSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String taskType,  String status,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSummaryDto() when $default != null:
return $default(_that.taskId,_that.taskType,_that.status,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String taskType,  String status,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter)  $default,) {final _that = this;
switch (_that) {
case _TaskSummaryDto():
return $default(_that.taskId,_that.taskType,_that.status,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String taskType,  String status,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter)?  $default,) {final _that = this;
switch (_that) {
case _TaskSummaryDto() when $default != null:
return $default(_that.taskId,_that.taskType,_that.status,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSummaryDto implements TaskSummaryDto {
  const _TaskSummaryDto({required this.taskId, required this.taskType, required this.status, required this.scheduledAt, required this.retryCount, required this.maxRetries, required this.createdAt, required this.updatedAt, this.cronExpression, this.executeAfter});
  factory _TaskSummaryDto.fromJson(Map<String, dynamic> json) => _$TaskSummaryDtoFromJson(json);

@override final  String taskId;
@override final  String taskType;
@override final  String status;
@override final  String scheduledAt;
@override final  int retryCount;
@override final  int maxRetries;
@override final  String createdAt;
@override final  String updatedAt;
@override final  String? cronExpression;
@override final  String? executeAfter;

/// Create a copy of TaskSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSummaryDtoCopyWith<_TaskSummaryDto> get copyWith => __$TaskSummaryDtoCopyWithImpl<_TaskSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSummaryDto&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskType,status,scheduledAt,retryCount,maxRetries,createdAt,updatedAt,cronExpression,executeAfter);

@override
String toString() {
  return 'TaskSummaryDto(taskId: $taskId, taskType: $taskType, status: $status, scheduledAt: $scheduledAt, retryCount: $retryCount, maxRetries: $maxRetries, createdAt: $createdAt, updatedAt: $updatedAt, cronExpression: $cronExpression, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class _$TaskSummaryDtoCopyWith<$Res> implements $TaskSummaryDtoCopyWith<$Res> {
  factory _$TaskSummaryDtoCopyWith(_TaskSummaryDto value, $Res Function(_TaskSummaryDto) _then) = __$TaskSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String taskType, String status, String scheduledAt, int retryCount, int maxRetries, String createdAt, String updatedAt, String? cronExpression, String? executeAfter
});




}
/// @nodoc
class __$TaskSummaryDtoCopyWithImpl<$Res>
    implements _$TaskSummaryDtoCopyWith<$Res> {
  __$TaskSummaryDtoCopyWithImpl(this._self, this._then);

  final _TaskSummaryDto _self;
  final $Res Function(_TaskSummaryDto) _then;

/// Create a copy of TaskSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? taskType = null,Object? status = null,Object? scheduledAt = null,Object? retryCount = null,Object? maxRetries = null,Object? createdAt = null,Object? updatedAt = null,Object? cronExpression = freezed,Object? executeAfter = freezed,}) {
  return _then(_TaskSummaryDto(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
