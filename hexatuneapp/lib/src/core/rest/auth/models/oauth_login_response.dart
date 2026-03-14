// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_login_response.freezed.dart';
part 'oauth_login_response.g.dart';

/// Response from POST /api/v1/auth/google and POST /api/v1/auth/apple.
@freezed
abstract class OAuthLoginResponse with _$OAuthLoginResponse {
  const factory OAuthLoginResponse({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
    required String accountId,
    required String expiresAt,
    required bool isNewAccount,
  }) = _OAuthLoginResponse;

  factory OAuthLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$OAuthLoginResponseFromJson(json);
}
