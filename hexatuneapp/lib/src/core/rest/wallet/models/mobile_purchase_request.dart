// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_purchase_request.freezed.dart';
part 'mobile_purchase_request.g.dart';

/// Body for POST /api/v1/wallet/purchase/apple and
/// POST /api/v1/wallet/purchase/google.
@freezed
abstract class MobilePurchaseRequest with _$MobilePurchaseRequest {
  const factory MobilePurchaseRequest({
    required String packageId,
    required String receiptData,
  }) = _MobilePurchaseRequest;

  factory MobilePurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$MobilePurchaseRequestFromJson(json);
}
