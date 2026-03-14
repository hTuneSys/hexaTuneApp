// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_package_response.freezed.dart';
part 'coin_package_response.g.dart';

/// Response for GET /api/v1/wallet/packages list items.
@freezed
abstract class CoinPackageResponse with _$CoinPackageResponse {
  const factory CoinPackageResponse({
    required String id,
    required String name,
    required int coins,
    required int priceCents,
    required String currency,
    required int sortOrder,
    String? appleProductId,
    String? googleProductId,
    String? stripePriceId,
  }) = _CoinPackageResponse;

  factory CoinPackageResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinPackageResponseFromJson(json);
}
