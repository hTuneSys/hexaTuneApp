// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioAsset {

/// Layer type: "base", "texture", or "events".
 String get layerType;/// Display name derived from the filename (without extension).
 String get name;/// Full asset path for loading via the asset bundle.
 String get assetPath;
/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioAssetCopyWith<AudioAsset> get copyWith => _$AudioAssetCopyWithImpl<AudioAsset>(this as AudioAsset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioAsset&&(identical(other.layerType, layerType) || other.layerType == layerType)&&(identical(other.name, name) || other.name == name)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath));
}


@override
int get hashCode => Object.hash(runtimeType,layerType,name,assetPath);

@override
String toString() {
  return 'AudioAsset(layerType: $layerType, name: $name, assetPath: $assetPath)';
}


}

/// @nodoc
abstract mixin class $AudioAssetCopyWith<$Res>  {
  factory $AudioAssetCopyWith(AudioAsset value, $Res Function(AudioAsset) _then) = _$AudioAssetCopyWithImpl;
@useResult
$Res call({
 String layerType, String name, String assetPath
});




}
/// @nodoc
class _$AudioAssetCopyWithImpl<$Res>
    implements $AudioAssetCopyWith<$Res> {
  _$AudioAssetCopyWithImpl(this._self, this._then);

  final AudioAsset _self;
  final $Res Function(AudioAsset) _then;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layerType = null,Object? name = null,Object? assetPath = null,}) {
  return _then(_self.copyWith(
layerType: null == layerType ? _self.layerType : layerType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioAsset].
extension AudioAssetPatterns on AudioAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioAsset value)  $default,){
final _that = this;
switch (_that) {
case _AudioAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioAsset value)?  $default,){
final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String layerType,  String name,  String assetPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that.layerType,_that.name,_that.assetPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String layerType,  String name,  String assetPath)  $default,) {final _that = this;
switch (_that) {
case _AudioAsset():
return $default(_that.layerType,_that.name,_that.assetPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String layerType,  String name,  String assetPath)?  $default,) {final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that.layerType,_that.name,_that.assetPath);case _:
  return null;

}
}

}

/// @nodoc


class _AudioAsset implements AudioAsset {
  const _AudioAsset({required this.layerType, required this.name, required this.assetPath});
  

/// Layer type: "base", "texture", or "events".
@override final  String layerType;
/// Display name derived from the filename (without extension).
@override final  String name;
/// Full asset path for loading via the asset bundle.
@override final  String assetPath;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioAssetCopyWith<_AudioAsset> get copyWith => __$AudioAssetCopyWithImpl<_AudioAsset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioAsset&&(identical(other.layerType, layerType) || other.layerType == layerType)&&(identical(other.name, name) || other.name == name)&&(identical(other.assetPath, assetPath) || other.assetPath == assetPath));
}


@override
int get hashCode => Object.hash(runtimeType,layerType,name,assetPath);

@override
String toString() {
  return 'AudioAsset(layerType: $layerType, name: $name, assetPath: $assetPath)';
}


}

/// @nodoc
abstract mixin class _$AudioAssetCopyWith<$Res> implements $AudioAssetCopyWith<$Res> {
  factory _$AudioAssetCopyWith(_AudioAsset value, $Res Function(_AudioAsset) _then) = __$AudioAssetCopyWithImpl;
@override @useResult
$Res call({
 String layerType, String name, String assetPath
});




}
/// @nodoc
class __$AudioAssetCopyWithImpl<$Res>
    implements _$AudioAssetCopyWith<$Res> {
  __$AudioAssetCopyWithImpl(this._self, this._then);

  final _AudioAsset _self;
  final $Res Function(_AudioAsset) _then;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? layerType = null,Object? name = null,Object? assetPath = null,}) {
  return _then(_AudioAsset(
layerType: null == layerType ? _self.layerType : layerType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assetPath: null == assetPath ? _self.assetPath : assetPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
