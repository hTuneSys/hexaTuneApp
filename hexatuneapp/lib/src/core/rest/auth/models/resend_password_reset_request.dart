// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_password_reset_request.freezed.dart';
part 'resend_password_reset_request.g.dart';

/// Request body for POST /api/v1/auth/resend-password-reset.
@freezed
abstract class ResendPasswordResetRequest with _$ResendPasswordResetRequest {
  const factory ResendPasswordResetRequest({required String email}) =
      _ResendPasswordResetRequest;

  factory ResendPasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendPasswordResetRequestFromJson(json);
}
