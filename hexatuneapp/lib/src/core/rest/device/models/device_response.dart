// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_response.freezed.dart';
part 'device_response.g.dart';

/// Response for GET /api/v1/devices list items.
@freezed
abstract class DeviceResponse with _$DeviceResponse {
  const factory DeviceResponse({
    required String id,
    required bool isTrusted,
    required String userAgent,
    required String ipAddress,
    required String firstSeenAt,
    required String lastSeenAt,
  }) = _DeviceResponse;

  factory DeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceResponseFromJson(json);
}
