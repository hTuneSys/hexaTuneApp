// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_balance_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletBalanceResponse {

 String get tenantId; int get balanceCoins; int get totalPurchased; int get totalSpent;
/// Create a copy of WalletBalanceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletBalanceResponseCopyWith<WalletBalanceResponse> get copyWith => _$WalletBalanceResponseCopyWithImpl<WalletBalanceResponse>(this as WalletBalanceResponse, _$identity);

  /// Serializes this WalletBalanceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletBalanceResponse&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.balanceCoins, balanceCoins) || other.balanceCoins == balanceCoins)&&(identical(other.totalPurchased, totalPurchased) || other.totalPurchased == totalPurchased)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tenantId,balanceCoins,totalPurchased,totalSpent);

@override
String toString() {
  return 'WalletBalanceResponse(tenantId: $tenantId, balanceCoins: $balanceCoins, totalPurchased: $totalPurchased, totalSpent: $totalSpent)';
}


}

/// @nodoc
abstract mixin class $WalletBalanceResponseCopyWith<$Res>  {
  factory $WalletBalanceResponseCopyWith(WalletBalanceResponse value, $Res Function(WalletBalanceResponse) _then) = _$WalletBalanceResponseCopyWithImpl;
@useResult
$Res call({
 String tenantId, int balanceCoins, int totalPurchased, int totalSpent
});




}
/// @nodoc
class _$WalletBalanceResponseCopyWithImpl<$Res>
    implements $WalletBalanceResponseCopyWith<$Res> {
  _$WalletBalanceResponseCopyWithImpl(this._self, this._then);

  final WalletBalanceResponse _self;
  final $Res Function(WalletBalanceResponse) _then;

/// Create a copy of WalletBalanceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tenantId = null,Object? balanceCoins = null,Object? totalPurchased = null,Object? totalSpent = null,}) {
  return _then(_self.copyWith(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,balanceCoins: null == balanceCoins ? _self.balanceCoins : balanceCoins // ignore: cast_nullable_to_non_nullable
as int,totalPurchased: null == totalPurchased ? _self.totalPurchased : totalPurchased // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletBalanceResponse].
extension WalletBalanceResponsePatterns on WalletBalanceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletBalanceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletBalanceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletBalanceResponse value)  $default,){
final _that = this;
switch (_that) {
case _WalletBalanceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletBalanceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WalletBalanceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tenantId,  int balanceCoins,  int totalPurchased,  int totalSpent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletBalanceResponse() when $default != null:
return $default(_that.tenantId,_that.balanceCoins,_that.totalPurchased,_that.totalSpent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tenantId,  int balanceCoins,  int totalPurchased,  int totalSpent)  $default,) {final _that = this;
switch (_that) {
case _WalletBalanceResponse():
return $default(_that.tenantId,_that.balanceCoins,_that.totalPurchased,_that.totalSpent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tenantId,  int balanceCoins,  int totalPurchased,  int totalSpent)?  $default,) {final _that = this;
switch (_that) {
case _WalletBalanceResponse() when $default != null:
return $default(_that.tenantId,_that.balanceCoins,_that.totalPurchased,_that.totalSpent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletBalanceResponse implements WalletBalanceResponse {
  const _WalletBalanceResponse({required this.tenantId, required this.balanceCoins, required this.totalPurchased, required this.totalSpent});
  factory _WalletBalanceResponse.fromJson(Map<String, dynamic> json) => _$WalletBalanceResponseFromJson(json);

@override final  String tenantId;
@override final  int balanceCoins;
@override final  int totalPurchased;
@override final  int totalSpent;

/// Create a copy of WalletBalanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletBalanceResponseCopyWith<_WalletBalanceResponse> get copyWith => __$WalletBalanceResponseCopyWithImpl<_WalletBalanceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletBalanceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletBalanceResponse&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.balanceCoins, balanceCoins) || other.balanceCoins == balanceCoins)&&(identical(other.totalPurchased, totalPurchased) || other.totalPurchased == totalPurchased)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tenantId,balanceCoins,totalPurchased,totalSpent);

@override
String toString() {
  return 'WalletBalanceResponse(tenantId: $tenantId, balanceCoins: $balanceCoins, totalPurchased: $totalPurchased, totalSpent: $totalSpent)';
}


}

/// @nodoc
abstract mixin class _$WalletBalanceResponseCopyWith<$Res> implements $WalletBalanceResponseCopyWith<$Res> {
  factory _$WalletBalanceResponseCopyWith(_WalletBalanceResponse value, $Res Function(_WalletBalanceResponse) _then) = __$WalletBalanceResponseCopyWithImpl;
@override @useResult
$Res call({
 String tenantId, int balanceCoins, int totalPurchased, int totalSpent
});




}
/// @nodoc
class __$WalletBalanceResponseCopyWithImpl<$Res>
    implements _$WalletBalanceResponseCopyWith<$Res> {
  __$WalletBalanceResponseCopyWithImpl(this._self, this._then);

  final _WalletBalanceResponse _self;
  final $Res Function(_WalletBalanceResponse) _then;

/// Create a copy of WalletBalanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tenantId = null,Object? balanceCoins = null,Object? totalPurchased = null,Object? totalSpent = null,}) {
  return _then(_WalletBalanceResponse(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,balanceCoins: null == balanceCoins ? _self.balanceCoins : balanceCoins // ignore: cast_nullable_to_non_nullable
as int,totalPurchased: null == totalPurchased ? _self.totalPurchased : totalPurchased // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
