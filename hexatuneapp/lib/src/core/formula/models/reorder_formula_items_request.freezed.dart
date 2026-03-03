// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reorder_formula_items_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReorderFormulaItemsRequest {

 List<ReorderEntry> get items;
/// Create a copy of ReorderFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderFormulaItemsRequestCopyWith<ReorderFormulaItemsRequest> get copyWith => _$ReorderFormulaItemsRequestCopyWithImpl<ReorderFormulaItemsRequest>(this as ReorderFormulaItemsRequest, _$identity);

  /// Serializes this ReorderFormulaItemsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderFormulaItemsRequest&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ReorderFormulaItemsRequest(items: $items)';
}


}

/// @nodoc
abstract mixin class $ReorderFormulaItemsRequestCopyWith<$Res>  {
  factory $ReorderFormulaItemsRequestCopyWith(ReorderFormulaItemsRequest value, $Res Function(ReorderFormulaItemsRequest) _then) = _$ReorderFormulaItemsRequestCopyWithImpl;
@useResult
$Res call({
 List<ReorderEntry> items
});




}
/// @nodoc
class _$ReorderFormulaItemsRequestCopyWithImpl<$Res>
    implements $ReorderFormulaItemsRequestCopyWith<$Res> {
  _$ReorderFormulaItemsRequestCopyWithImpl(this._self, this._then);

  final ReorderFormulaItemsRequest _self;
  final $Res Function(ReorderFormulaItemsRequest) _then;

/// Create a copy of ReorderFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReorderEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderFormulaItemsRequest].
extension ReorderFormulaItemsRequestPatterns on ReorderFormulaItemsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderFormulaItemsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderFormulaItemsRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderFormulaItemsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReorderEntry> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReorderEntry> items)  $default,) {final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReorderEntry> items)?  $default,) {final _that = this;
switch (_that) {
case _ReorderFormulaItemsRequest() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderFormulaItemsRequest implements ReorderFormulaItemsRequest {
  const _ReorderFormulaItemsRequest({required final  List<ReorderEntry> items}): _items = items;
  factory _ReorderFormulaItemsRequest.fromJson(Map<String, dynamic> json) => _$ReorderFormulaItemsRequestFromJson(json);

 final  List<ReorderEntry> _items;
@override List<ReorderEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReorderFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderFormulaItemsRequestCopyWith<_ReorderFormulaItemsRequest> get copyWith => __$ReorderFormulaItemsRequestCopyWithImpl<_ReorderFormulaItemsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderFormulaItemsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderFormulaItemsRequest&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ReorderFormulaItemsRequest(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReorderFormulaItemsRequestCopyWith<$Res> implements $ReorderFormulaItemsRequestCopyWith<$Res> {
  factory _$ReorderFormulaItemsRequestCopyWith(_ReorderFormulaItemsRequest value, $Res Function(_ReorderFormulaItemsRequest) _then) = __$ReorderFormulaItemsRequestCopyWithImpl;
@override @useResult
$Res call({
 List<ReorderEntry> items
});




}
/// @nodoc
class __$ReorderFormulaItemsRequestCopyWithImpl<$Res>
    implements _$ReorderFormulaItemsRequestCopyWith<$Res> {
  __$ReorderFormulaItemsRequestCopyWithImpl(this._self, this._then);

  final _ReorderFormulaItemsRequest _self;
  final $Res Function(_ReorderFormulaItemsRequest) _then;

/// Create a copy of ReorderFormulaItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ReorderFormulaItemsRequest(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReorderEntry>,
  ));
}


}

// dart format on
