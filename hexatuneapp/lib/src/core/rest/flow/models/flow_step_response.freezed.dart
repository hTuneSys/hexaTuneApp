// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_step_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowStepResponse {

 String get id; String get stepId; int get sortOrder; int get quantity;/// Duration in milliseconds.
 int get timeMs;
/// Create a copy of FlowStepResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowStepResponseCopyWith<FlowStepResponse> get copyWith => _$FlowStepResponseCopyWithImpl<FlowStepResponse>(this as FlowStepResponse, _$identity);

  /// Serializes this FlowStepResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowStepResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.timeMs, timeMs) || other.timeMs == timeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stepId,sortOrder,quantity,timeMs);

@override
String toString() {
  return 'FlowStepResponse(id: $id, stepId: $stepId, sortOrder: $sortOrder, quantity: $quantity, timeMs: $timeMs)';
}


}

/// @nodoc
abstract mixin class $FlowStepResponseCopyWith<$Res>  {
  factory $FlowStepResponseCopyWith(FlowStepResponse value, $Res Function(FlowStepResponse) _then) = _$FlowStepResponseCopyWithImpl;
@useResult
$Res call({
 String id, String stepId, int sortOrder, int quantity, int timeMs
});




}
/// @nodoc
class _$FlowStepResponseCopyWithImpl<$Res>
    implements $FlowStepResponseCopyWith<$Res> {
  _$FlowStepResponseCopyWithImpl(this._self, this._then);

  final FlowStepResponse _self;
  final $Res Function(FlowStepResponse) _then;

/// Create a copy of FlowStepResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stepId = null,Object? sortOrder = null,Object? quantity = null,Object? timeMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,timeMs: null == timeMs ? _self.timeMs : timeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowStepResponse].
extension FlowStepResponsePatterns on FlowStepResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowStepResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowStepResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowStepResponse value)  $default,){
final _that = this;
switch (_that) {
case _FlowStepResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowStepResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FlowStepResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String stepId,  int sortOrder,  int quantity,  int timeMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowStepResponse() when $default != null:
return $default(_that.id,_that.stepId,_that.sortOrder,_that.quantity,_that.timeMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String stepId,  int sortOrder,  int quantity,  int timeMs)  $default,) {final _that = this;
switch (_that) {
case _FlowStepResponse():
return $default(_that.id,_that.stepId,_that.sortOrder,_that.quantity,_that.timeMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String stepId,  int sortOrder,  int quantity,  int timeMs)?  $default,) {final _that = this;
switch (_that) {
case _FlowStepResponse() when $default != null:
return $default(_that.id,_that.stepId,_that.sortOrder,_that.quantity,_that.timeMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlowStepResponse implements FlowStepResponse {
  const _FlowStepResponse({required this.id, required this.stepId, required this.sortOrder, required this.quantity, required this.timeMs});
  factory _FlowStepResponse.fromJson(Map<String, dynamic> json) => _$FlowStepResponseFromJson(json);

@override final  String id;
@override final  String stepId;
@override final  int sortOrder;
@override final  int quantity;
/// Duration in milliseconds.
@override final  int timeMs;

/// Create a copy of FlowStepResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowStepResponseCopyWith<_FlowStepResponse> get copyWith => __$FlowStepResponseCopyWithImpl<_FlowStepResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlowStepResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowStepResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.timeMs, timeMs) || other.timeMs == timeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stepId,sortOrder,quantity,timeMs);

@override
String toString() {
  return 'FlowStepResponse(id: $id, stepId: $stepId, sortOrder: $sortOrder, quantity: $quantity, timeMs: $timeMs)';
}


}

/// @nodoc
abstract mixin class _$FlowStepResponseCopyWith<$Res> implements $FlowStepResponseCopyWith<$Res> {
  factory _$FlowStepResponseCopyWith(_FlowStepResponse value, $Res Function(_FlowStepResponse) _then) = __$FlowStepResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String stepId, int sortOrder, int quantity, int timeMs
});




}
/// @nodoc
class __$FlowStepResponseCopyWithImpl<$Res>
    implements _$FlowStepResponseCopyWith<$Res> {
  __$FlowStepResponseCopyWithImpl(this._self, this._then);

  final _FlowStepResponse _self;
  final $Res Function(_FlowStepResponse) _then;

/// Create a copy of FlowStepResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stepId = null,Object? sortOrder = null,Object? quantity = null,Object? timeMs = null,}) {
  return _then(_FlowStepResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,timeMs: null == timeMs ? _self.timeMs : timeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
