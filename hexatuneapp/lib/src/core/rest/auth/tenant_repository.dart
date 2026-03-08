// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/tenant_membership_response.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

/// Repository for tenant membership and switching API calls.
@singleton
class TenantRepository {
  TenantRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/accounts/me/tenants
  Future<List<TenantMembershipResponse>> listTenantMemberships() async {
    _logService.debug('GET tenant memberships', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.tenants);
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(TenantMembershipResponse.fromJson)
        .toList();
  }

  /// POST /api/v1/auth/switch-tenant
  Future<SwitchTenantResponse> switchTenant(SwitchTenantRequest request) async {
    _logService.debug('POST switch-tenant', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.switchTenant,
      data: request.toJson(),
    );
    return SwitchTenantResponse.fromJson(response.data!);
  }
}
