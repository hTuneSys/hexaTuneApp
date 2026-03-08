// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cancel_task_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CancelTaskRequest {

 String? get reason;
/// Create a copy of CancelTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancelTaskRequestCopyWith<CancelTaskRequest> get copyWith => _$CancelTaskRequestCopyWithImpl<CancelTaskRequest>(this as CancelTaskRequest, _$identity);

  /// Serializes this CancelTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelTaskRequest&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CancelTaskRequest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CancelTaskRequestCopyWith<$Res>  {
  factory $CancelTaskRequestCopyWith(CancelTaskRequest value, $Res Function(CancelTaskRequest) _then) = _$CancelTaskRequestCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$CancelTaskRequestCopyWithImpl<$Res>
    implements $CancelTaskRequestCopyWith<$Res> {
  _$CancelTaskRequestCopyWithImpl(this._self, this._then);

  final CancelTaskRequest _self;
  final $Res Function(CancelTaskRequest) _then;

/// Create a copy of CancelTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = freezed,}) {
  return _then(_self.copyWith(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CancelTaskRequest].
extension CancelTaskRequestPatterns on CancelTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CancelTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CancelTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CancelTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _CancelTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CancelTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CancelTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CancelTaskRequest() when $default != null:
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reason)  $default,) {final _that = this;
switch (_that) {
case _CancelTaskRequest():
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reason)?  $default,) {final _that = this;
switch (_that) {
case _CancelTaskRequest() when $default != null:
return $default(_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CancelTaskRequest implements CancelTaskRequest {
  const _CancelTaskRequest({this.reason});
  factory _CancelTaskRequest.fromJson(Map<String, dynamic> json) => _$CancelTaskRequestFromJson(json);

@override final  String? reason;

/// Create a copy of CancelTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancelTaskRequestCopyWith<_CancelTaskRequest> get copyWith => __$CancelTaskRequestCopyWithImpl<_CancelTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancelTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CancelTaskRequest&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CancelTaskRequest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CancelTaskRequestCopyWith<$Res> implements $CancelTaskRequestCopyWith<$Res> {
  factory _$CancelTaskRequestCopyWith(_CancelTaskRequest value, $Res Function(_CancelTaskRequest) _then) = __$CancelTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String? reason
});




}
/// @nodoc
class __$CancelTaskRequestCopyWithImpl<$Res>
    implements _$CancelTaskRequestCopyWith<$Res> {
  __$CancelTaskRequestCopyWithImpl(this._self, this._then);

  final _CancelTaskRequest _self;
  final $Res Function(_CancelTaskRequest) _then;

/// Create a copy of CancelTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(_CancelTaskRequest(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
