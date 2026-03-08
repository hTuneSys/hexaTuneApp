// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_membership_response.freezed.dart';
part 'tenant_membership_response.g.dart';

/// Response item from GET /api/v1/accounts/me/tenants.
@freezed
abstract class TenantMembershipResponse with _$TenantMembershipResponse {
  const factory TenantMembershipResponse({
    required String id,
    required String tenantId,
    required String role,
    required String status,
    required bool isOwner,
    String? joinedAt,
  }) = _TenantMembershipResponse;

  factory TenantMembershipResponse.fromJson(Map<String, dynamic> json) =>
      _$TenantMembershipResponseFromJson(json);
}
