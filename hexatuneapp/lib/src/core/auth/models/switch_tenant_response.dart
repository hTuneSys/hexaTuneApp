// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'switch_tenant_response.freezed.dart';
part 'switch_tenant_response.g.dart';

/// Response from POST /api/v1/auth/switch-tenant.
@freezed
abstract class SwitchTenantResponse with _$SwitchTenantResponse {
  const factory SwitchTenantResponse({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
  }) = _SwitchTenantResponse;

  factory SwitchTenantResponse.fromJson(Map<String, dynamic> json) =>
      _$SwitchTenantResponseFromJson(json);
}
