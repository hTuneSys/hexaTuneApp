// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'initiate_purchase_request.freezed.dart';
part 'initiate_purchase_request.g.dart';

/// Body for POST /api/v1/wallet/purchase/stripe.
@freezed
abstract class InitiatePurchaseRequest with _$InitiatePurchaseRequest {
  const factory InitiatePurchaseRequest({required String packageId}) =
      _InitiatePurchaseRequest;

  factory InitiatePurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$InitiatePurchaseRequestFromJson(json);
}
