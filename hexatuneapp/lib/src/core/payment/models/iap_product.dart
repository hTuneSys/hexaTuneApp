// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'iap_product.freezed.dart';
part 'iap_product.g.dart';

/// Merged product combining backend coin package data with native store data.
@freezed
abstract class IapProduct with _$IapProduct {
  const factory IapProduct({
    required String packageId,
    required String name,
    required int coins,
    required String storeProductId,
    required String price,
    required double rawPrice,
    required String currencyCode,
  }) = _IapProduct;

  factory IapProduct.fromJson(Map<String, dynamic> json) =>
      _$IapProductFromJson(json);
}
