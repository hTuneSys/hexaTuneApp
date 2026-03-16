// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/debug_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/error_interceptor.dart';
import 'package:hexatuneapp/src/core/network/interceptors/logging_interceptor.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthInterceptor extends Mock implements AuthInterceptor {}

class MockErrorInterceptor extends Mock implements ErrorInterceptor {}

class MockLoggingInterceptor extends Mock implements LoggingInterceptor {}

class MockTalkerDioLogger extends Mock implements TalkerDioLogger {}

void main() {
  group('ApiClient', () {
    late MockLogService mockLogService;
    late MockAuthInterceptor mockAuthInterceptor;
    late MockErrorInterceptor mockErrorInterceptor;
    late MockLoggingInterceptor mockLoggingInterceptor;
    late MockTalkerDioLogger mockTalkerDioLogger;
    late ApiClient apiClient;

    setUp(() {
      mockLogService = MockLogService();
      mockAuthInterceptor = MockAuthInterceptor();
      mockErrorInterceptor = MockErrorInterceptor();
      mockLoggingInterceptor = MockLoggingInterceptor();
      mockTalkerDioLogger = MockTalkerDioLogger();

      when(
        () => mockLoggingInterceptor.interceptor,
      ).thenReturn(mockTalkerDioLogger);

      apiClient = ApiClient(
        mockLogService,
        mockAuthInterceptor,
        mockErrorInterceptor,
        mockLoggingInterceptor,
      );
      apiClient.init();
    });

    test('can be instantiated and initialized', () {
      expect(apiClient, isNotNull);
      expect(apiClient.dio, isA<Dio>());
    });

    test('dio has correct timeout configuration', () {
      final options = apiClient.dio.options;
      expect(options.connectTimeout, AppConstants.connectTimeout);
      expect(options.receiveTimeout, AppConstants.receiveTimeout);
      expect(options.sendTimeout, AppConstants.sendTimeout);
    });

    test('dio has correct default headers', () {
      final options = apiClient.dio.options;
      expect(options.contentType, 'application/json');
      expect(options.headers['Accept'], 'application/json');
    });

    test('dio has the expected interceptors added', () {
      final interceptors = apiClient.dio.interceptors;
      // Dio adds its own ImplyContentTypeInterceptor, plus our 4
      expect(interceptors, hasLength(5));
      expect(interceptors.whereType<DebugDioInterceptor>(), hasLength(1));
    });

    test('logs initialization message', () {
      verify(
        () => mockLogService.info(any(that: contains('ApiClient'))),
      ).called(1);
    });
  });
}
