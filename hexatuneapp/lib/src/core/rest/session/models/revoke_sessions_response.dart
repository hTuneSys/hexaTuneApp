// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'revoke_sessions_response.freezed.dart';
part 'revoke_sessions_response.g.dart';

/// Response from DELETE /api/v1/accounts/me/sessions/others.
@freezed
abstract class RevokeSessionsResponse with _$RevokeSessionsResponse {
  const factory RevokeSessionsResponse({required int revokedCount}) =
      _RevokeSessionsResponse;

  factory RevokeSessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$RevokeSessionsResponseFromJson(json);
}
