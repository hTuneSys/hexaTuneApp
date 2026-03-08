// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_task_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskRequest {

 String get taskType; Map<String, dynamic> get payload; String? get cronExpression; String? get executeAfter;
/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskRequestCopyWith<CreateTaskRequest> get copyWith => _$CreateTaskRequestCopyWithImpl<CreateTaskRequest>(this as CreateTaskRequest, _$identity);

  /// Serializes this CreateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskRequest&&(identical(other.taskType, taskType) || other.taskType == taskType)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskType,const DeepCollectionEquality().hash(payload),cronExpression,executeAfter);

@override
String toString() {
  return 'CreateTaskRequest(taskType: $taskType, payload: $payload, cronExpression: $cronExpression, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class $CreateTaskRequestCopyWith<$Res>  {
  factory $CreateTaskRequestCopyWith(CreateTaskRequest value, $Res Function(CreateTaskRequest) _then) = _$CreateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String taskType, Map<String, dynamic> payload, String? cronExpression, String? executeAfter
});




}
/// @nodoc
class _$CreateTaskRequestCopyWithImpl<$Res>
    implements $CreateTaskRequestCopyWith<$Res> {
  _$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final CreateTaskRequest _self;
  final $Res Function(CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskType = null,Object? payload = null,Object? cronExpression = freezed,Object? executeAfter = freezed,}) {
  return _then(_self.copyWith(
taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskRequest].
extension CreateTaskRequestPatterns on CreateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskType,  Map<String, dynamic> payload,  String? cronExpression,  String? executeAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.taskType,_that.payload,_that.cronExpression,_that.executeAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskType,  Map<String, dynamic> payload,  String? cronExpression,  String? executeAfter)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest():
return $default(_that.taskType,_that.payload,_that.cronExpression,_that.executeAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskType,  Map<String, dynamic> payload,  String? cronExpression,  String? executeAfter)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.taskType,_that.payload,_that.cronExpression,_that.executeAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskRequest implements CreateTaskRequest {
  const _CreateTaskRequest({required this.taskType, required final  Map<String, dynamic> payload, this.cronExpression, this.executeAfter}): _payload = payload;
  factory _CreateTaskRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskRequestFromJson(json);

@override final  String taskType;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override final  String? cronExpression;
@override final  String? executeAfter;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskRequestCopyWith<_CreateTaskRequest> get copyWith => __$CreateTaskRequestCopyWithImpl<_CreateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskRequest&&(identical(other.taskType, taskType) || other.taskType == taskType)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.cronExpression, cronExpression) || other.cronExpression == cronExpression)&&(identical(other.executeAfter, executeAfter) || other.executeAfter == executeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskType,const DeepCollectionEquality().hash(_payload),cronExpression,executeAfter);

@override
String toString() {
  return 'CreateTaskRequest(taskType: $taskType, payload: $payload, cronExpression: $cronExpression, executeAfter: $executeAfter)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskRequestCopyWith<$Res> implements $CreateTaskRequestCopyWith<$Res> {
  factory _$CreateTaskRequestCopyWith(_CreateTaskRequest value, $Res Function(_CreateTaskRequest) _then) = __$CreateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String taskType, Map<String, dynamic> payload, String? cronExpression, String? executeAfter
});




}
/// @nodoc
class __$CreateTaskRequestCopyWithImpl<$Res>
    implements _$CreateTaskRequestCopyWith<$Res> {
  __$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final _CreateTaskRequest _self;
  final $Res Function(_CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskType = null,Object? payload = null,Object? cronExpression = freezed,Object? executeAfter = freezed,}) {
  return _then(_CreateTaskRequest(
taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,cronExpression: freezed == cronExpression ? _self.cronExpression : cronExpression // ignore: cast_nullable_to_non_nullable
as String?,executeAfter: freezed == executeAfter ? _self.executeAfter : executeAfter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
