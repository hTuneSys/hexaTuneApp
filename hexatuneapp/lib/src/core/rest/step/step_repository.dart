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
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';

/// Repository for step API calls.
@singleton
class StepRepository {
  StepRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/steps
  Future<PaginatedResponse<StepResponse>> list({
    PaginationParams? params,
    String? locale,
  }) async {
    _logService.debug('GET steps', category: LogCategory.network);
    final queryParameters = <String, dynamic>{
      ...?params?.toQueryParameters(),
      if (locale != null) 'locale': locale,
    };
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.steps,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Steps response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (item) => StepResponse.fromJson(item as Map<String, dynamic>),
    );
  }

  /// GET /api/v1/steps/{id}
  Future<StepResponse> getById(String id) async {
    _logService.debug('GET step $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.step(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Step response body is null',
      );
    }
    return StepResponse.fromJson(data);
  }

  /// GET /api/v1/steps/labels
  Future<List<String>> listLabels() async {
    _logService.debug('GET step labels', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.stepLabels);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Step labels response body is null',
      );
    }
    return data.cast<String>();
  }

  /// GET /api/v1/steps/{id}/image
  Future<ImageUrlResponse> getImageUrl(String id) async {
    _logService.debug('GET step image $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.stepImage(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Image URL response body is null',
      );
    }
    return ImageUrlResponse.fromJson(data);
  }
}
