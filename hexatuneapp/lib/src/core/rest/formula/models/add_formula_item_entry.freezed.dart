// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_formula_item_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddFormulaItemEntry {

 String get inventoryId;/// Quantity (defaults to 1 if not provided, min 1, max 60).
 int? get quantity;/// Sort order (defaults to 0 if not provided, must be non-negative).
 int? get sortOrder;
/// Create a copy of AddFormulaItemEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddFormulaItemEntryCopyWith<AddFormulaItemEntry> get copyWith => _$AddFormulaItemEntryCopyWithImpl<AddFormulaItemEntry>(this as AddFormulaItemEntry, _$identity);

  /// Serializes this AddFormulaItemEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddFormulaItemEntry&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,quantity,sortOrder);

@override
String toString() {
  return 'AddFormulaItemEntry(inventoryId: $inventoryId, quantity: $quantity, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $AddFormulaItemEntryCopyWith<$Res>  {
  factory $AddFormulaItemEntryCopyWith(AddFormulaItemEntry value, $Res Function(AddFormulaItemEntry) _then) = _$AddFormulaItemEntryCopyWithImpl;
@useResult
$Res call({
 String inventoryId, int? quantity, int? sortOrder
});




}
/// @nodoc
class _$AddFormulaItemEntryCopyWithImpl<$Res>
    implements $AddFormulaItemEntryCopyWith<$Res> {
  _$AddFormulaItemEntryCopyWithImpl(this._self, this._then);

  final AddFormulaItemEntry _self;
  final $Res Function(AddFormulaItemEntry) _then;

/// Create a copy of AddFormulaItemEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventoryId = null,Object? quantity = freezed,Object? sortOrder = freezed,}) {
  return _then(_self.copyWith(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddFormulaItemEntry].
extension AddFormulaItemEntryPatterns on AddFormulaItemEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddFormulaItemEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddFormulaItemEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddFormulaItemEntry value)  $default,){
final _that = this;
switch (_that) {
case _AddFormulaItemEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddFormulaItemEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AddFormulaItemEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inventoryId,  int? quantity,  int? sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddFormulaItemEntry() when $default != null:
return $default(_that.inventoryId,_that.quantity,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inventoryId,  int? quantity,  int? sortOrder)  $default,) {final _that = this;
switch (_that) {
case _AddFormulaItemEntry():
return $default(_that.inventoryId,_that.quantity,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inventoryId,  int? quantity,  int? sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _AddFormulaItemEntry() when $default != null:
return $default(_that.inventoryId,_that.quantity,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddFormulaItemEntry implements AddFormulaItemEntry {
  const _AddFormulaItemEntry({required this.inventoryId, this.quantity, this.sortOrder});
  factory _AddFormulaItemEntry.fromJson(Map<String, dynamic> json) => _$AddFormulaItemEntryFromJson(json);

@override final  String inventoryId;
/// Quantity (defaults to 1 if not provided, min 1, max 60).
@override final  int? quantity;
/// Sort order (defaults to 0 if not provided, must be non-negative).
@override final  int? sortOrder;

/// Create a copy of AddFormulaItemEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddFormulaItemEntryCopyWith<_AddFormulaItemEntry> get copyWith => __$AddFormulaItemEntryCopyWithImpl<_AddFormulaItemEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddFormulaItemEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddFormulaItemEntry&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,quantity,sortOrder);

@override
String toString() {
  return 'AddFormulaItemEntry(inventoryId: $inventoryId, quantity: $quantity, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$AddFormulaItemEntryCopyWith<$Res> implements $AddFormulaItemEntryCopyWith<$Res> {
  factory _$AddFormulaItemEntryCopyWith(_AddFormulaItemEntry value, $Res Function(_AddFormulaItemEntry) _then) = __$AddFormulaItemEntryCopyWithImpl;
@override @useResult
$Res call({
 String inventoryId, int? quantity, int? sortOrder
});




}
/// @nodoc
class __$AddFormulaItemEntryCopyWithImpl<$Res>
    implements _$AddFormulaItemEntryCopyWith<$Res> {
  __$AddFormulaItemEntryCopyWithImpl(this._self, this._then);

  final _AddFormulaItemEntry _self;
  final $Res Function(_AddFormulaItemEntry) _then;

/// Create a copy of AddFormulaItemEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventoryId = null,Object? quantity = freezed,Object? sortOrder = freezed,}) {
  return _then(_AddFormulaItemEntry(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
