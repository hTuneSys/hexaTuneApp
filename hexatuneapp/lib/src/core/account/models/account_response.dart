// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_response.freezed.dart';
part 'account_response.g.dart';

/// Response from GET /api/v1/accounts/me.
@freezed
abstract class AccountResponse with _$AccountResponse {
  const factory AccountResponse({
    required String id,
    required String email,
    required String status,
    required String createdAt,
    required String updatedAt,
  }) = _AccountResponse;

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseFromJson(json);
}
