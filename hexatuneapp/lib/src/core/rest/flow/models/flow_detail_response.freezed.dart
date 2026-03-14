// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowDetailResponse {

 String get id; String get name; String get description; List<String> get labels; bool get imageUploaded; List<FlowStepResponse> get steps; String get createdAt; String get updatedAt;
/// Create a copy of FlowDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowDetailResponseCopyWith<FlowDetailResponse> get copyWith => _$FlowDetailResponseCopyWithImpl<FlowDetailResponse>(this as FlowDetailResponse, _$identity);

  /// Serializes this FlowDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowDetailResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(labels),imageUploaded,const DeepCollectionEquality().hash(steps),createdAt,updatedAt);

@override
String toString() {
  return 'FlowDetailResponse(id: $id, name: $name, description: $description, labels: $labels, imageUploaded: $imageUploaded, steps: $steps, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FlowDetailResponseCopyWith<$Res>  {
  factory $FlowDetailResponseCopyWith(FlowDetailResponse value, $Res Function(FlowDetailResponse) _then) = _$FlowDetailResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, List<String> labels, bool imageUploaded, List<FlowStepResponse> steps, String createdAt, String updatedAt
});




}
/// @nodoc
class _$FlowDetailResponseCopyWithImpl<$Res>
    implements $FlowDetailResponseCopyWith<$Res> {
  _$FlowDetailResponseCopyWithImpl(this._self, this._then);

  final FlowDetailResponse _self;
  final $Res Function(FlowDetailResponse) _then;

/// Create a copy of FlowDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? labels = null,Object? imageUploaded = null,Object? steps = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<FlowStepResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowDetailResponse].
extension FlowDetailResponsePatterns on FlowDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _FlowDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FlowDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  List<FlowStepResponse> steps,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowDetailResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.steps,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  List<FlowStepResponse> steps,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FlowDetailResponse():
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.steps,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  List<FlowStepResponse> steps,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FlowDetailResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.steps,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlowDetailResponse implements FlowDetailResponse {
  const _FlowDetailResponse({required this.id, required this.name, required this.description, required final  List<String> labels, required this.imageUploaded, required final  List<FlowStepResponse> steps, required this.createdAt, required this.updatedAt}): _labels = labels,_steps = steps;
  factory _FlowDetailResponse.fromJson(Map<String, dynamic> json) => _$FlowDetailResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
 final  List<String> _labels;
@override List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override final  bool imageUploaded;
 final  List<FlowStepResponse> _steps;
@override List<FlowStepResponse> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of FlowDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowDetailResponseCopyWith<_FlowDetailResponse> get copyWith => __$FlowDetailResponseCopyWithImpl<_FlowDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlowDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowDetailResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_labels),imageUploaded,const DeepCollectionEquality().hash(_steps),createdAt,updatedAt);

@override
String toString() {
  return 'FlowDetailResponse(id: $id, name: $name, description: $description, labels: $labels, imageUploaded: $imageUploaded, steps: $steps, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FlowDetailResponseCopyWith<$Res> implements $FlowDetailResponseCopyWith<$Res> {
  factory _$FlowDetailResponseCopyWith(_FlowDetailResponse value, $Res Function(_FlowDetailResponse) _then) = __$FlowDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, List<String> labels, bool imageUploaded, List<FlowStepResponse> steps, String createdAt, String updatedAt
});




}
/// @nodoc
class __$FlowDetailResponseCopyWithImpl<$Res>
    implements _$FlowDetailResponseCopyWith<$Res> {
  __$FlowDetailResponseCopyWithImpl(this._self, this._then);

  final _FlowDetailResponse _self;
  final $Res Function(_FlowDetailResponse) _then;

/// Create a copy of FlowDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? labels = null,Object? imageUploaded = null,Object? steps = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FlowDetailResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<FlowStepResponse>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
