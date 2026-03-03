// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Repository for inventory API calls.
@singleton
class InventoryRepository {
  InventoryRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/inventories
  Future<PaginatedResponse<InventoryResponse>> list({
    PaginationParams? params,
  }) async {
    _logService.debug('GET inventories', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.inventories,
      queryParameters: params?.toQueryParameters(),
    );
    return PaginatedResponse.fromJson(
      response.data!,
      (item) => InventoryResponse.fromJson(item as Map<String, dynamic>),
    );
  }

  /// POST /api/v1/inventories (multipart)
  Future<InventoryResponse> create({
    required String categoryId,
    required String name,
    String? description,
    List<String>? labels,
    dynamic imageFile,
  }) async {
    _logService.debug('POST inventory', category: LogCategory.network);
    final formData = FormData.fromMap(<String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      if (description != null) 'description': description,
      if (labels != null) 'labels': jsonEncode(labels),
      if (imageFile != null)
        'image': await MultipartFile.fromFile(imageFile.path as String),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.inventories,
      data: formData,
    );
    return InventoryResponse.fromJson(response.data!);
  }

  /// GET /api/v1/inventories/{id}
  Future<InventoryResponse> getById(String id) async {
    _logService.debug('GET inventory $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.inventory(id),
    );
    return InventoryResponse.fromJson(response.data!);
  }

  /// PATCH /api/v1/inventories/{id} (multipart)
  Future<InventoryResponse> update(
    String id, {
    String? categoryId,
    String? name,
    String? description,
    List<String>? labels,
    dynamic imageFile,
  }) async {
    _logService.debug('PATCH inventory $id', category: LogCategory.network);
    final formData = FormData.fromMap(<String, dynamic>{
      if (categoryId != null) 'categoryId': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (labels != null) 'labels': jsonEncode(labels),
      if (imageFile != null)
        'image': await MultipartFile.fromFile(imageFile.path as String),
    });
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.inventory(id),
      data: formData,
    );
    return InventoryResponse.fromJson(response.data!);
  }

  /// DELETE /api/v1/inventories/{id}
  Future<void> delete(String id) async {
    _logService.debug('DELETE inventory $id', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.inventory(id));
  }

  /// GET /api/v1/inventories/{id}/image
  Future<ImageUrlResponse> getImageUrl(String id) async {
    _logService.debug('GET inventory image $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.inventoryImage(id),
    );
    return ImageUrlResponse.fromJson(response.data!);
  }
}
