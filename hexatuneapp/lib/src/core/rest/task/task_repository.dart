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
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_status_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_summary_dto.dart';

/// Repository for task API calls.
@singleton
class TaskRepository {
  TaskRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/tasks
  Future<PaginatedResponse<TaskSummaryDto>> list({
    PaginationParams? params,
    String? status,
    String? taskType,
  }) async {
    _logService.debug('GET tasks', category: LogCategory.network);
    final queryParameters = <String, dynamic>{
      ...?params?.toQueryParameters(),
      if (status != null) 'status': status,
      if (taskType != null) 'taskType': taskType,
    };
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Tasks response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (json) => TaskSummaryDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/v1/tasks
  Future<CreateTaskResponse> create(CreateTaskRequest request) async {
    _logService.debug('POST task', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Create task response body is null',
      );
    }
    return CreateTaskResponse.fromJson(data);
  }

  /// GET /api/v1/tasks/{id}
  Future<TaskStatusResponse> getStatus(String id) async {
    _logService.debug('GET task $id', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.task(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Task status response body is null',
      );
    }
    return TaskStatusResponse.fromJson(data);
  }

  /// POST /api/v1/tasks/{id}/cancel
  Future<CancelTaskResponse> cancel(
    String id,
    CancelTaskRequest request,
  ) async {
    _logService.debug('POST task $id cancel', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.taskCancel(id),
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Cancel task response body is null',
      );
    }
    return CancelTaskResponse.fromJson(data);
  }
}
