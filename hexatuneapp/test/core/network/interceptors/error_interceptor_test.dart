// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:hexatuneapp/src/core/network/api_exception.dart';
import 'package:hexatuneapp/src/core/network/interceptors/error_interceptor.dart';

void main() {
  group('ErrorInterceptor', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      dio.interceptors.add(ErrorInterceptor());
    });

    group('HTTP status codes', () {
      test('maps 400 to BadRequestException', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(400, {
            'message': 'Validation failed',
            'errors': {'email': 'required'},
          }),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          final apiEx = e.error as BadRequestException;
          expect(apiEx.message, 'Validation failed');
          expect(apiEx.errors, {'email': 'required'});
        }
      });

      test('maps 401 to UnauthorizedException', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(401, {
            'message': 'Token expired',
          }),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          expect(e.error, isA<UnauthorizedException>());
        }
      });

      test('maps 403 to ForbiddenException with error_code', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(403, {
            'message': 'Re-authentication needed',
            'error_code': 'reauth_required',
          }),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          final apiEx = e.error as ForbiddenException;
          expect(apiEx.errorCode, 'reauth_required');
        }
      });

      test('maps 404 to NotFoundException', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(404, null),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          expect(e.error, isA<NotFoundException>());
        }
      });

      test('maps 500 to ServerException with status code', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(500, null),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          final apiEx = e.error as ServerException;
          expect(apiEx.statusCode, 500);
        }
      });

      test('maps 503 to ServerException', () async {
        dioAdapter.onGet(
          '/test',
          (server) => server.reply(503, null),
        );

        try {
          await dio.get('/test');
          fail('Should throw');
        } on DioException catch (e) {
          final apiEx = e.error as ServerException;
          expect(apiEx.statusCode, 503);
        }
      });
    });
  });
}
