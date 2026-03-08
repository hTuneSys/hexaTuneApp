// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response.freezed.dart';
part 'profile_response.g.dart';

/// Response from GET /api/v1/accounts/me/profile.
@freezed
abstract class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    required String accountId,
    String? displayName,
    String? avatarUrl,
    String? bio,
    required String updatedAt,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
