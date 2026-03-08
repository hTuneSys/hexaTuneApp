// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_formula_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateFormulaRequest {

 String get name; List<String>? get labels;
/// Create a copy of CreateFormulaRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFormulaRequestCopyWith<CreateFormulaRequest> get copyWith => _$CreateFormulaRequestCopyWithImpl<CreateFormulaRequest>(this as CreateFormulaRequest, _$identity);

  /// Serializes this CreateFormulaRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFormulaRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.labels, labels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(labels));

@override
String toString() {
  return 'CreateFormulaRequest(name: $name, labels: $labels)';
}


}

/// @nodoc
abstract mixin class $CreateFormulaRequestCopyWith<$Res>  {
  factory $CreateFormulaRequestCopyWith(CreateFormulaRequest value, $Res Function(CreateFormulaRequest) _then) = _$CreateFormulaRequestCopyWithImpl;
@useResult
$Res call({
 String name, List<String>? labels
});




}
/// @nodoc
class _$CreateFormulaRequestCopyWithImpl<$Res>
    implements $CreateFormulaRequestCopyWith<$Res> {
  _$CreateFormulaRequestCopyWithImpl(this._self, this._then);

  final CreateFormulaRequest _self;
  final $Res Function(CreateFormulaRequest) _then;

/// Create a copy of CreateFormulaRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? labels = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateFormulaRequest].
extension CreateFormulaRequestPatterns on CreateFormulaRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateFormulaRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateFormulaRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateFormulaRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateFormulaRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateFormulaRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateFormulaRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<String>? labels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateFormulaRequest() when $default != null:
return $default(_that.name,_that.labels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<String>? labels)  $default,) {final _that = this;
switch (_that) {
case _CreateFormulaRequest():
return $default(_that.name,_that.labels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<String>? labels)?  $default,) {final _that = this;
switch (_that) {
case _CreateFormulaRequest() when $default != null:
return $default(_that.name,_that.labels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateFormulaRequest implements CreateFormulaRequest {
  const _CreateFormulaRequest({required this.name, final  List<String>? labels}): _labels = labels;
  factory _CreateFormulaRequest.fromJson(Map<String, dynamic> json) => _$CreateFormulaRequestFromJson(json);

@override final  String name;
 final  List<String>? _labels;
@override List<String>? get labels {
  final value = _labels;
  if (value == null) return null;
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CreateFormulaRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateFormulaRequestCopyWith<_CreateFormulaRequest> get copyWith => __$CreateFormulaRequestCopyWithImpl<_CreateFormulaRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateFormulaRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateFormulaRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._labels, _labels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_labels));

@override
String toString() {
  return 'CreateFormulaRequest(name: $name, labels: $labels)';
}


}

/// @nodoc
abstract mixin class _$CreateFormulaRequestCopyWith<$Res> implements $CreateFormulaRequestCopyWith<$Res> {
  factory _$CreateFormulaRequestCopyWith(_CreateFormulaRequest value, $Res Function(_CreateFormulaRequest) _then) = __$CreateFormulaRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, List<String>? labels
});




}
/// @nodoc
class __$CreateFormulaRequestCopyWithImpl<$Res>
    implements _$CreateFormulaRequestCopyWith<$Res> {
  __$CreateFormulaRequestCopyWithImpl(this._self, this._then);

  final _CreateFormulaRequest _self;
  final $Res Function(_CreateFormulaRequest) _then;

/// Create a copy of CreateFormulaRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? labels = freezed,}) {
  return _then(_CreateFormulaRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: freezed == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
