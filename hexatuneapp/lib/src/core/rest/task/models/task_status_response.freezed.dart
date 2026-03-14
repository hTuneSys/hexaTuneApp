// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskStatusResponse {

 String get taskId; String get taskType; String get status; Map<String, dynamic> get payload; String get scheduledAt; int get retryCount; int get maxRetries; String get createdAt; String get updatedAt; String? get cronExpression; String? get executeAfter; String? get startedAt; String? get completedAt; String? get failedAt; String? get cancelledAt; String? get errorMessage; Map<String, dynamic>? get result; int? get progressPercentage; String? get progressStatus;
/// Create a copy of TaskStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskStatusResponseCopyWith<TaskStatusResponse> get copyWith => _$TaskStatusResponseCopyWithImpl<TaskStatusResponse>(this as TaskStatusResponse, _$identity);

  /// Serializes this TaskStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskStatusResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.failedAt, failedAt) || other.failedAt == failedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.result, result)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,taskId,taskType,status,const DeepCollectionEquality().hash(payload),scheduledAt,retryCount,maxRetries,createdAt,updatedAt,cronExpression,executeAfter,startedAt,completedAt,failedAt,cancelledAt,errorMessage,const DeepCollectionEquality().hash(result),progressPercentage,progressStatus]);

@override
String toString() {
  return 'TaskStatusResponse(taskId: $taskId, taskType: $taskType, status: $status, payload: $payload, scheduledAt: $scheduledAt, retryCount: $retryCount, maxRetries: $maxRetries, createdAt: $createdAt, updatedAt: $updatedAt, cronExpression: $cronExpression, executeAfter: $executeAfter, startedAt: $startedAt, completedAt: $completedAt, failedAt: $failedAt, cancelledAt: $cancelledAt, errorMessage: $errorMessage, result: $result, progressPercentage: $progressPercentage, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class $TaskStatusResponseCopyWith<$Res>  {
  factory $TaskStatusResponseCopyWith(TaskStatusResponse value, $Res Function(TaskStatusResponse) _then) = _$TaskStatusResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String taskType, String status, Map<String, dynamic> payload, String scheduledAt, int retryCount, int maxRetries, String createdAt, String updatedAt, String? cronExpression, String? executeAfter, String? startedAt, String? completedAt, String? failedAt, String? cancelledAt, String? errorMessage, Map<String, dynamic>? result, int? progressPercentage, String? progressStatus
});




}
/// @nodoc
class _$TaskStatusResponseCopyWithImpl<$Res>
    implements $TaskStatusResponseCopyWith<$Res> {
  _$TaskStatusResponseCopyWithImpl(this._self, this._then);

  final TaskStatusResponse _self;
  final $Res Function(TaskStatusResponse) _then;

/// Create a copy of TaskStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? taskType = null,Object? status = null,Object? payload = null,Object? scheduledAt = null,Object? retryCount = null,Object? maxRetries = null,Object? createdAt = null,Object? updatedAt = null,Object? cronExpression = freezed,Object? executeAfter = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? failedAt = freezed,Object? cancelledAt = freezed,Object? errorMessage = freezed,Object? result = freezed,Object? progressPercentage = freezed,Object? progressStatus = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,failedAt: freezed == failedAt ? _self.failedAt : failedAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,progressPercentage: freezed == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as int?,progressStatus: freezed == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskStatusResponse].
extension TaskStatusResponsePatterns on TaskStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String taskType,  String status,  Map<String, dynamic> payload,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter,  String? startedAt,  String? completedAt,  String? failedAt,  String? cancelledAt,  String? errorMessage,  Map<String, dynamic>? result,  int? progressPercentage,  String? progressStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskStatusResponse() when $default != null:
return $default(_that.taskId,_that.taskType,_that.status,_that.payload,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter,_that.startedAt,_that.completedAt,_that.failedAt,_that.cancelledAt,_that.errorMessage,_that.result,_that.progressPercentage,_that.progressStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String taskType,  String status,  Map<String, dynamic> payload,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter,  String? startedAt,  String? completedAt,  String? failedAt,  String? cancelledAt,  String? errorMessage,  Map<String, dynamic>? result,  int? progressPercentage,  String? progressStatus)  $default,) {final _that = this;
switch (_that) {
case _TaskStatusResponse():
return $default(_that.taskId,_that.taskType,_that.status,_that.payload,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter,_that.startedAt,_that.completedAt,_that.failedAt,_that.cancelledAt,_that.errorMessage,_that.result,_that.progressPercentage,_that.progressStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String taskType,  String status,  Map<String, dynamic> payload,  String scheduledAt,  int retryCount,  int maxRetries,  String createdAt,  String updatedAt,  String? cronExpression,  String? executeAfter,  String? startedAt,  String? completedAt,  String? failedAt,  String? cancelledAt,  String? errorMessage,  Map<String, dynamic>? result,  int? progressPercentage,  String? progressStatus)?  $default,) {final _that = this;
switch (_that) {
case _TaskStatusResponse() when $default != null:
return $default(_that.taskId,_that.taskType,_that.status,_that.payload,_that.scheduledAt,_that.retryCount,_that.maxRetries,_that.createdAt,_that.updatedAt,_that.cronExpression,_that.executeAfter,_that.startedAt,_that.completedAt,_that.failedAt,_that.cancelledAt,_that.errorMessage,_that.result,_that.progressPercentage,_that.progressStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskStatusResponse implements TaskStatusResponse {
  const _TaskStatusResponse({required this.taskId, required this.taskType, required this.status, required final  Map<String, dynamic> payload, required this.scheduledAt, required this.retryCount, required this.maxRetries, required this.createdAt, required this.updatedAt, this.cronExpression, this.executeAfter, this.startedAt, this.completedAt, this.failedAt, this.cancelledAt, this.errorMessage, final  Map<String, dynamic>? result, this.progressPercentage, this.progressStatus}): _payload = payload,_result = result;
  factory _TaskStatusResponse.fromJson(Map<String, dynamic> json) => _$TaskStatusResponseFromJson(json);

@override final  String taskId;
@override final  String taskType;
@override final  String status;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override final  String scheduledAt;
@override final  int retryCount;
@override final  int maxRetries;
@override final  String createdAt;
@override final  String updatedAt;
@override final  String? cronExpression;
@override final  String? executeAfter;
@override final  String? startedAt;
@override final  String? completedAt;
@override final  String? failedAt;
@override final  String? cancelledAt;
@override final  String? errorMessage;
 final  Map<String, dynamic>? _result;
@override Map<String, dynamic>? get result {
  final value = _result;
  if (value == null) return null;
  if (_result is EqualUnmodifiableMapView) return _result;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? progressPercentage;
@override final  String? progressStatus;

/// Create a copy of TaskStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskStatusResponseCopyWith<_TaskStatusResponse> get copyWith => __$TaskStatusResponseCopyWithImpl<_TaskStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskStatusResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.failedAt, failedAt) || other.failedAt == failedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._result, _result)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,taskId,taskType,status,const DeepCollectionEquality().hash(_payload),scheduledAt,retryCount,maxRetries,createdAt,updatedAt,cronExpression,executeAfter,startedAt,completedAt,failedAt,cancelledAt,errorMessage,const DeepCollectionEquality().hash(_result),progressPercentage,progressStatus]);

@override
String toString() {
  return 'TaskStatusResponse(taskId: $taskId, taskType: $taskType, status: $status, payload: $payload, scheduledAt: $scheduledAt, retryCount: $retryCount, maxRetries: $maxRetries, createdAt: $createdAt, updatedAt: $updatedAt, cronExpression: $cronExpression, executeAfter: $executeAfter, startedAt: $startedAt, completedAt: $completedAt, failedAt: $failedAt, cancelledAt: $cancelledAt, errorMessage: $errorMessage, result: $result, progressPercentage: $progressPercentage, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class _$TaskStatusResponseCopyWith<$Res> implements $TaskStatusResponseCopyWith<$Res> {
  factory _$TaskStatusResponseCopyWith(_TaskStatusResponse value, $Res Function(_TaskStatusResponse) _then) = __$TaskStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String taskType, String status, Map<String, dynamic> payload, String scheduledAt, int retryCount, int maxRetries, String createdAt, String updatedAt, String? cronExpression, String? executeAfter, String? startedAt, String? completedAt, String? failedAt, String? cancelledAt, String? errorMessage, Map<String, dynamic>? result, int? progressPercentage, String? progressStatus
});




}
/// @nodoc
class __$TaskStatusResponseCopyWithImpl<$Res>
    implements _$TaskStatusResponseCopyWith<$Res> {
  __$TaskStatusResponseCopyWithImpl(this._self, this._then);

  final _TaskStatusResponse _self;
  final $Res Function(_TaskStatusResponse) _then;

/// Create a copy of TaskStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? taskType = null,Object? status = null,Object? payload = null,Object? scheduledAt = null,Object? retryCount = null,Object? maxRetries = null,Object? createdAt = null,Object? updatedAt = null,Object? cronExpression = freezed,Object? executeAfter = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? failedAt = freezed,Object? cancelledAt = freezed,Object? errorMessage = freezed,Object? result = freezed,Object? progressPercentage = freezed,Object? progressStatus = freezed,}) {
  return _then(_TaskStatusResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as String,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,failedAt: freezed == failedAt ? _self.failedAt : failedAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self._result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,progressPercentage: freezed == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as int?,progressStatus: freezed == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
