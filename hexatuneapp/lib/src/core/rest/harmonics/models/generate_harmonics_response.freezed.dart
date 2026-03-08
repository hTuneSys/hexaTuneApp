// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generate_harmonics_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenerateHarmonicsResponse {

 String get requestId; List<HarmonicAssignmentDto> get assignments; int get totalAssigned;
/// Create a copy of GenerateHarmonicsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateHarmonicsResponseCopyWith<GenerateHarmonicsResponse> get copyWith => _$GenerateHarmonicsResponseCopyWithImpl<GenerateHarmonicsResponse>(this as GenerateHarmonicsResponse, _$identity);

  /// Serializes this GenerateHarmonicsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateHarmonicsResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other.assignments, assignments)&&(identical(other.totalAssigned, totalAssigned) || other.totalAssigned == totalAssigned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,const DeepCollectionEquality().hash(assignments),totalAssigned);

@override
String toString() {
  return 'GenerateHarmonicsResponse(requestId: $requestId, assignments: $assignments, totalAssigned: $totalAssigned)';
}


}

/// @nodoc
abstract mixin class $GenerateHarmonicsResponseCopyWith<$Res>  {
  factory $GenerateHarmonicsResponseCopyWith(GenerateHarmonicsResponse value, $Res Function(GenerateHarmonicsResponse) _then) = _$GenerateHarmonicsResponseCopyWithImpl;
@useResult
$Res call({
 String requestId, List<HarmonicAssignmentDto> assignments, int totalAssigned
});




}
/// @nodoc
class _$GenerateHarmonicsResponseCopyWithImpl<$Res>
    implements $GenerateHarmonicsResponseCopyWith<$Res> {
  _$GenerateHarmonicsResponseCopyWithImpl(this._self, this._then);

  final GenerateHarmonicsResponse _self;
  final $Res Function(GenerateHarmonicsResponse) _then;

/// Create a copy of GenerateHarmonicsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? assignments = null,Object? totalAssigned = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,assignments: null == assignments ? _self.assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<HarmonicAssignmentDto>,totalAssigned: null == totalAssigned ? _self.totalAssigned : totalAssigned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateHarmonicsResponse].
extension GenerateHarmonicsResponsePatterns on GenerateHarmonicsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateHarmonicsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateHarmonicsResponse value)  $default,){
final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateHarmonicsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  List<HarmonicAssignmentDto> assignments,  int totalAssigned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse() when $default != null:
return $default(_that.requestId,_that.assignments,_that.totalAssigned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  List<HarmonicAssignmentDto> assignments,  int totalAssigned)  $default,) {final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse():
return $default(_that.requestId,_that.assignments,_that.totalAssigned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  List<HarmonicAssignmentDto> assignments,  int totalAssigned)?  $default,) {final _that = this;
switch (_that) {
case _GenerateHarmonicsResponse() when $default != null:
return $default(_that.requestId,_that.assignments,_that.totalAssigned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateHarmonicsResponse implements GenerateHarmonicsResponse {
  const _GenerateHarmonicsResponse({required this.requestId, required final  List<HarmonicAssignmentDto> assignments, required this.totalAssigned}): _assignments = assignments;
  factory _GenerateHarmonicsResponse.fromJson(Map<String, dynamic> json) => _$GenerateHarmonicsResponseFromJson(json);

@override final  String requestId;
 final  List<HarmonicAssignmentDto> _assignments;
@override List<HarmonicAssignmentDto> get assignments {
  if (_assignments is EqualUnmodifiableListView) return _assignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignments);
}

@override final  int totalAssigned;

/// Create a copy of GenerateHarmonicsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateHarmonicsResponseCopyWith<_GenerateHarmonicsResponse> get copyWith => __$GenerateHarmonicsResponseCopyWithImpl<_GenerateHarmonicsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateHarmonicsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateHarmonicsResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other._assignments, _assignments)&&(identical(other.totalAssigned, totalAssigned) || other.totalAssigned == totalAssigned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,const DeepCollectionEquality().hash(_assignments),totalAssigned);

@override
String toString() {
  return 'GenerateHarmonicsResponse(requestId: $requestId, assignments: $assignments, totalAssigned: $totalAssigned)';
}


}

/// @nodoc
abstract mixin class _$GenerateHarmonicsResponseCopyWith<$Res> implements $GenerateHarmonicsResponseCopyWith<$Res> {
  factory _$GenerateHarmonicsResponseCopyWith(_GenerateHarmonicsResponse value, $Res Function(_GenerateHarmonicsResponse) _then) = __$GenerateHarmonicsResponseCopyWithImpl;
@override @useResult
$Res call({
 String requestId, List<HarmonicAssignmentDto> assignments, int totalAssigned
});




}
/// @nodoc
class __$GenerateHarmonicsResponseCopyWithImpl<$Res>
    implements _$GenerateHarmonicsResponseCopyWith<$Res> {
  __$GenerateHarmonicsResponseCopyWithImpl(this._self, this._then);

  final _GenerateHarmonicsResponse _self;
  final $Res Function(_GenerateHarmonicsResponse) _then;

/// Create a copy of GenerateHarmonicsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? assignments = null,Object? totalAssigned = null,}) {
  return _then(_GenerateHarmonicsResponse(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,assignments: null == assignments ? _self._assignments : assignments // ignore: cast_nullable_to_non_nullable
as List<HarmonicAssignmentDto>,totalAssigned: null == totalAssigned ? _self.totalAssigned : totalAssigned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
