// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'unregister_push_token_request.freezed.dart';
part 'unregister_push_token_request.g.dart';

/// Body for DELETE /api/v1/devices/me/push-token.
@freezed
abstract class UnregisterPushTokenRequest with _$UnregisterPushTokenRequest {
  const factory UnregisterPushTokenRequest({required String appId}) =
      _UnregisterPushTokenRequest;

  factory UnregisterPushTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$UnregisterPushTokenRequestFromJson(json);
}
