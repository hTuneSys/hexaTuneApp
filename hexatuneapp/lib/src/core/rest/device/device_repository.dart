// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approval_request_response_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

/// Repository for device and device-approval API calls.
@singleton
class DeviceRepository {
  DeviceRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// PUT /api/v1/devices/me/push-token
  Future<void> registerPushToken(RegisterPushTokenRequest request) async {
    _logService.debug('PUT push-token', category: LogCategory.network);
    await _dio.put(ApiEndpoints.pushToken, data: request.toJson());
  }

  /// DELETE /api/v1/devices/me/push-token
  Future<void> removePushToken() async {
    _logService.debug('DELETE push-token', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.pushToken);
  }

  /// POST /api/v1/device-approvals/request
  Future<ApprovalRequestResponseDto> requestApproval(
    CreateApprovalRequestDto request,
  ) async {
    _logService.debug(
      'POST device-approval request',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.deviceApprovalRequest,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Device approval request response body is null',
      );
    }
    return ApprovalRequestResponseDto.fromJson(data);
  }

  /// POST /api/v1/device-approvals/{id}/approve
  Future<ApprovalRequestResponseDto> approveRequest(
    String id,
    ApproveRequestDto request,
  ) async {
    _logService.debug(
      'POST device-approval approve',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.deviceApprovalApprove(id),
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Device approval approve response body is null',
      );
    }
    return ApprovalRequestResponseDto.fromJson(data);
  }

  /// POST /api/v1/device-approvals/{id}/reject
  Future<ApprovalRequestResponseDto> rejectRequest(
    String id,
    RejectRequestDto request,
  ) async {
    _logService.debug(
      'POST device-approval reject',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.deviceApprovalReject(id),
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Device approval reject response body is null',
      );
    }
    return ApprovalRequestResponseDto.fromJson(data);
  }

  /// GET /api/v1/device-approvals/{id}/status
  Future<ApprovalRequestResponseDto> checkApprovalStatus(String id) async {
    _logService.debug(
      'GET device-approval status',
      category: LogCategory.network,
    );
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.deviceApprovalStatus(id),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Device approval status response body is null',
      );
    }
    return ApprovalRequestResponseDto.fromJson(data);
  }
}
