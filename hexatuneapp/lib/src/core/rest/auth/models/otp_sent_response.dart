// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_sent_response.freezed.dart';
part 'otp_sent_response.g.dart';

/// Response from OTP-sending endpoints (forgot-password, resend-verification,
/// resend-password-reset, link-email-provider).
@freezed
abstract class OtpSentResponse with _$OtpSentResponse {
  const factory OtpSentResponse({required int expiresInSeconds}) =
      _OtpSentResponse;

  factory OtpSentResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpSentResponseFromJson(json);
}
