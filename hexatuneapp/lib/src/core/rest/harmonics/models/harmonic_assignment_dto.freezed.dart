// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harmonic_assignment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HarmonicAssignmentDto {

 String get inventoryId; int get harmonicNumber; String get assignedAt;
/// Create a copy of HarmonicAssignmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarmonicAssignmentDtoCopyWith<HarmonicAssignmentDto> get copyWith => _$HarmonicAssignmentDtoCopyWithImpl<HarmonicAssignmentDto>(this as HarmonicAssignmentDto, _$identity);

  /// Serializes this HarmonicAssignmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarmonicAssignmentDto&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.harmonicNumber, harmonicNumber) || other.harmonicNumber == harmonicNumber)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,harmonicNumber,assignedAt);

@override
String toString() {
  return 'HarmonicAssignmentDto(inventoryId: $inventoryId, harmonicNumber: $harmonicNumber, assignedAt: $assignedAt)';
}


}

/// @nodoc
abstract mixin class $HarmonicAssignmentDtoCopyWith<$Res>  {
  factory $HarmonicAssignmentDtoCopyWith(HarmonicAssignmentDto value, $Res Function(HarmonicAssignmentDto) _then) = _$HarmonicAssignmentDtoCopyWithImpl;
@useResult
$Res call({
 String inventoryId, int harmonicNumber, String assignedAt
});




}
/// @nodoc
class _$HarmonicAssignmentDtoCopyWithImpl<$Res>
    implements $HarmonicAssignmentDtoCopyWith<$Res> {
  _$HarmonicAssignmentDtoCopyWithImpl(this._self, this._then);

  final HarmonicAssignmentDto _self;
  final $Res Function(HarmonicAssignmentDto) _then;

/// Create a copy of HarmonicAssignmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventoryId = null,Object? harmonicNumber = null,Object? assignedAt = null,}) {
  return _then(_self.copyWith(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,harmonicNumber: null == harmonicNumber ? _self.harmonicNumber : harmonicNumber // ignore: cast_nullable_to_non_nullable
as int,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HarmonicAssignmentDto].
extension HarmonicAssignmentDtoPatterns on HarmonicAssignmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarmonicAssignmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarmonicAssignmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarmonicAssignmentDto value)  $default,){
final _that = this;
switch (_that) {
case _HarmonicAssignmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarmonicAssignmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _HarmonicAssignmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inventoryId,  int harmonicNumber,  String assignedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarmonicAssignmentDto() when $default != null:
return $default(_that.inventoryId,_that.harmonicNumber,_that.assignedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inventoryId,  int harmonicNumber,  String assignedAt)  $default,) {final _that = this;
switch (_that) {
case _HarmonicAssignmentDto():
return $default(_that.inventoryId,_that.harmonicNumber,_that.assignedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inventoryId,  int harmonicNumber,  String assignedAt)?  $default,) {final _that = this;
switch (_that) {
case _HarmonicAssignmentDto() when $default != null:
return $default(_that.inventoryId,_that.harmonicNumber,_that.assignedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarmonicAssignmentDto implements HarmonicAssignmentDto {
  const _HarmonicAssignmentDto({required this.inventoryId, required this.harmonicNumber, required this.assignedAt});
  factory _HarmonicAssignmentDto.fromJson(Map<String, dynamic> json) => _$HarmonicAssignmentDtoFromJson(json);

@override final  String inventoryId;
@override final  int harmonicNumber;
@override final  String assignedAt;

/// Create a copy of HarmonicAssignmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarmonicAssignmentDtoCopyWith<_HarmonicAssignmentDto> get copyWith => __$HarmonicAssignmentDtoCopyWithImpl<_HarmonicAssignmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarmonicAssignmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarmonicAssignmentDto&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.harmonicNumber, harmonicNumber) || other.harmonicNumber == harmonicNumber)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,harmonicNumber,assignedAt);

@override
String toString() {
  return 'HarmonicAssignmentDto(inventoryId: $inventoryId, harmonicNumber: $harmonicNumber, assignedAt: $assignedAt)';
}


}

/// @nodoc
abstract mixin class _$HarmonicAssignmentDtoCopyWith<$Res> implements $HarmonicAssignmentDtoCopyWith<$Res> {
  factory _$HarmonicAssignmentDtoCopyWith(_HarmonicAssignmentDto value, $Res Function(_HarmonicAssignmentDto) _then) = __$HarmonicAssignmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String inventoryId, int harmonicNumber, String assignedAt
});




}
/// @nodoc
class __$HarmonicAssignmentDtoCopyWithImpl<$Res>
    implements _$HarmonicAssignmentDtoCopyWith<$Res> {
  __$HarmonicAssignmentDtoCopyWithImpl(this._self, this._then);

  final _HarmonicAssignmentDto _self;
  final $Res Function(_HarmonicAssignmentDto) _then;

/// Create a copy of HarmonicAssignmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventoryId = null,Object? harmonicNumber = null,Object? assignedAt = null,}) {
  return _then(_HarmonicAssignmentDto(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,harmonicNumber: null == harmonicNumber ? _self.harmonicNumber : harmonicNumber // ignore: cast_nullable_to_non_nullable
as int,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
