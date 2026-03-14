// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:hexatuneapp/src/core/network/api_exception.dart';
import 'package:hexatuneapp/src/core/network/interceptors/error_interceptor.dart';

void main() {
  group('ErrorInterceptor — ProblemDetails parsing', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      dio.interceptors.add(ErrorInterceptor());
    });

    Map<String, dynamic> problemDetails({
      required String type,
      required String title,
      required int status,
      required String detail,
      String? traceId,
    }) => {
      'type': type,
      'title': title,
      'status': status,
      'detail': detail,
      if (traceId != null) 'trace_id': traceId,
    };

    test('400 with ProblemDetails → BadRequestException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          400,
          problemDetails(
            type: 'https://api.example.com/errors/validation',
            title: 'Validation Error',
            status: 400,
            detail: 'Email format is invalid',
            traceId: 'abc-123',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<BadRequestException>());
        expect(error.message, 'Email format is invalid');
        expect(error.traceId, 'abc-123');
      }
    });

    test('401 with ProblemDetails → UnauthorizedException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          401,
          problemDetails(
            type: 'https://api.example.com/errors/unauthorized',
            title: 'Unauthorized',
            status: 401,
            detail: 'Token has expired',
            traceId: 'trace-401',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<UnauthorizedException>());
        expect(error.message, 'Token has expired');
        expect(error.traceId, 'trace-401');
      }
    });

    test(
      '403 with ProblemDetails → ForbiddenException with type as errorCode',
      () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(
            403,
            problemDetails(
              type: 'https://api.example.com/errors/reauth_required',
              title: 'Forbidden',
              status: 403,
              detail: 'Re-authentication required',
              traceId: 'trace-403',
            ),
          ),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          final error = e.error as ForbiddenException;
          expect(error, isA<ForbiddenException>());
          expect(
            error.errorCode,
            'https://api.example.com/errors/reauth_required',
          );
          expect(error.traceId, 'trace-403');
        }
      },
    );

    test('404 with ProblemDetails → NotFoundException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          404,
          problemDetails(
            type: 'https://api.example.com/errors/not-found',
            title: 'Not Found',
            status: 404,
            detail: 'Account not found',
            traceId: 'trace-404',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<NotFoundException>());
        expect(error.message, 'Account not found');
        expect(error.traceId, 'trace-404');
      }
    });

    test('409 with ProblemDetails → ConflictException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          409,
          problemDetails(
            type: 'https://api.example.com/errors/conflict',
            title: 'Conflict',
            status: 409,
            detail: 'Email already registered',
            traceId: 'trace-409',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<ConflictException>());
        expect(error.message, 'Email already registered');
        expect(error.traceId, 'trace-409');
      }
    });

    test('429 with ProblemDetails → RateLimitedException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          429,
          problemDetails(
            type: 'https://api.example.com/errors/rate-limited',
            title: 'Too Many Requests',
            status: 429,
            detail: 'Rate limit exceeded',
            traceId: 'trace-429',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<RateLimitedException>());
        expect(error.message, 'Rate limit exceeded');
        expect(error.traceId, 'trace-429');
      }
    });

    test('500 with ProblemDetails → ServerException', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(
          500,
          problemDetails(
            type: 'https://api.example.com/errors/internal',
            title: 'Internal Server Error',
            status: 500,
            detail: 'Something went wrong',
            traceId: 'trace-500',
          ),
        ),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ServerException;
        expect(error, isA<ServerException>());
        expect(error.message, 'Something went wrong');
        expect(error.traceId, 'trace-500');
        expect(error.statusCode, 500);
      }
    });

    test('non-ProblemDetails JSON falls back to message field', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(400, {'message': 'Fallback error message'}),
      );

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<BadRequestException>());
        expect(error.message, 'Fallback error message');
        expect(error.traceId, isNull);
      }
    });

    test('response with no body uses default message', () async {
      dioAdapter.onGet('/test', (server) => server.reply(400, null));

      try {
        await dio.get('/test');
        fail('Should throw');
      } on DioException catch (e) {
        final error = e.error as ApiException;
        expect(error, isA<BadRequestException>());
        expect(error.message, 'Bad request');
        expect(error.traceId, isNull);
      }
    });
  });
}
