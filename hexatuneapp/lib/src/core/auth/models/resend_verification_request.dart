// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_verification_request.freezed.dart';
part 'resend_verification_request.g.dart';

/// Request body for POST /api/v1/auth/resend-verification.
@freezed
abstract class ResendVerificationRequest
    with _$ResendVerificationRequest {
  const factory ResendVerificationRequest({
    required String email,
  }) = _ResendVerificationRequest;

  factory ResendVerificationRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ResendVerificationRequestFromJson(json);
}
