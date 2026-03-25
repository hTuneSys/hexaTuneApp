// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

/// Response from POST /api/v1/auth/register.
@freezed
abstract class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String id,
    required String email,
    required String status,
    required String createdAt,
    required String updatedAt,
    required int otpExpiresInSeconds,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
