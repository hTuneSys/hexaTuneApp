// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_response.freezed.dart';
part 'session_response.g.dart';

/// Response item from GET /api/v1/accounts/me/sessions.
@freezed
abstract class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    required String id,
    required String accountId,
    required String deviceId,
    required String createdAt,
    required String expiresAt,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}
