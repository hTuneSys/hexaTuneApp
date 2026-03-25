// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/network/api_error_type.dart';
import 'package:hexatuneapp/src/core/network/api_exception.dart';
import 'package:hexatuneapp/src/core/network/models/problem_details.dart';

/// Maps raw [DioException]s into typed [ApiException]s.
///
/// Parses RFC 7807 [ProblemDetails] from error response bodies when
/// available, falling back to generic status-code mapping.
@singleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _mapException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
      ),
    );
  }

  ApiException _mapException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException.timeout();

      case DioExceptionType.cancel:
        return const ApiException.cancelled();

      case DioExceptionType.connectionError:
        return const ApiException.network();

      case DioExceptionType.badResponse:
        return _mapStatusCode(err.response);

      case DioExceptionType.badCertificate:
        return const ApiException.network(
          message: 'Certificate verification failed',
        );

      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          return const ApiException.network();
        }
        return ApiException.unknown(error: err.error);
    }
  }

  ApiException _mapStatusCode(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to parse RFC 7807 ProblemDetails.
    final problem = _tryParseProblemDetails(data);
    final message = problem?.detail ?? _extractMessage(data);
    final errorType = problem?.type != null
        ? ApiErrorType.normalize(problem!.type)
        : null;

    switch (statusCode) {
      case 400:
        final errors = data is Map<String, dynamic>
            ? data['errors'] as Map<String, dynamic>?
            : null;
        return ApiException.badRequest(
          message: message ?? 'Bad request',
          errors: errors,
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 401:
        return ApiException.unauthorized(
          message: message ?? 'Authentication required',
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 403:
        final errorCode = data is Map<String, dynamic>
            ? data['error_code'] as String?
            : null;
        return ApiException.forbidden(
          message: message ?? 'Access denied',
          errorCode: errorCode ?? errorType,
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 404:
        return ApiException.notFound(
          message: message ?? 'Resource not found',
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 409:
        return ApiException.conflict(
          message: message ?? 'Resource conflict',
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 422:
        return ApiException.badRequest(
          message: message ?? 'Validation failed',
          errorType: errorType,
          traceId: problem?.traceId,
        );
      case 429:
        return ApiException.rateLimited(
          message: message ?? 'Too many requests',
          errorType: errorType,
          traceId: problem?.traceId,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiException.server(
            message: message ?? 'Server error',
            statusCode: statusCode,
            errorType: errorType,
            traceId: problem?.traceId,
          );
        }
        return ApiException.unknown(
          message: message ?? 'Unexpected error ($statusCode)',
          errorType: errorType,
        );
    }
  }

  ProblemDetails? _tryParseProblemDetails(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    if (!data.containsKey('type') || !data.containsKey('status')) {
      return null;
    }
    try {
      return ProblemDetails.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['detail'] as String?;
    }
    return null;
  }
}
