// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Repository for category API calls.
@singleton
class CategoryRepository {
  CategoryRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/categories
  Future<PaginatedResponse<CategoryResponse>> list({
    PaginationParams? params,
  }) async {
    _logService.debug('GET categories', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.categories,
      queryParameters: params?.toQueryParameters(),
    );
    return PaginatedResponse.fromJson(
      response.data!,
      (item) => CategoryResponse.fromJson(item as Map<String, dynamic>),
    );
  }

  /// POST /api/v1/categories
  Future<CategoryResponse> create(CreateCategoryRequest request) async {
    _logService.debug('POST category', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.categories,
      data: request.toJson(),
    );
    return CategoryResponse.fromJson(response.data!);
  }

  /// GET /api/v1/categories/{id}
  Future<CategoryResponse> getById(String id) async {
    _logService.debug('GET category $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.category(id),
    );
    return CategoryResponse.fromJson(response.data!);
  }

  /// PATCH /api/v1/categories/{id}
  Future<CategoryResponse> update(
    String id,
    UpdateCategoryRequest request,
  ) async {
    _logService.debug('PATCH category $id', category: LogCategory.network);
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.category(id),
      data: request.toJson(),
    );
    return CategoryResponse.fromJson(response.data!);
  }

  /// DELETE /api/v1/categories/{id}
  Future<void> delete(String id) async {
    _logService.debug('DELETE category $id', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.category(id));
  }
}
