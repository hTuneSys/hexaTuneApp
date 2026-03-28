// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harmonize_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryInventoryItem {

 String get id; String get name;
/// Create a copy of HistoryInventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryInventoryItemCopyWith<HistoryInventoryItem> get copyWith => _$HistoryInventoryItemCopyWithImpl<HistoryInventoryItem>(this as HistoryInventoryItem, _$identity);

  /// Serializes this HistoryInventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryInventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'HistoryInventoryItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $HistoryInventoryItemCopyWith<$Res>  {
  factory $HistoryInventoryItemCopyWith(HistoryInventoryItem value, $Res Function(HistoryInventoryItem) _then) = _$HistoryInventoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$HistoryInventoryItemCopyWithImpl<$Res>
    implements $HistoryInventoryItemCopyWith<$Res> {
  _$HistoryInventoryItemCopyWithImpl(this._self, this._then);

  final HistoryInventoryItem _self;
  final $Res Function(HistoryInventoryItem) _then;

/// Create a copy of HistoryInventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryInventoryItem].
extension HistoryInventoryItemPatterns on HistoryInventoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryInventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryInventoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryInventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _HistoryInventoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryInventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryInventoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryInventoryItem() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _HistoryInventoryItem():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _HistoryInventoryItem() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryInventoryItem implements HistoryInventoryItem {
  const _HistoryInventoryItem({required this.id, required this.name});
  factory _HistoryInventoryItem.fromJson(Map<String, dynamic> json) => _$HistoryInventoryItemFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of HistoryInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryInventoryItemCopyWith<_HistoryInventoryItem> get copyWith => __$HistoryInventoryItemCopyWithImpl<_HistoryInventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryInventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryInventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'HistoryInventoryItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$HistoryInventoryItemCopyWith<$Res> implements $HistoryInventoryItemCopyWith<$Res> {
  factory _$HistoryInventoryItemCopyWith(_HistoryInventoryItem value, $Res Function(_HistoryInventoryItem) _then) = __$HistoryInventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$HistoryInventoryItemCopyWithImpl<$Res>
    implements _$HistoryInventoryItemCopyWith<$Res> {
  __$HistoryInventoryItemCopyWithImpl(this._self, this._then);

  final _HistoryInventoryItem _self;
  final $Res Function(_HistoryInventoryItem) _then;

/// Create a copy of HistoryInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_HistoryInventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HarmonizeHistoryEntry {

/// Source type: 'Formula', 'Inventory', or 'Flow'.
 String get sourceType;/// Formula ID (when sourceType is 'Formula').
 String? get formulaId;/// Formula name (when sourceType is 'Formula').
 String? get formulaName;/// Selected inventories (when sourceType is 'Inventory').
 List<HistoryInventoryItem> get inventories;/// Flow ID (when sourceType is 'Flow', future use).
 String? get flowId;/// Generation type used (e.g. 'Monaural', 'Binaural').
 String get generationType;/// Ambience config ID if one was selected.
 String? get ambienceId;/// Ambience display name (denormalized for display without service lookup).
 String? get ambienceName;/// Repeat count (null = infinite).
 int? get repeatCount;/// ISO 8601 timestamp of when the harmonize session started.
 String get harmonizedAt;
/// Create a copy of HarmonizeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarmonizeHistoryEntryCopyWith<HarmonizeHistoryEntry> get copyWith => _$HarmonizeHistoryEntryCopyWithImpl<HarmonizeHistoryEntry>(this as HarmonizeHistoryEntry, _$identity);

  /// Serializes this HarmonizeHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarmonizeHistoryEntry&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.formulaId, formulaId) || other.formulaId == formulaId)&&(identical(other.formulaName, formulaName) || other.formulaName == formulaName)&&const DeepCollectionEquality().equals(other.inventories, inventories)&&(identical(other.flowId, flowId) || other.flowId == flowId)&&(identical(other.generationType, generationType) || other.generationType == generationType)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&(identical(other.ambienceName, ambienceName) || other.ambienceName == ambienceName)&&(identical(other.repeatCount, repeatCount) || other.repeatCount == repeatCount)&&(identical(other.harmonizedAt, harmonizedAt) || other.harmonizedAt == harmonizedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,formulaId,formulaName,const DeepCollectionEquality().hash(inventories),flowId,generationType,ambienceId,ambienceName,repeatCount,harmonizedAt);

@override
String toString() {
  return 'HarmonizeHistoryEntry(sourceType: $sourceType, formulaId: $formulaId, formulaName: $formulaName, inventories: $inventories, flowId: $flowId, generationType: $generationType, ambienceId: $ambienceId, ambienceName: $ambienceName, repeatCount: $repeatCount, harmonizedAt: $harmonizedAt)';
}


}

/// @nodoc
abstract mixin class $HarmonizeHistoryEntryCopyWith<$Res>  {
  factory $HarmonizeHistoryEntryCopyWith(HarmonizeHistoryEntry value, $Res Function(HarmonizeHistoryEntry) _then) = _$HarmonizeHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String sourceType, String? formulaId, String? formulaName, List<HistoryInventoryItem> inventories, String? flowId, String generationType, String? ambienceId, String? ambienceName, int? repeatCount, String harmonizedAt
});




}
/// @nodoc
class _$HarmonizeHistoryEntryCopyWithImpl<$Res>
    implements $HarmonizeHistoryEntryCopyWith<$Res> {
  _$HarmonizeHistoryEntryCopyWithImpl(this._self, this._then);

  final HarmonizeHistoryEntry _self;
  final $Res Function(HarmonizeHistoryEntry) _then;

/// Create a copy of HarmonizeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceType = null,Object? formulaId = freezed,Object? formulaName = freezed,Object? inventories = null,Object? flowId = freezed,Object? generationType = null,Object? ambienceId = freezed,Object? ambienceName = freezed,Object? repeatCount = freezed,Object? harmonizedAt = null,}) {
  return _then(_self.copyWith(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,formulaId: freezed == formulaId ? _self.formulaId : formulaId // ignore: cast_nullable_to_non_nullable
as String?,formulaName: freezed == formulaName ? _self.formulaName : formulaName // ignore: cast_nullable_to_non_nullable
as String?,inventories: null == inventories ? _self.inventories : inventories // ignore: cast_nullable_to_non_nullable
as List<HistoryInventoryItem>,flowId: freezed == flowId ? _self.flowId : flowId // ignore: cast_nullable_to_non_nullable
as String?,generationType: null == generationType ? _self.generationType : generationType // ignore: cast_nullable_to_non_nullable
as String,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,ambienceName: freezed == ambienceName ? _self.ambienceName : ambienceName // ignore: cast_nullable_to_non_nullable
as String?,repeatCount: freezed == repeatCount ? _self.repeatCount : repeatCount // ignore: cast_nullable_to_non_nullable
as int?,harmonizedAt: null == harmonizedAt ? _self.harmonizedAt : harmonizedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HarmonizeHistoryEntry].
extension HarmonizeHistoryEntryPatterns on HarmonizeHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarmonizeHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarmonizeHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarmonizeHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceType,  String? formulaId,  String? formulaName,  List<HistoryInventoryItem> inventories,  String? flowId,  String generationType,  String? ambienceId,  String? ambienceName,  int? repeatCount,  String harmonizedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry() when $default != null:
return $default(_that.sourceType,_that.formulaId,_that.formulaName,_that.inventories,_that.flowId,_that.generationType,_that.ambienceId,_that.ambienceName,_that.repeatCount,_that.harmonizedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceType,  String? formulaId,  String? formulaName,  List<HistoryInventoryItem> inventories,  String? flowId,  String generationType,  String? ambienceId,  String? ambienceName,  int? repeatCount,  String harmonizedAt)  $default,) {final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry():
return $default(_that.sourceType,_that.formulaId,_that.formulaName,_that.inventories,_that.flowId,_that.generationType,_that.ambienceId,_that.ambienceName,_that.repeatCount,_that.harmonizedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceType,  String? formulaId,  String? formulaName,  List<HistoryInventoryItem> inventories,  String? flowId,  String generationType,  String? ambienceId,  String? ambienceName,  int? repeatCount,  String harmonizedAt)?  $default,) {final _that = this;
switch (_that) {
case _HarmonizeHistoryEntry() when $default != null:
return $default(_that.sourceType,_that.formulaId,_that.formulaName,_that.inventories,_that.flowId,_that.generationType,_that.ambienceId,_that.ambienceName,_that.repeatCount,_that.harmonizedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarmonizeHistoryEntry implements HarmonizeHistoryEntry {
  const _HarmonizeHistoryEntry({required this.sourceType, this.formulaId, this.formulaName, final  List<HistoryInventoryItem> inventories = const [], this.flowId, required this.generationType, this.ambienceId, this.ambienceName, this.repeatCount, required this.harmonizedAt}): _inventories = inventories;
  factory _HarmonizeHistoryEntry.fromJson(Map<String, dynamic> json) => _$HarmonizeHistoryEntryFromJson(json);

/// Source type: 'Formula', 'Inventory', or 'Flow'.
@override final  String sourceType;
/// Formula ID (when sourceType is 'Formula').
@override final  String? formulaId;
/// Formula name (when sourceType is 'Formula').
@override final  String? formulaName;
/// Selected inventories (when sourceType is 'Inventory').
 final  List<HistoryInventoryItem> _inventories;
/// Selected inventories (when sourceType is 'Inventory').
@override@JsonKey() List<HistoryInventoryItem> get inventories {
  if (_inventories is EqualUnmodifiableListView) return _inventories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventories);
}

/// Flow ID (when sourceType is 'Flow', future use).
@override final  String? flowId;
/// Generation type used (e.g. 'Monaural', 'Binaural').
@override final  String generationType;
/// Ambience config ID if one was selected.
@override final  String? ambienceId;
/// Ambience display name (denormalized for display without service lookup).
@override final  String? ambienceName;
/// Repeat count (null = infinite).
@override final  int? repeatCount;
/// ISO 8601 timestamp of when the harmonize session started.
@override final  String harmonizedAt;

/// Create a copy of HarmonizeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarmonizeHistoryEntryCopyWith<_HarmonizeHistoryEntry> get copyWith => __$HarmonizeHistoryEntryCopyWithImpl<_HarmonizeHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarmonizeHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarmonizeHistoryEntry&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.formulaId, formulaId) || other.formulaId == formulaId)&&(identical(other.formulaName, formulaName) || other.formulaName == formulaName)&&const DeepCollectionEquality().equals(other._inventories, _inventories)&&(identical(other.flowId, flowId) || other.flowId == flowId)&&(identical(other.generationType, generationType) || other.generationType == generationType)&&(identical(other.ambienceId, ambienceId) || other.ambienceId == ambienceId)&&(identical(other.ambienceName, ambienceName) || other.ambienceName == ambienceName)&&(identical(other.repeatCount, repeatCount) || other.repeatCount == repeatCount)&&(identical(other.harmonizedAt, harmonizedAt) || other.harmonizedAt == harmonizedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,formulaId,formulaName,const DeepCollectionEquality().hash(_inventories),flowId,generationType,ambienceId,ambienceName,repeatCount,harmonizedAt);

@override
String toString() {
  return 'HarmonizeHistoryEntry(sourceType: $sourceType, formulaId: $formulaId, formulaName: $formulaName, inventories: $inventories, flowId: $flowId, generationType: $generationType, ambienceId: $ambienceId, ambienceName: $ambienceName, repeatCount: $repeatCount, harmonizedAt: $harmonizedAt)';
}


}

/// @nodoc
abstract mixin class _$HarmonizeHistoryEntryCopyWith<$Res> implements $HarmonizeHistoryEntryCopyWith<$Res> {
  factory _$HarmonizeHistoryEntryCopyWith(_HarmonizeHistoryEntry value, $Res Function(_HarmonizeHistoryEntry) _then) = __$HarmonizeHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String sourceType, String? formulaId, String? formulaName, List<HistoryInventoryItem> inventories, String? flowId, String generationType, String? ambienceId, String? ambienceName, int? repeatCount, String harmonizedAt
});




}
/// @nodoc
class __$HarmonizeHistoryEntryCopyWithImpl<$Res>
    implements _$HarmonizeHistoryEntryCopyWith<$Res> {
  __$HarmonizeHistoryEntryCopyWithImpl(this._self, this._then);

  final _HarmonizeHistoryEntry _self;
  final $Res Function(_HarmonizeHistoryEntry) _then;

/// Create a copy of HarmonizeHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceType = null,Object? formulaId = freezed,Object? formulaName = freezed,Object? inventories = null,Object? flowId = freezed,Object? generationType = null,Object? ambienceId = freezed,Object? ambienceName = freezed,Object? repeatCount = freezed,Object? harmonizedAt = null,}) {
  return _then(_HarmonizeHistoryEntry(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,formulaId: freezed == formulaId ? _self.formulaId : formulaId // ignore: cast_nullable_to_non_nullable
as String?,formulaName: freezed == formulaName ? _self.formulaName : formulaName // ignore: cast_nullable_to_non_nullable
as String?,inventories: null == inventories ? _self._inventories : inventories // ignore: cast_nullable_to_non_nullable
as List<HistoryInventoryItem>,flowId: freezed == flowId ? _self.flowId : flowId // ignore: cast_nullable_to_non_nullable
as String?,generationType: null == generationType ? _self.generationType : generationType // ignore: cast_nullable_to_non_nullable
as String,ambienceId: freezed == ambienceId ? _self.ambienceId : ambienceId // ignore: cast_nullable_to_non_nullable
as String?,ambienceName: freezed == ambienceName ? _self.ambienceName : ambienceName // ignore: cast_nullable_to_non_nullable
as String?,repeatCount: freezed == repeatCount ? _self.repeatCount : repeatCount // ignore: cast_nullable_to_non_nullable
as int?,harmonizedAt: null == harmonizedAt ? _self.harmonizedAt : harmonizedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
