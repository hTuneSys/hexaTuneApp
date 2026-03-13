// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlowResponse {

 String get id; String get name; String get description; List<String> get labels; bool get imageUploaded; String get createdAt; String get updatedAt;
/// Create a copy of FlowResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowResponseCopyWith<FlowResponse> get copyWith => _$FlowResponseCopyWithImpl<FlowResponse>(this as FlowResponse, _$identity);

  /// Serializes this FlowResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(labels),imageUploaded,createdAt,updatedAt);

@override
String toString() {
  return 'FlowResponse(id: $id, name: $name, description: $description, labels: $labels, imageUploaded: $imageUploaded, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FlowResponseCopyWith<$Res>  {
  factory $FlowResponseCopyWith(FlowResponse value, $Res Function(FlowResponse) _then) = _$FlowResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, List<String> labels, bool imageUploaded, String createdAt, String updatedAt
});




}
/// @nodoc
class _$FlowResponseCopyWithImpl<$Res>
    implements $FlowResponseCopyWith<$Res> {
  _$FlowResponseCopyWithImpl(this._self, this._then);

  final FlowResponse _self;
  final $Res Function(FlowResponse) _then;

/// Create a copy of FlowResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? labels = null,Object? imageUploaded = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowResponse].
extension FlowResponsePatterns on FlowResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowResponse value)  $default,){
final _that = this;
switch (_that) {
case _FlowResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FlowResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FlowResponse():
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  List<String> labels,  bool imageUploaded,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FlowResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.labels,_that.imageUploaded,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlowResponse implements FlowResponse {
  const _FlowResponse({required this.id, required this.name, required this.description, required final  List<String> labels, required this.imageUploaded, required this.createdAt, required this.updatedAt}): _labels = labels;
  factory _FlowResponse.fromJson(Map<String, dynamic> json) => _$FlowResponseFromJson(json);

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
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of FlowResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowResponseCopyWith<_FlowResponse> get copyWith => __$FlowResponseCopyWithImpl<_FlowResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlowResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_labels),imageUploaded,createdAt,updatedAt);

@override
String toString() {
  return 'FlowResponse(id: $id, name: $name, description: $description, labels: $labels, imageUploaded: $imageUploaded, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FlowResponseCopyWith<$Res> implements $FlowResponseCopyWith<$Res> {
  factory _$FlowResponseCopyWith(_FlowResponse value, $Res Function(_FlowResponse) _then) = __$FlowResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, List<String> labels, bool imageUploaded, String createdAt, String updatedAt
});




}
/// @nodoc
class __$FlowResponseCopyWithImpl<$Res>
    implements _$FlowResponseCopyWith<$Res> {
  __$FlowResponseCopyWithImpl(this._self, this._then);

  final _FlowResponse _self;
  final $Res Function(_FlowResponse) _then;

/// Create a copy of FlowResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? labels = null,Object? imageUploaded = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FlowResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
