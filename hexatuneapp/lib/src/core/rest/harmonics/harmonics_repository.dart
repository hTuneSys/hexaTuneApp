// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';

/// Repository for harmonics API calls.
@singleton
class HarmonicsRepository {
  HarmonicsRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// POST /api/v1/harmonics/generate
  Future<GenerateHarmonicsResponse> generate(
    GenerateHarmonicsRequest request,
  ) async {
    _logService.debug('POST harmonics/generate', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.harmonicsGenerate,
      data: request.toJson(),
    );
    return GenerateHarmonicsResponse.fromJson(response.data!);
  }
}
