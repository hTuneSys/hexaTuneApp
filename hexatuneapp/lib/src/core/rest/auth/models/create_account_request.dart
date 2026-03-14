// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_account_request.freezed.dart';
part 'create_account_request.g.dart';

/// Request body for POST /api/v1/auth/register.
@freezed
abstract class CreateAccountRequest with _$CreateAccountRequest {
  const factory CreateAccountRequest({
    required String email,
    required String password,
  }) = _CreateAccountRequest;

  factory CreateAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountRequestFromJson(json);
}
