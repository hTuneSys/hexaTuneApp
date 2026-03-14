// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_push_token_request.freezed.dart';
part 'register_push_token_request.g.dart';

/// Body for PUT /api/v1/devices/me/push-token.
@freezed
abstract class RegisterPushTokenRequest with _$RegisterPushTokenRequest {
  const factory RegisterPushTokenRequest({
    required String token,
    required String platform,
    required String appId,
  }) = _RegisterPushTokenRequest;

  factory RegisterPushTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterPushTokenRequestFromJson(json);
}
