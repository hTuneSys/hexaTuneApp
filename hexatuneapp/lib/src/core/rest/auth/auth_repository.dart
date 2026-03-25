// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/oauth_login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/otp_sent_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/register_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

/// Repository for all authentication-related API calls.
@singleton
class AuthRepository {
  AuthRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// POST /api/v1/auth/login
  Future<LoginResponse> login(LoginRequest request) async {
    _logService.debug('POST login', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Login response body is null',
      );
    }
    return LoginResponse.fromJson(data);
  }

  /// POST /api/v1/auth/register
  Future<RegisterResponse> register(CreateAccountRequest request) async {
    _logService.debug('POST register', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Register response body is null',
      );
    }
    return RegisterResponse.fromJson(data);
  }

  /// DELETE /api/v1/auth/logout
  Future<void> logout() async {
    _logService.debug('DELETE logout', category: LogCategory.network);
    await _dio.delete(ApiEndpoints.logout);
  }

  /// POST /api/v1/auth/refresh
  Future<RefreshResponse> refresh(RefreshRequest request) async {
    _logService.debug('POST refresh', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Refresh response body is null',
      );
    }
    return RefreshResponse.fromJson(data);
  }

  /// POST /api/v1/auth/reauth
  Future<ReAuthResponse> reAuthenticate(ReAuthRequest request) async {
    _logService.debug('POST reauth', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.reAuth,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'ReAuth response body is null',
      );
    }
    return ReAuthResponse.fromJson(data);
  }

  /// POST /api/v1/auth/forgot-password
  Future<OtpSentResponse> forgotPassword(ForgotPasswordRequest request) async {
    _logService.debug('POST forgot-password', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Forgot password response body is null',
      );
    }
    return OtpSentResponse.fromJson(data);
  }

  /// POST /api/v1/auth/reset-password
  Future<void> resetPassword(ResetPasswordRequest request) async {
    _logService.debug('POST reset-password', category: LogCategory.network);
    await _dio.post(ApiEndpoints.resetPassword, data: request.toJson());
  }

  /// POST /api/v1/auth/resend-password-reset
  Future<OtpSentResponse> resendPasswordReset(
    ResendPasswordResetRequest request,
  ) async {
    _logService.debug(
      'POST resend-password-reset',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.resendPasswordReset,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Resend password reset response body is null',
      );
    }
    return OtpSentResponse.fromJson(data);
  }

  /// POST /api/v1/auth/verify-email
  Future<void> verifyEmail(VerifyEmailRequest request) async {
    _logService.debug('POST verify-email', category: LogCategory.network);
    await _dio.post(ApiEndpoints.verifyEmail, data: request.toJson());
  }

  /// POST /api/v1/auth/resend-verification
  Future<OtpSentResponse> resendVerification(
    ResendVerificationRequest request,
  ) async {
    _logService.debug(
      'POST resend-verification',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.resendVerification,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Resend verification response body is null',
      );
    }
    return OtpSentResponse.fromJson(data);
  }

  /// POST /api/v1/auth/google
  Future<OAuthLoginResponse> loginWithGoogle(GoogleAuthRequest request) async {
    _logService.debug('POST auth/google', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authGoogle,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Google auth response body is null',
      );
    }
    return OAuthLoginResponse.fromJson(data);
  }

  /// POST /api/v1/auth/apple
  Future<OAuthLoginResponse> loginWithApple(AppleAuthRequest request) async {
    _logService.debug('POST auth/apple', category: LogCategory.network);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authApple,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Apple auth response body is null',
      );
    }
    return OAuthLoginResponse.fromJson(data);
  }
}
