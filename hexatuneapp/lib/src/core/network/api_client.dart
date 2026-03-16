// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/debug_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/error_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/logging_interceptor.dart';

/// Factory and holder for the application-wide [Dio] instance.
@singleton
class ApiClient {
  ApiClient(
    this._logService,
    this._authInterceptor,
    this._errorInterceptor,
    this._loggingInterceptor,
  );

  final LogService _logService;
  final AuthInterceptor _authInterceptor;
  final ErrorInterceptor _errorInterceptor;
  final LoggingInterceptor _loggingInterceptor;

  late final Dio _dio;

  Dio get dio => _dio;

  @PostConstruct()
  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Order matters: debug buffer → logging → auth → error
    _dio.interceptors.addAll([
      DebugDioInterceptor(),
      _loggingInterceptor.interceptor,
      _authInterceptor,
      _errorInterceptor,
    ]);

    _logService.info('ApiClient initialized — baseUrl: ${Env.apiBaseUrl}');
  }
}
