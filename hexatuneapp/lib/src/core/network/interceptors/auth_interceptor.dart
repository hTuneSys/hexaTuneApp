// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Handles authentication headers, silent token refresh on 401,
/// and signals re-auth / device-approval on 403.
///
/// Extends [QueuedInterceptor] so that concurrent requests
/// wait while a token refresh is in progress.
@singleton
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokenManager, this._logService);

  final TokenManager _tokenManager;
  final LogService _logService;

  /// Stream controller for auth-related navigation events.
  final _authEventController = StreamController<AuthEvent>.broadcast();

  /// Listen to this stream to react to forced logout, re-auth, or
  /// device-approval requirements.
  Stream<AuthEvent> get authEvents => _authEventController.stream;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenManager.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (Env.isDev) {
      _logService.devLog(
        '→ ${options.method} ${options.uri} '
        '| auth: ${token != null ? 'Bearer ${LogService.maskToken(token)}' : 'none'}',
        category: LogCategory.auth,
      );
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401 && _tokenManager.refreshToken != null) {
      if (Env.isDev) {
        _logService.devLog(
          '⚠ 401 received for ${err.requestOptions.method} ${err.requestOptions.uri} '
          '| body: ${err.response?.data}',
          category: LogCategory.auth,
        );
      }
      final refreshed = await _tryRefresh(err.requestOptions);
      if (refreshed) {
        // Retry the original request with the new token.
        try {
          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] =
              'Bearer ${_tokenManager.accessToken}';

          if (Env.isDev) {
            _logService.devLog(
              '↻ Retrying ${retryOptions.method} ${retryOptions.uri} with new token',
              category: LogCategory.auth,
            );
          }

          final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
          final response = await dio.fetch(retryOptions);
          if (Env.isDev) {
            _logService.devLog(
              '✓ Retry succeeded: ${response.statusCode}',
              category: LogCategory.auth,
            );
          }
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          if (Env.isDev) {
            _logService.devLog(
              '✗ Retry failed: ${retryErr.response?.statusCode} ${retryErr.message}',
              category: LogCategory.auth,
            );
          }
          return handler.reject(retryErr);
        }
      }
      // Refresh failed — force logout.
      if (Env.isDev) {
        _logService.devLog(
          '✗ Token refresh failed → force logout',
          category: LogCategory.auth,
        );
      }
      _authEventController.add(AuthEvent.forceLogout);
      return handler.reject(err);
    }

    if (statusCode == 403) {
      final data = err.response?.data;
      final errorCode = data is Map<String, dynamic>
          ? data['error_code'] as String?
          : null;

      if (Env.isDev) {
        _logService.devLog(
          '⚠ 403 received for ${err.requestOptions.uri} '
          '| error_code: $errorCode | body: $data',
          category: LogCategory.auth,
        );
      }

      if (errorCode == 'reauth_required') {
        _authEventController.add(AuthEvent.reAuthRequired);
      } else if (errorCode == 'device_approval_required') {
        _authEventController.add(AuthEvent.deviceApprovalRequired);
      }
    }

    handler.next(err);
  }

  Future<bool> _tryRefresh(RequestOptions originalRequest) async {
    _logService.info(
      'Attempting silent token refresh',
      category: LogCategory.auth,
    );

    try {
      final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
      final refreshData = {'refreshToken': _tokenManager.refreshToken};
      if (Env.isDev) {
        _logService.devLog(
          '→ POST ${ApiEndpoints.refresh} | data: '
          '{refreshToken: ${LogService.maskToken(_tokenManager.refreshToken)}}',
          category: LogCategory.auth,
        );
      }
      final response = await dio.post(
        ApiEndpoints.refresh,
        data: refreshData,
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        final sessionId = data['sessionId'] as String?;
        final expiresAt = data['expiresAt'] as String?;

        if (Env.isDev) {
          _logService.devLog(
            '← Refresh response: accessToken=${LogService.maskToken(newAccessToken)}, '
            'refreshToken=${LogService.maskToken(newRefreshToken)}, '
            'sessionId=$sessionId, expiresAt=$expiresAt',
            category: LogCategory.auth,
          );
        }

        if (newAccessToken != null && newRefreshToken != null) {
          await _tokenManager.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            sessionId: sessionId,
            expiresAt: expiresAt,
          );
          _logService.info(
            'Token refresh successful',
            category: LogCategory.auth,
          );
          return true;
        }
      }
    } catch (e) {
      _logService.error(
        'Token refresh failed',
        category: LogCategory.auth,
        exception: e,
      );
    }

    await _tokenManager.clearTokens();
    return false;
  }

  void dispose() {
    _authEventController.close();
  }
}

/// Events emitted by [AuthInterceptor] for navigation decisions.
enum AuthEvent { forceLogout, reAuthRequired, deviceApprovalRequired }
