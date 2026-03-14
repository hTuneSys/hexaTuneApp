// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 're_auth_request.freezed.dart';
part 're_auth_request.g.dart';

/// Request body for POST /api/v1/auth/reauth.
@freezed
abstract class ReAuthRequest with _$ReAuthRequest {
  const factory ReAuthRequest({required String password}) = _ReAuthRequest;

  factory ReAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$ReAuthRequestFromJson(json);
}
