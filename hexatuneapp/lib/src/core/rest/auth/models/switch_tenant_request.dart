// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'switch_tenant_request.freezed.dart';
part 'switch_tenant_request.g.dart';

/// Request body for POST /api/v1/auth/switch-tenant.
@freezed
abstract class SwitchTenantRequest with _$SwitchTenantRequest {
  const factory SwitchTenantRequest({required String tenantId}) =
      _SwitchTenantRequest;

  factory SwitchTenantRequest.fromJson(Map<String, dynamic> json) =>
      _$SwitchTenantRequestFromJson(json);
}
