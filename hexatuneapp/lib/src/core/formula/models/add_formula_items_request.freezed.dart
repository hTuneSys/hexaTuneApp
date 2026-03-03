// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_formula_items_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddFormulaItemsRequest {

 List<AddFormulaItemEntry> get items;
/// Create a copy of AddFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddFormulaItemsRequestCopyWith<AddFormulaItemsRequest> get copyWith => _$AddFormulaItemsRequestCopyWithImpl<AddFormulaItemsRequest>(this as AddFormulaItemsRequest, _$identity);

  /// Serializes this AddFormulaItemsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddFormulaItemsRequest&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'AddFormulaItemsRequest(items: $items)';
}


}

/// @nodoc
abstract mixin class $AddFormulaItemsRequestCopyWith<$Res>  {
  factory $AddFormulaItemsRequestCopyWith(AddFormulaItemsRequest value, $Res Function(AddFormulaItemsRequest) _then) = _$AddFormulaItemsRequestCopyWithImpl;
@useResult
$Res call({
 List<AddFormulaItemEntry> items
});




}
/// @nodoc
class _$AddFormulaItemsRequestCopyWithImpl<$Res>
    implements $AddFormulaItemsRequestCopyWith<$Res> {
  _$AddFormulaItemsRequestCopyWithImpl(this._self, this._then);

  final AddFormulaItemsRequest _self;
  final $Res Function(AddFormulaItemsRequest) _then;

/// Create a copy of AddFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AddFormulaItemEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddFormulaItemsRequest].
extension AddFormulaItemsRequestPatterns on AddFormulaItemsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddFormulaItemsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddFormulaItemsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddFormulaItemsRequest value)  $default,){
final _that = this;
switch (_that) {
case _AddFormulaItemsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddFormulaItemsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AddFormulaItemsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AddFormulaItemEntry> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddFormulaItemsRequest() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AddFormulaItemEntry> items)  $default,) {final _that = this;
switch (_that) {
case _AddFormulaItemsRequest():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AddFormulaItemEntry> items)?  $default,) {final _that = this;
switch (_that) {
case _AddFormulaItemsRequest() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddFormulaItemsRequest implements AddFormulaItemsRequest {
  const _AddFormulaItemsRequest({required final  List<AddFormulaItemEntry> items}): _items = items;
  factory _AddFormulaItemsRequest.fromJson(Map<String, dynamic> json) => _$AddFormulaItemsRequestFromJson(json);

 final  List<AddFormulaItemEntry> _items;
@override List<AddFormulaItemEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of AddFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddFormulaItemsRequestCopyWith<_AddFormulaItemsRequest> get copyWith => __$AddFormulaItemsRequestCopyWithImpl<_AddFormulaItemsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddFormulaItemsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddFormulaItemsRequest&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'AddFormulaItemsRequest(items: $items)';
}


}

/// @nodoc
abstract mixin class _$AddFormulaItemsRequestCopyWith<$Res> implements $AddFormulaItemsRequestCopyWith<$Res> {
  factory _$AddFormulaItemsRequestCopyWith(_AddFormulaItemsRequest value, $Res Function(_AddFormulaItemsRequest) _then) = __$AddFormulaItemsRequestCopyWithImpl;
@override @useResult
$Res call({
 List<AddFormulaItemEntry> items
});




}
/// @nodoc
class __$AddFormulaItemsRequestCopyWithImpl<$Res>
    implements _$AddFormulaItemsRequestCopyWith<$Res> {
  __$AddFormulaItemsRequestCopyWithImpl(this._self, this._then);

  final _AddFormulaItemsRequest _self;
  final $Res Function(_AddFormulaItemsRequest) _then;

/// Create a copy of AddFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_AddFormulaItemsRequest(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AddFormulaItemEntry>,
  ));
}


}

// dart format on
