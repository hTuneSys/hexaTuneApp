// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Repository for formula API calls.
@singleton
class FormulaRepository {
  FormulaRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/formulas
  Future<PaginatedResponse<FormulaResponse>> list({
    PaginationParams? params,
  }) async {
    _logService.debug('GET formulas', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.formulas,
      queryParameters: params?.toQueryParameters() ?? {},
    );
    return PaginatedResponse.fromJson(
      response.data!,
      (json) => FormulaResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/v1/formulas
  Future<FormulaResponse> create(CreateFormulaRequest request) async {
    _logService.debug('POST formula', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.formulas,
      data: request.toJson(),
    );
    return FormulaResponse.fromJson(response.data!);
  }

  /// GET /api/v1/formulas/{id}
  Future<FormulaDetailResponse> getById(String id) async {
    _logService.debug('GET formula $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.formula(id),
    );
    return FormulaDetailResponse.fromJson(response.data!);
  }

  /// PATCH /api/v1/formulas/{id}
  Future<FormulaResponse> update(
    String id,
    UpdateFormulaRequest request,
  ) async {
    _logService.debug('PATCH formula $id', category: LogCategory.network);
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.formula(id),
      data: request.toJson(),
    );
    return FormulaResponse.fromJson(response.data!);
  }

  /// DELETE /api/v1/formulas/{id}
  Future<void> delete(String id) async {
    _logService.debug('DELETE formula $id', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.formula(id));
  }

  /// POST /api/v1/formulas/{formulaId}/items
  Future<List<FormulaItemResponse>> addItems(
    String formulaId,
    AddFormulaItemsRequest request,
  ) async {
    _logService.debug(
      'POST formula $formulaId items',
      category: LogCategory.network,
    );
    final response = await _dio.post<List<dynamic>>(
      ApiEndpoints.formulaItems(formulaId),
      data: request.toJson(),
    );
    return response.data!
        .map((e) => FormulaItemResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// DELETE /api/v1/formulas/{formulaId}/items/{itemId}
  Future<void> removeItem(String formulaId, String itemId) async {
    _logService.debug(
      'DELETE formula $formulaId item $itemId',
      category: LogCategory.network,
    );
    await _dio.delete(ApiEndpoints.formulaItem(formulaId, itemId));
  }

  /// PATCH /api/v1/formulas/{formulaId}/items/{itemId}
  Future<FormulaItemResponse> updateItemQuantity(
    String formulaId,
    String itemId,
    UpdateFormulaItemQuantityRequest request,
  ) async {
    _logService.debug(
      'PATCH formula $formulaId item $itemId quantity',
      category: LogCategory.network,
    );
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.formulaItem(formulaId, itemId),
      data: request.toJson(),
    );
    return FormulaItemResponse.fromJson(response.data!);
  }

  /// PUT /api/v1/formulas/{formulaId}/items/reorder
  Future<void> reorderItems(
    String formulaId,
    ReorderFormulaItemsRequest request,
  ) async {
    _logService.debug(
      'PUT formula $formulaId items reorder',
      category: LogCategory.network,
    );
    await _dio.put(
      ApiEndpoints.formulaItemsReorder(formulaId),
      data: request.toJson(),
    );
  }
}
