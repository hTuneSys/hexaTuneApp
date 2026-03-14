// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_url_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageUrlResponse {

 String get url;
/// Create a copy of ImageUrlResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageUrlResponseCopyWith<ImageUrlResponse> get copyWith => _$ImageUrlResponseCopyWithImpl<ImageUrlResponse>(this as ImageUrlResponse, _$identity);

  /// Serializes this ImageUrlResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageUrlResponse&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ImageUrlResponse(url: $url)';
}


}

/// @nodoc
abstract mixin class $ImageUrlResponseCopyWith<$Res>  {
  factory $ImageUrlResponseCopyWith(ImageUrlResponse value, $Res Function(ImageUrlResponse) _then) = _$ImageUrlResponseCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$ImageUrlResponseCopyWithImpl<$Res>
    implements $ImageUrlResponseCopyWith<$Res> {
  _$ImageUrlResponseCopyWithImpl(this._self, this._then);

  final ImageUrlResponse _self;
  final $Res Function(ImageUrlResponse) _then;

/// Create a copy of ImageUrlResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageUrlResponse].
extension ImageUrlResponsePatterns on ImageUrlResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageUrlResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageUrlResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageUrlResponse value)  $default,){
final _that = this;
switch (_that) {
case _ImageUrlResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageUrlResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ImageUrlResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageUrlResponse() when $default != null:
return $default(_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url)  $default,) {final _that = this;
switch (_that) {
case _ImageUrlResponse():
return $default(_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url)?  $default,) {final _that = this;
switch (_that) {
case _ImageUrlResponse() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageUrlResponse implements ImageUrlResponse {
  const _ImageUrlResponse({required this.url});
  factory _ImageUrlResponse.fromJson(Map<String, dynamic> json) => _$ImageUrlResponseFromJson(json);

@override final  String url;

/// Create a copy of ImageUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageUrlResponseCopyWith<_ImageUrlResponse> get copyWith => __$ImageUrlResponseCopyWithImpl<_ImageUrlResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageUrlResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageUrlResponse&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ImageUrlResponse(url: $url)';
}


}

/// @nodoc
abstract mixin class _$ImageUrlResponseCopyWith<$Res> implements $ImageUrlResponseCopyWith<$Res> {
  factory _$ImageUrlResponseCopyWith(_ImageUrlResponse value, $Res Function(_ImageUrlResponse) _then) = __$ImageUrlResponseCopyWithImpl;
@override @useResult
$Res call({
 String url
});




}
/// @nodoc
class __$ImageUrlResponseCopyWithImpl<$Res>
    implements _$ImageUrlResponseCopyWith<$Res> {
  __$ImageUrlResponseCopyWithImpl(this._self, this._then);

  final _ImageUrlResponse _self;
  final $Res Function(_ImageUrlResponse) _then;

/// Create a copy of ImageUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_ImageUrlResponse(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
