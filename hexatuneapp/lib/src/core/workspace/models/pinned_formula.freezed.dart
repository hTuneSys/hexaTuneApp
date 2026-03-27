// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pinned_formula.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinnedFormula {

 String get id; String get name;
/// Create a copy of PinnedFormula
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinnedFormulaCopyWith<PinnedFormula> get copyWith => _$PinnedFormulaCopyWithImpl<PinnedFormula>(this as PinnedFormula, _$identity);

  /// Serializes this PinnedFormula to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinnedFormula&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PinnedFormula(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $PinnedFormulaCopyWith<$Res>  {
  factory $PinnedFormulaCopyWith(PinnedFormula value, $Res Function(PinnedFormula) _then) = _$PinnedFormulaCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$PinnedFormulaCopyWithImpl<$Res>
    implements $PinnedFormulaCopyWith<$Res> {
  _$PinnedFormulaCopyWithImpl(this._self, this._then);

  final PinnedFormula _self;
  final $Res Function(PinnedFormula) _then;

/// Create a copy of PinnedFormula
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PinnedFormula].
extension PinnedFormulaPatterns on PinnedFormula {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinnedFormula value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinnedFormula() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinnedFormula value)  $default,){
final _that = this;
switch (_that) {
case _PinnedFormula():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinnedFormula value)?  $default,){
final _that = this;
switch (_that) {
case _PinnedFormula() when $default != null:
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
case _PinnedFormula() when $default != null:
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
case _PinnedFormula():
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
case _PinnedFormula() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PinnedFormula implements PinnedFormula {
  const _PinnedFormula({required this.id, required this.name});
  factory _PinnedFormula.fromJson(Map<String, dynamic> json) => _$PinnedFormulaFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of PinnedFormula
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinnedFormulaCopyWith<_PinnedFormula> get copyWith => __$PinnedFormulaCopyWithImpl<_PinnedFormula>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinnedFormulaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinnedFormula&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PinnedFormula(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PinnedFormulaCopyWith<$Res> implements $PinnedFormulaCopyWith<$Res> {
  factory _$PinnedFormulaCopyWith(_PinnedFormula value, $Res Function(_PinnedFormula) _then) = __$PinnedFormulaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$PinnedFormulaCopyWithImpl<$Res>
    implements _$PinnedFormulaCopyWith<$Res> {
  __$PinnedFormulaCopyWithImpl(this._self, this._then);

  final _PinnedFormula _self;
  final $Res Function(_PinnedFormula) _then;

/// Create a copy of PinnedFormula
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_PinnedFormula(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
