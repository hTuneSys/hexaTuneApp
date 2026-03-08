// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_request.freezed.dart';
part 'verify_email_request.g.dart';

/// Request body for POST /api/v1/auth/verify-email.
@freezed
abstract class VerifyEmailRequest with _$VerifyEmailRequest {
  const factory VerifyEmailRequest({
    required String email,
    required String code,
  }) = _VerifyEmailRequest;

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestFromJson(json);
}
