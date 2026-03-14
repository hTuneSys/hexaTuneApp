// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_package_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoinPackageResponse {

 String get id; String get name; int get coins; int get priceCents; String get currency; int get sortOrder; String? get appleProductId; String? get googleProductId; String? get stripePriceId;
/// Create a copy of CoinPackageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinPackageResponseCopyWith<CoinPackageResponse> get copyWith => _$CoinPackageResponseCopyWithImpl<CoinPackageResponse>(this as CoinPackageResponse, _$identity);

  /// Serializes this CoinPackageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinPackageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.appleProductId, appleProductId) || other.appleProductId == appleProductId)&&(identical(other.googleProductId, googleProductId) || other.googleProductId == googleProductId)&&(identical(other.stripePriceId, stripePriceId) || other.stripePriceId == stripePriceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coins,priceCents,currency,sortOrder,appleProductId,googleProductId,stripePriceId);

@override
String toString() {
  return 'CoinPackageResponse(id: $id, name: $name, coins: $coins, priceCents: $priceCents, currency: $currency, sortOrder: $sortOrder, appleProductId: $appleProductId, googleProductId: $googleProductId, stripePriceId: $stripePriceId)';
}


}

/// @nodoc
abstract mixin class $CoinPackageResponseCopyWith<$Res>  {
  factory $CoinPackageResponseCopyWith(CoinPackageResponse value, $Res Function(CoinPackageResponse) _then) = _$CoinPackageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, int coins, int priceCents, String currency, int sortOrder, String? appleProductId, String? googleProductId, String? stripePriceId
});




}
/// @nodoc
class _$CoinPackageResponseCopyWithImpl<$Res>
    implements $CoinPackageResponseCopyWith<$Res> {
  _$CoinPackageResponseCopyWithImpl(this._self, this._then);

  final CoinPackageResponse _self;
  final $Res Function(CoinPackageResponse) _then;

/// Create a copy of CoinPackageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? coins = null,Object? priceCents = null,Object? currency = null,Object? sortOrder = null,Object? appleProductId = freezed,Object? googleProductId = freezed,Object? stripePriceId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,appleProductId: freezed == appleProductId ? _self.appleProductId : appleProductId // ignore: cast_nullable_to_non_nullable
as String?,googleProductId: freezed == googleProductId ? _self.googleProductId : googleProductId // ignore: cast_nullable_to_non_nullable
as String?,stripePriceId: freezed == stripePriceId ? _self.stripePriceId : stripePriceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoinPackageResponse].
extension CoinPackageResponsePatterns on CoinPackageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoinPackageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoinPackageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoinPackageResponse value)  $default,){
final _that = this;
switch (_that) {
case _CoinPackageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoinPackageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CoinPackageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int coins,  int priceCents,  String currency,  int sortOrder,  String? appleProductId,  String? googleProductId,  String? stripePriceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoinPackageResponse() when $default != null:
return $default(_that.id,_that.name,_that.coins,_that.priceCents,_that.currency,_that.sortOrder,_that.appleProductId,_that.googleProductId,_that.stripePriceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int coins,  int priceCents,  String currency,  int sortOrder,  String? appleProductId,  String? googleProductId,  String? stripePriceId)  $default,) {final _that = this;
switch (_that) {
case _CoinPackageResponse():
return $default(_that.id,_that.name,_that.coins,_that.priceCents,_that.currency,_that.sortOrder,_that.appleProductId,_that.googleProductId,_that.stripePriceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int coins,  int priceCents,  String currency,  int sortOrder,  String? appleProductId,  String? googleProductId,  String? stripePriceId)?  $default,) {final _that = this;
switch (_that) {
case _CoinPackageResponse() when $default != null:
return $default(_that.id,_that.name,_that.coins,_that.priceCents,_that.currency,_that.sortOrder,_that.appleProductId,_that.googleProductId,_that.stripePriceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoinPackageResponse implements CoinPackageResponse {
  const _CoinPackageResponse({required this.id, required this.name, required this.coins, required this.priceCents, required this.currency, required this.sortOrder, this.appleProductId, this.googleProductId, this.stripePriceId});
  factory _CoinPackageResponse.fromJson(Map<String, dynamic> json) => _$CoinPackageResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  int coins;
@override final  int priceCents;
@override final  String currency;
@override final  int sortOrder;
@override final  String? appleProductId;
@override final  String? googleProductId;
@override final  String? stripePriceId;

/// Create a copy of CoinPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinPackageResponseCopyWith<_CoinPackageResponse> get copyWith => __$CoinPackageResponseCopyWithImpl<_CoinPackageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinPackageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinPackageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.appleProductId, appleProductId) || other.appleProductId == appleProductId)&&(identical(other.googleProductId, googleProductId) || other.googleProductId == googleProductId)&&(identical(other.stripePriceId, stripePriceId) || other.stripePriceId == stripePriceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coins,priceCents,currency,sortOrder,appleProductId,googleProductId,stripePriceId);

@override
String toString() {
  return 'CoinPackageResponse(id: $id, name: $name, coins: $coins, priceCents: $priceCents, currency: $currency, sortOrder: $sortOrder, appleProductId: $appleProductId, googleProductId: $googleProductId, stripePriceId: $stripePriceId)';
}


}

/// @nodoc
abstract mixin class _$CoinPackageResponseCopyWith<$Res> implements $CoinPackageResponseCopyWith<$Res> {
  factory _$CoinPackageResponseCopyWith(_CoinPackageResponse value, $Res Function(_CoinPackageResponse) _then) = __$CoinPackageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int coins, int priceCents, String currency, int sortOrder, String? appleProductId, String? googleProductId, String? stripePriceId
});




}
/// @nodoc
class __$CoinPackageResponseCopyWithImpl<$Res>
    implements _$CoinPackageResponseCopyWith<$Res> {
  __$CoinPackageResponseCopyWithImpl(this._self, this._then);

  final _CoinPackageResponse _self;
  final $Res Function(_CoinPackageResponse) _then;

/// Create a copy of CoinPackageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? coins = null,Object? priceCents = null,Object? currency = null,Object? sortOrder = null,Object? appleProductId = freezed,Object? googleProductId = freezed,Object? stripePriceId = freezed,}) {
  return _then(_CoinPackageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,appleProductId: freezed == appleProductId ? _self.appleProductId : appleProductId // ignore: cast_nullable_to_non_nullable
as String?,googleProductId: freezed == googleProductId ? _self.googleProductId : googleProductId // ignore: cast_nullable_to_non_nullable
as String?,stripePriceId: freezed == stripePriceId ? _self.stripePriceId : stripePriceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
