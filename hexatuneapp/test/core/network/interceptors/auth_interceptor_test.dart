// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';

class MockTokenManager extends Mock implements TokenManager {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('AuthInterceptor', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late AuthInterceptor interceptor;
    late MockTokenManager mockTokenManager;
    late MockLogService mockLogService;

    setUp(() {
      mockTokenManager = MockTokenManager();
      mockLogService = MockLogService();
      interceptor = AuthInterceptor(mockTokenManager, mockLogService);

      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      dio.interceptors.add(interceptor);
    });

    tearDown(() {
      interceptor.dispose();
    });

    group('onRequest adds Authorization header', () {
      test('adds Bearer token when token exists', () async {
        when(() => mockTokenManager.accessToken).thenReturn('my-token');

        dioAdapter.onGet('/test', (server) => server.reply(200, {'ok': true}));

        final response = await dio.get('/test');
        expect(response.statusCode, 200);
      });

      test('does not add header when no token', () async {
        when(() => mockTokenManager.accessToken).thenReturn(null);

        dioAdapter.onGet('/test', (server) => server.reply(200, {'ok': true}));

        final response = await dio.get('/test');
        expect(response.statusCode, 200);
      });
    });

    group('auth events on 403', () {
      test('emits reAuthRequired on reauth_required error code', () async {
        when(() => mockTokenManager.accessToken).thenReturn('token');

        dioAdapter.onGet(
          '/protected',
          (server) => server.reply(403, {'error_code': 'reauth_required'}),
        );

        final events = <AuthEvent>[];
        interceptor.authEvents.listen(events.add);

        try {
          await dio.get('/protected');
        } on DioException {
          // Expected.
        }

        await Future<void>.delayed(Duration.zero);
        expect(events, contains(AuthEvent.reAuthRequired));
      });

      test(
        'emits deviceApprovalRequired on device_approval_required',
        () async {
          when(() => mockTokenManager.accessToken).thenReturn('token');

          dioAdapter.onGet(
            '/protected',
            (server) =>
                server.reply(403, {'error_code': 'device_approval_required'}),
          );

          final events = <AuthEvent>[];
          interceptor.authEvents.listen(events.add);

          try {
            await dio.get('/protected');
          } on DioException {
            // Expected.
          }

          await Future<void>.delayed(Duration.zero);
          expect(events, contains(AuthEvent.deviceApprovalRequired));
        },
      );
    });
  });
}
