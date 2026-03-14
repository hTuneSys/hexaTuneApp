// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ambience_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AmbienceConfig {

/// Unique identifier (UUID v4).
 String get id;/// User-given display name.
 String get name;/// Selected base layer asset ID (from sounds_catalog.json), or null.
 String? get baseAssetId;/// Selected texture layer asset IDs (0 to maxTextureLayers).
 List<String> get textureAssetIds;/// Selected event layer asset IDs (0 to maxEventSlots).
 List<String> get eventAssetIds;/// Base layer gain (0.0–1.0).
 double get baseGain;/// Texture layer gain (0.0–1.0).
 double get textureGain;/// Event layer gain (0.0–1.0).
 double get eventGain;/// Master output gain (0.0–1.0).
 double get masterGain;/// ISO 8601 creation timestamp.
 String get createdAt;/// ISO 8601 last-updated timestamp.
 String get updatedAt;
/// Create a copy of AmbienceConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmbienceConfigCopyWith<AmbienceConfig> get copyWith => _$AmbienceConfigCopyWithImpl<AmbienceConfig>(this as AmbienceConfig, _$identity);

  /// Serializes this AmbienceConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AmbienceConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.baseAssetId, baseAssetId) || other.baseAssetId == baseAssetId)&&const DeepCollectionEquality().equals(other.textureAssetIds, textureAssetIds)&&const DeepCollectionEquality().equals(other.eventAssetIds, eventAssetIds)&&(identical(other.baseGain, baseGain) || other.baseGain == baseGain)&&(identical(other.textureGain, textureGain) || other.textureGain == textureGain)&&(identical(other.eventGain, eventGain) || other.eventGain == eventGain)&&(identical(other.masterGain, masterGain) || other.masterGain == masterGain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,baseAssetId,const DeepCollectionEquality().hash(textureAssetIds),const DeepCollectionEquality().hash(eventAssetIds),baseGain,textureGain,eventGain,masterGain,createdAt,updatedAt);

@override
String toString() {
  return 'AmbienceConfig(id: $id, name: $name, baseAssetId: $baseAssetId, textureAssetIds: $textureAssetIds, eventAssetIds: $eventAssetIds, baseGain: $baseGain, textureGain: $textureGain, eventGain: $eventGain, masterGain: $masterGain, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AmbienceConfigCopyWith<$Res>  {
  factory $AmbienceConfigCopyWith(AmbienceConfig value, $Res Function(AmbienceConfig) _then) = _$AmbienceConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? baseAssetId, List<String> textureAssetIds, List<String> eventAssetIds, double baseGain, double textureGain, double eventGain, double masterGain, String createdAt, String updatedAt
});




}
/// @nodoc
class _$AmbienceConfigCopyWithImpl<$Res>
    implements $AmbienceConfigCopyWith<$Res> {
  _$AmbienceConfigCopyWithImpl(this._self, this._then);

  final AmbienceConfig _self;
  final $Res Function(AmbienceConfig) _then;

/// Create a copy of AmbienceConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? baseAssetId = freezed,Object? textureAssetIds = null,Object? eventAssetIds = null,Object? baseGain = null,Object? textureGain = null,Object? eventGain = null,Object? masterGain = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseAssetId: freezed == baseAssetId ? _self.baseAssetId : baseAssetId // ignore: cast_nullable_to_non_nullable
as String?,textureAssetIds: null == textureAssetIds ? _self.textureAssetIds : textureAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,eventAssetIds: null == eventAssetIds ? _self.eventAssetIds : eventAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,baseGain: null == baseGain ? _self.baseGain : baseGain // ignore: cast_nullable_to_non_nullable
as double,textureGain: null == textureGain ? _self.textureGain : textureGain // ignore: cast_nullable_to_non_nullable
as double,eventGain: null == eventGain ? _self.eventGain : eventGain // ignore: cast_nullable_to_non_nullable
as double,masterGain: null == masterGain ? _self.masterGain : masterGain // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AmbienceConfig].
extension AmbienceConfigPatterns on AmbienceConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AmbienceConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AmbienceConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AmbienceConfig value)  $default,){
final _that = this;
switch (_that) {
case _AmbienceConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AmbienceConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AmbienceConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? baseAssetId,  List<String> textureAssetIds,  List<String> eventAssetIds,  double baseGain,  double textureGain,  double eventGain,  double masterGain,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AmbienceConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseAssetId,_that.textureAssetIds,_that.eventAssetIds,_that.baseGain,_that.textureGain,_that.eventGain,_that.masterGain,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? baseAssetId,  List<String> textureAssetIds,  List<String> eventAssetIds,  double baseGain,  double textureGain,  double eventGain,  double masterGain,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AmbienceConfig():
return $default(_that.id,_that.name,_that.baseAssetId,_that.textureAssetIds,_that.eventAssetIds,_that.baseGain,_that.textureGain,_that.eventGain,_that.masterGain,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? baseAssetId,  List<String> textureAssetIds,  List<String> eventAssetIds,  double baseGain,  double textureGain,  double eventGain,  double masterGain,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AmbienceConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseAssetId,_that.textureAssetIds,_that.eventAssetIds,_that.baseGain,_that.textureGain,_that.eventGain,_that.masterGain,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AmbienceConfig implements AmbienceConfig {
  const _AmbienceConfig({required this.id, required this.name, this.baseAssetId, final  List<String> textureAssetIds = const [], final  List<String> eventAssetIds = const [], this.baseGain = 0.6, this.textureGain = 0.3, this.eventGain = 0.4, this.masterGain = 1.0, required this.createdAt, required this.updatedAt}): _textureAssetIds = textureAssetIds,_eventAssetIds = eventAssetIds;
  factory _AmbienceConfig.fromJson(Map<String, dynamic> json) => _$AmbienceConfigFromJson(json);

/// Unique identifier (UUID v4).
@override final  String id;
/// User-given display name.
@override final  String name;
/// Selected base layer asset ID (from sounds_catalog.json), or null.
@override final  String? baseAssetId;
/// Selected texture layer asset IDs (0 to maxTextureLayers).
 final  List<String> _textureAssetIds;
/// Selected texture layer asset IDs (0 to maxTextureLayers).
@override@JsonKey() List<String> get textureAssetIds {
  if (_textureAssetIds is EqualUnmodifiableListView) return _textureAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textureAssetIds);
}

/// Selected event layer asset IDs (0 to maxEventSlots).
 final  List<String> _eventAssetIds;
/// Selected event layer asset IDs (0 to maxEventSlots).
@override@JsonKey() List<String> get eventAssetIds {
  if (_eventAssetIds is EqualUnmodifiableListView) return _eventAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eventAssetIds);
}

/// Base layer gain (0.0–1.0).
@override@JsonKey() final  double baseGain;
/// Texture layer gain (0.0–1.0).
@override@JsonKey() final  double textureGain;
/// Event layer gain (0.0–1.0).
@override@JsonKey() final  double eventGain;
/// Master output gain (0.0–1.0).
@override@JsonKey() final  double masterGain;
/// ISO 8601 creation timestamp.
@override final  String createdAt;
/// ISO 8601 last-updated timestamp.
@override final  String updatedAt;

/// Create a copy of AmbienceConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmbienceConfigCopyWith<_AmbienceConfig> get copyWith => __$AmbienceConfigCopyWithImpl<_AmbienceConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AmbienceConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmbienceConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.baseAssetId, baseAssetId) || other.baseAssetId == baseAssetId)&&const DeepCollectionEquality().equals(other._textureAssetIds, _textureAssetIds)&&const DeepCollectionEquality().equals(other._eventAssetIds, _eventAssetIds)&&(identical(other.baseGain, baseGain) || other.baseGain == baseGain)&&(identical(other.textureGain, textureGain) || other.textureGain == textureGain)&&(identical(other.eventGain, eventGain) || other.eventGain == eventGain)&&(identical(other.masterGain, masterGain) || other.masterGain == masterGain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,baseAssetId,const DeepCollectionEquality().hash(_textureAssetIds),const DeepCollectionEquality().hash(_eventAssetIds),baseGain,textureGain,eventGain,masterGain,createdAt,updatedAt);

@override
String toString() {
  return 'AmbienceConfig(id: $id, name: $name, baseAssetId: $baseAssetId, textureAssetIds: $textureAssetIds, eventAssetIds: $eventAssetIds, baseGain: $baseGain, textureGain: $textureGain, eventGain: $eventGain, masterGain: $masterGain, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AmbienceConfigCopyWith<$Res> implements $AmbienceConfigCopyWith<$Res> {
  factory _$AmbienceConfigCopyWith(_AmbienceConfig value, $Res Function(_AmbienceConfig) _then) = __$AmbienceConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? baseAssetId, List<String> textureAssetIds, List<String> eventAssetIds, double baseGain, double textureGain, double eventGain, double masterGain, String createdAt, String updatedAt
});




}
/// @nodoc
class __$AmbienceConfigCopyWithImpl<$Res>
    implements _$AmbienceConfigCopyWith<$Res> {
  __$AmbienceConfigCopyWithImpl(this._self, this._then);

  final _AmbienceConfig _self;
  final $Res Function(_AmbienceConfig) _then;

/// Create a copy of AmbienceConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? baseAssetId = freezed,Object? textureAssetIds = null,Object? eventAssetIds = null,Object? baseGain = null,Object? textureGain = null,Object? eventGain = null,Object? masterGain = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AmbienceConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseAssetId: freezed == baseAssetId ? _self.baseAssetId : baseAssetId // ignore: cast_nullable_to_non_nullable
as String?,textureAssetIds: null == textureAssetIds ? _self._textureAssetIds : textureAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,eventAssetIds: null == eventAssetIds ? _self._eventAssetIds : eventAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,baseGain: null == baseGain ? _self.baseGain : baseGain // ignore: cast_nullable_to_non_nullable
as double,textureGain: null == textureGain ? _self.textureGain : textureGain // ignore: cast_nullable_to_non_nullable
as double,eventGain: null == eventGain ? _self.eventGain : eventGain // ignore: cast_nullable_to_non_nullable
as double,masterGain: null == masterGain ? _self.masterGain : masterGain // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
