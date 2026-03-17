// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iap_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IapProduct {

 String get packageId; String get name; int get coins; String get storeProductId; String get price; double get rawPrice; String get currencyCode;
/// Create a copy of IapProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IapProductCopyWith<IapProduct> get copyWith => _$IapProductCopyWithImpl<IapProduct>(this as IapProduct, _$identity);

  /// Serializes this IapProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IapProduct&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.storeProductId, storeProductId) || other.storeProductId == storeProductId)&&(identical(other.price, price) || other.price == price)&&(identical(other.rawPrice, rawPrice) || other.rawPrice == rawPrice)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,name,coins,storeProductId,price,rawPrice,currencyCode);

@override
String toString() {
  return 'IapProduct(packageId: $packageId, name: $name, coins: $coins, storeProductId: $storeProductId, price: $price, rawPrice: $rawPrice, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class $IapProductCopyWith<$Res>  {
  factory $IapProductCopyWith(IapProduct value, $Res Function(IapProduct) _then) = _$IapProductCopyWithImpl;
@useResult
$Res call({
 String packageId, String name, int coins, String storeProductId, String price, double rawPrice, String currencyCode
});




}
/// @nodoc
class _$IapProductCopyWithImpl<$Res>
    implements $IapProductCopyWith<$Res> {
  _$IapProductCopyWithImpl(this._self, this._then);

  final IapProduct _self;
  final $Res Function(IapProduct) _then;

/// Create a copy of IapProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageId = null,Object? name = null,Object? coins = null,Object? storeProductId = null,Object? price = null,Object? rawPrice = null,Object? currencyCode = null,}) {
  return _then(_self.copyWith(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,storeProductId: null == storeProductId ? _self.storeProductId : storeProductId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,rawPrice: null == rawPrice ? _self.rawPrice : rawPrice // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IapProduct].
extension IapProductPatterns on IapProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IapProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IapProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IapProduct value)  $default,){
final _that = this;
switch (_that) {
case _IapProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IapProduct value)?  $default,){
final _that = this;
switch (_that) {
case _IapProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageId,  String name,  int coins,  String storeProductId,  String price,  double rawPrice,  String currencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IapProduct() when $default != null:
return $default(_that.packageId,_that.name,_that.coins,_that.storeProductId,_that.price,_that.rawPrice,_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageId,  String name,  int coins,  String storeProductId,  String price,  double rawPrice,  String currencyCode)  $default,) {final _that = this;
switch (_that) {
case _IapProduct():
return $default(_that.packageId,_that.name,_that.coins,_that.storeProductId,_that.price,_that.rawPrice,_that.currencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageId,  String name,  int coins,  String storeProductId,  String price,  double rawPrice,  String currencyCode)?  $default,) {final _that = this;
switch (_that) {
case _IapProduct() when $default != null:
return $default(_that.packageId,_that.name,_that.coins,_that.storeProductId,_that.price,_that.rawPrice,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IapProduct implements IapProduct {
  const _IapProduct({required this.packageId, required this.name, required this.coins, required this.storeProductId, required this.price, required this.rawPrice, required this.currencyCode});
  factory _IapProduct.fromJson(Map<String, dynamic> json) => _$IapProductFromJson(json);

@override final  String packageId;
@override final  String name;
@override final  int coins;
@override final  String storeProductId;
@override final  String price;
@override final  double rawPrice;
@override final  String currencyCode;

/// Create a copy of IapProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IapProductCopyWith<_IapProduct> get copyWith => __$IapProductCopyWithImpl<_IapProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IapProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IapProduct&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.storeProductId, storeProductId) || other.storeProductId == storeProductId)&&(identical(other.price, price) || other.price == price)&&(identical(other.rawPrice, rawPrice) || other.rawPrice == rawPrice)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageId,name,coins,storeProductId,price,rawPrice,currencyCode);

@override
String toString() {
  return 'IapProduct(packageId: $packageId, name: $name, coins: $coins, storeProductId: $storeProductId, price: $price, rawPrice: $rawPrice, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$IapProductCopyWith<$Res> implements $IapProductCopyWith<$Res> {
  factory _$IapProductCopyWith(_IapProduct value, $Res Function(_IapProduct) _then) = __$IapProductCopyWithImpl;
@override @useResult
$Res call({
 String packageId, String name, int coins, String storeProductId, String price, double rawPrice, String currencyCode
});




}
/// @nodoc
class __$IapProductCopyWithImpl<$Res>
    implements _$IapProductCopyWith<$Res> {
  __$IapProductCopyWithImpl(this._self, this._then);

  final _IapProduct _self;
  final $Res Function(_IapProduct) _then;

/// Create a copy of IapProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageId = null,Object? name = null,Object? coins = null,Object? storeProductId = null,Object? price = null,Object? rawPrice = null,Object? currencyCode = null,}) {
  return _then(_IapProduct(
packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,storeProductId: null == storeProductId ? _self.storeProductId : storeProductId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,rawPrice: null == rawPrice ? _self.rawPrice : rawPrice // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
