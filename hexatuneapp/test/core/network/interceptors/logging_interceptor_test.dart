// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/logging_interceptor.dart';

class MockLogService extends Mock implements LogService {}

class MockTalker extends Mock implements Talker {}

void main() {
  group('LoggingInterceptor', () {
    late MockLogService mockLogService;
    late MockTalker mockTalker;

    setUp(() {
      mockLogService = MockLogService();
      mockTalker = MockTalker();
      when(() => mockLogService.talker).thenReturn(mockTalker);
    });

    test('can be instantiated with LogService', () {
      final interceptor = LoggingInterceptor(mockLogService);
      expect(interceptor, isNotNull);
    });

    test('init creates TalkerDioLogger interceptor', () {
      final loggingInterceptor = LoggingInterceptor(mockLogService);
      loggingInterceptor.init();

      expect(loggingInterceptor.interceptor, isNotNull);
    });

    test('interceptor uses LogService talker instance', () {
      final loggingInterceptor = LoggingInterceptor(mockLogService);
      loggingInterceptor.init();

      // Verify that the talker getter was accessed during init
      verify(() => mockLogService.talker).called(1);
    });

    test('interceptor settings enable request headers', () {
      final loggingInterceptor = LoggingInterceptor(mockLogService);
      loggingInterceptor.init();

      final dio = loggingInterceptor.interceptor;
      expect(dio.settings.printRequestHeaders, isTrue);
    });

    test('interceptor settings enable response message', () {
      final loggingInterceptor = LoggingInterceptor(mockLogService);
      loggingInterceptor.init();

      final dio = loggingInterceptor.interceptor;
      expect(dio.settings.printResponseMessage, isTrue);
    });
  });
}
