// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generate_harmonics_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenerateHarmonicsRequest {

/// The generation type (Monaural, Binaural, Magnetic, Photonic, Quantal).
 String get generationType;/// The source type (Flow, Formula, Inventory).
 String get sourceType;/// The source identifier. For Formula/Flow this is the formula/flow ID.
/// For Inventory this is a client-generated tracking UUID.
 String get sourceId;/// Optional list of inventory IDs. Required when sourceType is Inventory.
/// Maximum 10 items; duplicates are deduplicated server-side.
 List<String>? get inventoryIds;
/// Create a copy of GenerateHarmonicsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateHarmonicsRequestCopyWith<GenerateHarmonicsRequest> get copyWith => _$GenerateHarmonicsRequestCopyWithImpl<GenerateHarmonicsRequest>(this as GenerateHarmonicsRequest, _$identity);

  /// Serializes this GenerateHarmonicsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateHarmonicsRequest&&(identical(other.generationType, generationType) || other.generationType == generationType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other.inventoryIds, inventoryIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generationType,sourceType,sourceId,const DeepCollectionEquality().hash(inventoryIds));

@override
String toString() {
  return 'GenerateHarmonicsRequest(generationType: $generationType, sourceType: $sourceType, sourceId: $sourceId, inventoryIds: $inventoryIds)';
}


}

/// @nodoc
abstract mixin class $GenerateHarmonicsRequestCopyWith<$Res>  {
  factory $GenerateHarmonicsRequestCopyWith(GenerateHarmonicsRequest value, $Res Function(GenerateHarmonicsRequest) _then) = _$GenerateHarmonicsRequestCopyWithImpl;
@useResult
$Res call({
 String generationType, String sourceType, String sourceId, List<String>? inventoryIds
});




}
/// @nodoc
class _$GenerateHarmonicsRequestCopyWithImpl<$Res>
    implements $GenerateHarmonicsRequestCopyWith<$Res> {
  _$GenerateHarmonicsRequestCopyWithImpl(this._self, this._then);

  final GenerateHarmonicsRequest _self;
  final $Res Function(GenerateHarmonicsRequest) _then;

/// Create a copy of GenerateHarmonicsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generationType = null,Object? sourceType = null,Object? sourceId = null,Object? inventoryIds = freezed,}) {
  return _then(_self.copyWith(
generationType: null == generationType ? _self.generationType : generationType // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,inventoryIds: freezed == inventoryIds ? _self.inventoryIds : inventoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateHarmonicsRequest].
extension GenerateHarmonicsRequestPatterns on GenerateHarmonicsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateHarmonicsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateHarmonicsRequest value)  $default,){
final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateHarmonicsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String generationType,  String sourceType,  String sourceId,  List<String>? inventoryIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest() when $default != null:
return $default(_that.generationType,_that.sourceType,_that.sourceId,_that.inventoryIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String generationType,  String sourceType,  String sourceId,  List<String>? inventoryIds)  $default,) {final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest():
return $default(_that.generationType,_that.sourceType,_that.sourceId,_that.inventoryIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String generationType,  String sourceType,  String sourceId,  List<String>? inventoryIds)?  $default,) {final _that = this;
switch (_that) {
case _GenerateHarmonicsRequest() when $default != null:
return $default(_that.generationType,_that.sourceType,_that.sourceId,_that.inventoryIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateHarmonicsRequest implements GenerateHarmonicsRequest {
  const _GenerateHarmonicsRequest({required this.generationType, required this.sourceType, required this.sourceId, final  List<String>? inventoryIds}): _inventoryIds = inventoryIds;
  factory _GenerateHarmonicsRequest.fromJson(Map<String, dynamic> json) => _$GenerateHarmonicsRequestFromJson(json);

/// The generation type (Monaural, Binaural, Magnetic, Photonic, Quantal).
@override final  String generationType;
/// The source type (Flow, Formula, Inventory).
@override final  String sourceType;
/// The source identifier. For Formula/Flow this is the formula/flow ID.
/// For Inventory this is a client-generated tracking UUID.
@override final  String sourceId;
/// Optional list of inventory IDs. Required when sourceType is Inventory.
/// Maximum 10 items; duplicates are deduplicated server-side.
 final  List<String>? _inventoryIds;
/// Optional list of inventory IDs. Required when sourceType is Inventory.
/// Maximum 10 items; duplicates are deduplicated server-side.
@override List<String>? get inventoryIds {
  final value = _inventoryIds;
  if (value == null) return null;
  if (_inventoryIds is EqualUnmodifiableListView) return _inventoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GenerateHarmonicsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateHarmonicsRequestCopyWith<_GenerateHarmonicsRequest> get copyWith => __$GenerateHarmonicsRequestCopyWithImpl<_GenerateHarmonicsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateHarmonicsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateHarmonicsRequest&&(identical(other.generationType, generationType) || other.generationType == generationType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other._inventoryIds, _inventoryIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generationType,sourceType,sourceId,const DeepCollectionEquality().hash(_inventoryIds));

@override
String toString() {
  return 'GenerateHarmonicsRequest(generationType: $generationType, sourceType: $sourceType, sourceId: $sourceId, inventoryIds: $inventoryIds)';
}


}

/// @nodoc
abstract mixin class _$GenerateHarmonicsRequestCopyWith<$Res> implements $GenerateHarmonicsRequestCopyWith<$Res> {
  factory _$GenerateHarmonicsRequestCopyWith(_GenerateHarmonicsRequest value, $Res Function(_GenerateHarmonicsRequest) _then) = __$GenerateHarmonicsRequestCopyWithImpl;
@override @useResult
$Res call({
 String generationType, String sourceType, String sourceId, List<String>? inventoryIds
});




}
/// @nodoc
class __$GenerateHarmonicsRequestCopyWithImpl<$Res>
    implements _$GenerateHarmonicsRequestCopyWith<$Res> {
  __$GenerateHarmonicsRequestCopyWithImpl(this._self, this._then);

  final _GenerateHarmonicsRequest _self;
  final $Res Function(_GenerateHarmonicsRequest) _then;

/// Create a copy of GenerateHarmonicsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generationType = null,Object? sourceType = null,Object? sourceId = null,Object? inventoryIds = freezed,}) {
  return _then(_GenerateHarmonicsRequest(
generationType: null == generationType ? _self.generationType : generationType // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,inventoryIds: freezed == inventoryIds ? _self._inventoryIds : inventoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
