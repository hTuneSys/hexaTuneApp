// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

/// Repository for authentication provider management API calls.
@singleton
class ProviderRepository {
  ProviderRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/accounts/me/providers
  Future<List<ProviderResponse>> listProviders() async {
    _logService.debug('GET providers', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.providers);
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(ProviderResponse.fromJson)
        .toList();
  }

  /// POST /api/v1/auth/providers/email/link
  Future<void> linkEmail(LinkEmailProviderRequest request) async {
    _logService.debug(
      'POST link email provider',
      category: LogCategory.network,
    );
    await _dio.post(ApiEndpoints.linkEmailProvider, data: request.toJson());
  }

  /// POST /api/v1/auth/providers/google/link
  Future<void> linkGoogle(LinkGoogleProviderRequest request) async {
    _logService.debug(
      'POST link google provider',
      category: LogCategory.network,
    );
    await _dio.post(ApiEndpoints.linkGoogleProvider, data: request.toJson());
  }

  /// POST /api/v1/auth/providers/apple/link
  Future<void> linkApple(LinkAppleProviderRequest request) async {
    _logService.debug(
      'POST link apple provider',
      category: LogCategory.network,
    );
    await _dio.post(ApiEndpoints.linkAppleProvider, data: request.toJson());
  }

  /// DELETE /api/v1/auth/providers/{provider_type}
  Future<void> unlinkProvider(String providerType) async {
    _logService.debug(
      'DELETE unlink provider: $providerType',
      category: LogCategory.network,
    );
    await _dio.delete(ApiEndpoints.unlinkProvider(providerType));
  }
}
