// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_auth_request.freezed.dart';
part 'google_auth_request.g.dart';

/// Credentials sent to POST /api/v1/auth/google.
@freezed
abstract class GoogleAuthRequest with _$GoogleAuthRequest {
  const factory GoogleAuthRequest({required String idToken, String? deviceId}) =
      _GoogleAuthRequest;

  factory GoogleAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestFromJson(json);
}
