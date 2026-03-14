// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Repository for audit log API calls.
@singleton
class AuditRepository {
  AuditRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/audit/logs
  Future<PaginatedResponse<AuditLogDto>> queryLogs({
    PaginationParams? params,
    AuditLogQueryParams? filters,
  }) async {
    _logService.debug('GET audit/logs', category: LogCategory.network);
    final queryParameters = <String, dynamic>{
      ...?params?.toQueryParameters(),
      ...?filters?.toQueryParameters(),
    };
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.auditLogs,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Audit logs response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (json) => AuditLogDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
