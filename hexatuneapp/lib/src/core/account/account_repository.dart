// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

/// Repository for account and profile API calls.
@singleton
class AccountRepository {
  AccountRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/accounts/me
  Future<AccountResponse> getAccount() async {
    _logService.debug('GET account', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.account,
    );
    return AccountResponse.fromJson(response.data!);
  }

  /// GET /api/v1/accounts/me/profile
  Future<ProfileResponse> getProfile() async {
    _logService.debug('GET profile', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
    );
    return ProfileResponse.fromJson(response.data!);
  }

  /// PATCH /api/v1/accounts/me/profile
  Future<ProfileResponse> updateProfile(
    UpdateProfileRequest request,
  ) async {
    _logService.debug('PATCH profile', category: LogCategory.network);
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.profile,
      data: request.toJson(),
    );
    return ProfileResponse.fromJson(response.data!);
  }
}
