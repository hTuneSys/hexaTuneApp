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
import 'package:hexatuneapp/src/core/rest/flow/models/flow_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';

/// Repository for flow API calls.
@singleton
class FlowRepository {
  FlowRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/flows
  Future<PaginatedResponse<FlowResponse>> list({
    PaginationParams? params,
    String? packageId,
    String? locale,
  }) async {
    _logService.debug('GET flows', category: LogCategory.network);
    final queryParameters = <String, dynamic>{
      ...?params?.toQueryParameters(),
      if (packageId != null) 'package_id': packageId,
      if (locale != null) 'locale': locale,
    };
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.flows,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Flows response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (item) => FlowResponse.fromJson(item as Map<String, dynamic>),
    );
  }

  /// GET /api/v1/flows/{id}
  Future<FlowDetailResponse> getById(String id) async {
    _logService.debug('GET flow $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.flow(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Flow response body is null',
      );
    }
    return FlowDetailResponse.fromJson(data);
  }

  /// GET /api/v1/flows/labels
  Future<List<String>> listLabels() async {
    _logService.debug('GET flow labels', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.flowLabels);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Flow labels response body is null',
      );
    }
    return data.cast<String>();
  }

  /// GET /api/v1/flows/{id}/image
  Future<ImageUrlResponse> getImageUrl(String id, {String? locale}) async {
    _logService.debug('GET flow image $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.flowImage(id),
      queryParameters: locale != null ? {'locale': locale} : null,
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
