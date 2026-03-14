// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_response.freezed.dart';
part 'refresh_response.g.dart';

/// Response from POST /api/v1/auth/refresh.
@freezed
abstract class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
    required String expiresAt,
  }) = _RefreshResponse;

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}
