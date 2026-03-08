// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/session/models/revoke_sessions_response.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';

/// Repository for session management API calls.
@singleton
class SessionRepository {
  SessionRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/accounts/me/sessions
  Future<PaginatedResponse<SessionResponse>> listSessions({
    PaginationParams? params,
  }) async {
    _logService.debug('GET sessions', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.sessions,
      queryParameters: params?.toQueryParameters(),
    );
    return PaginatedResponse.fromJson(
      response.data!,
      (json) => SessionResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE /api/v1/accounts/me/sessions
  Future<void> revokeAll() async {
    _logService.debug('DELETE sessions', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.sessions);
  }

  /// DELETE /api/v1/accounts/me/sessions/others
  Future<RevokeSessionsResponse> revokeOthers() async {
    _logService.debug('DELETE sessions/others', category: LogCategory.network);
    final response = await _dio.delete<Map<String, dynamic>>(
      ApiEndpoints.sessionsOthers,
    );
    return RevokeSessionsResponse.fromJson(response.data!);
  }
}
