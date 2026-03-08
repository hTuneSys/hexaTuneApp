// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reorder_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReorderEntry {

 String get itemId; int get sortOrder;
/// Create a copy of ReorderEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderEntryCopyWith<ReorderEntry> get copyWith => _$ReorderEntryCopyWithImpl<ReorderEntry>(this as ReorderEntry, _$identity);

  /// Serializes this ReorderEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderEntry&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,sortOrder);

@override
String toString() {
  return 'ReorderEntry(itemId: $itemId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ReorderEntryCopyWith<$Res>  {
  factory $ReorderEntryCopyWith(ReorderEntry value, $Res Function(ReorderEntry) _then) = _$ReorderEntryCopyWithImpl;
@useResult
$Res call({
 String itemId, int sortOrder
});




}
/// @nodoc
class _$ReorderEntryCopyWithImpl<$Res>
    implements $ReorderEntryCopyWith<$Res> {
  _$ReorderEntryCopyWithImpl(this._self, this._then);

  final ReorderEntry _self;
  final $Res Function(ReorderEntry) _then;

/// Create a copy of ReorderEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderEntry].
extension ReorderEntryPatterns on ReorderEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderEntry value)  $default,){
final _that = this;
switch (_that) {
case _ReorderEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderEntry() when $default != null:
return $default(_that.itemId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ReorderEntry():
return $default(_that.itemId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ReorderEntry() when $default != null:
return $default(_that.itemId,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderEntry implements ReorderEntry {
  const _ReorderEntry({required this.itemId, required this.sortOrder});
  factory _ReorderEntry.fromJson(Map<String, dynamic> json) => _$ReorderEntryFromJson(json);

@override final  String itemId;
@override final  int sortOrder;

/// Create a copy of ReorderEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderEntryCopyWith<_ReorderEntry> get copyWith => __$ReorderEntryCopyWithImpl<_ReorderEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderEntry&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,sortOrder);

@override
String toString() {
  return 'ReorderEntry(itemId: $itemId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ReorderEntryCopyWith<$Res> implements $ReorderEntryCopyWith<$Res> {
  factory _$ReorderEntryCopyWith(_ReorderEntry value, $Res Function(_ReorderEntry) _then) = __$ReorderEntryCopyWithImpl;
@override @useResult
$Res call({
 String itemId, int sortOrder
});




}
/// @nodoc
class __$ReorderEntryCopyWithImpl<$Res>
    implements _$ReorderEntryCopyWith<$Res> {
  __$ReorderEntryCopyWithImpl(this._self, this._then);

  final _ReorderEntry _self;
  final $Res Function(_ReorderEntry) _then;

/// Create a copy of ReorderEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? sortOrder = null,}) {
  return _then(_ReorderEntry(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
