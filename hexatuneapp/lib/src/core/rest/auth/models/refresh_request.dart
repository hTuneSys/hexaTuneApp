// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_request.freezed.dart';
part 'refresh_request.g.dart';

/// Request body for POST /api/v1/auth/refresh.
@freezed
abstract class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({required String refreshToken}) =
      _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}
