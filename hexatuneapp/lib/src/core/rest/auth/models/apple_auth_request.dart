// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_auth_request.freezed.dart';
part 'apple_auth_request.g.dart';

/// Credentials sent to POST /api/v1/auth/apple.
@freezed
abstract class AppleAuthRequest with _$AppleAuthRequest {
  const factory AppleAuthRequest({
    required String idToken,
    String? authorizationCode,
    String? deviceId,
  }) = _AppleAuthRequest;

  factory AppleAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleAuthRequestFromJson(json);
}
