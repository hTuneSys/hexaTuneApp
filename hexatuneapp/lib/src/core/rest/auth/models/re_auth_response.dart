// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 're_auth_response.freezed.dart';
part 're_auth_response.g.dart';

/// Response from POST /api/v1/auth/reauth.
@freezed
abstract class ReAuthResponse with _$ReAuthResponse {
  const factory ReAuthResponse({
    required String token,
    required String expiresAt,
  }) = _ReAuthResponse;

  factory ReAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$ReAuthResponseFromJson(json);
}
