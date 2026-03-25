// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_purchase_request.freezed.dart';
part 'google_purchase_request.g.dart';

/// Body for POST /api/v1/wallet/purchase/google.
@freezed
abstract class GooglePurchaseRequest with _$GooglePurchaseRequest {
  const factory GooglePurchaseRequest({
    required String packageId,
    required String purchaseToken,
  }) = _GooglePurchaseRequest;

  factory GooglePurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$GooglePurchaseRequestFromJson(json);
}
