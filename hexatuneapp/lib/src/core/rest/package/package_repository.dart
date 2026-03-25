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
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';

/// Repository for package API calls.
@singleton
class PackageRepository {
  PackageRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/packages
  Future<PaginatedResponse<PackageResponse>> list({
    PaginationParams? params,
    String? locale,
  }) async {
    _logService.debug('GET packages', category: LogCategory.network);
    final queryParameters = <String, dynamic>{
      ...?params?.toQueryParameters(),
      if (locale != null) 'locale': locale,
    };
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.packages,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Packages response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (item) => PackageResponse.fromJson(item as Map<String, dynamic>),
    );
  }

  /// GET /api/v1/packages/{id}
  Future<PackageResponse> getById(String id) async {
    _logService.debug('GET package $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.package(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Package response body is null',
      );
    }
    return PackageResponse.fromJson(data);
  }

  /// GET /api/v1/packages/labels
  Future<List<String>> listLabels() async {
    _logService.debug('GET package labels', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.packageLabels);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Package labels response body is null',
      );
    }
    return data.cast<String>();
  }

  /// GET /api/v1/packages/{id}/image
  Future<ImageUrlResponse> getImageUrl(String id, {String? locale}) async {
    _logService.debug('GET package image $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.packageImage(id),
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
