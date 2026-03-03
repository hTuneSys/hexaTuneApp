// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cancel_task_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CancelTaskResponse {

 String get taskId; String get status;
/// Create a copy of CancelTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancelTaskResponseCopyWith<CancelTaskResponse> get copyWith => _$CancelTaskResponseCopyWithImpl<CancelTaskResponse>(this as CancelTaskResponse, _$identity);

  /// Serializes this CancelTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status);

@override
String toString() {
  return 'CancelTaskResponse(taskId: $taskId, status: $status)';
}


}

/// @nodoc
abstract mixin class $CancelTaskResponseCopyWith<$Res>  {
  factory $CancelTaskResponseCopyWith(CancelTaskResponse value, $Res Function(CancelTaskResponse) _then) = _$CancelTaskResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String status
});




}
/// @nodoc
class _$CancelTaskResponseCopyWithImpl<$Res>
    implements $CancelTaskResponseCopyWith<$Res> {
  _$CancelTaskResponseCopyWithImpl(this._self, this._then);

  final CancelTaskResponse _self;
  final $Res Function(CancelTaskResponse) _then;

/// Create a copy of CancelTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CancelTaskResponse].
extension CancelTaskResponsePatterns on CancelTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CancelTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CancelTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CancelTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _CancelTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CancelTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CancelTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CancelTaskResponse() when $default != null:
return $default(_that.taskId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String status)  $default,) {final _that = this;
switch (_that) {
case _CancelTaskResponse():
return $default(_that.taskId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _CancelTaskResponse() when $default != null:
return $default(_that.taskId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CancelTaskResponse implements CancelTaskResponse {
  const _CancelTaskResponse({required this.taskId, required this.status});
  factory _CancelTaskResponse.fromJson(Map<String, dynamic> json) => _$CancelTaskResponseFromJson(json);

@override final  String taskId;
@override final  String status;

/// Create a copy of CancelTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancelTaskResponseCopyWith<_CancelTaskResponse> get copyWith => __$CancelTaskResponseCopyWithImpl<_CancelTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancelTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CancelTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status);

@override
String toString() {
  return 'CancelTaskResponse(taskId: $taskId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CancelTaskResponseCopyWith<$Res> implements $CancelTaskResponseCopyWith<$Res> {
  factory _$CancelTaskResponseCopyWith(_CancelTaskResponse value, $Res Function(_CancelTaskResponse) _then) = __$CancelTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String status
});




}
/// @nodoc
class __$CancelTaskResponseCopyWithImpl<$Res>
    implements _$CancelTaskResponseCopyWith<$Res> {
  __$CancelTaskResponseCopyWithImpl(this._self, this._then);

  final _CancelTaskResponse _self;
  final $Res Function(_CancelTaskResponse) _then;

/// Create a copy of CancelTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,}) {
  return _then(_CancelTaskResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
