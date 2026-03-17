// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_purchase_request.freezed.dart';
part 'apple_purchase_request.g.dart';

/// Body for POST /api/v1/wallet/purchase/apple.
@freezed
abstract class ApplePurchaseRequest with _$ApplePurchaseRequest {
  const factory ApplePurchaseRequest({
    required String packageId,
    required String transactionId,
  }) = _ApplePurchaseRequest;

  factory ApplePurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplePurchaseRequestFromJson(json);
}
