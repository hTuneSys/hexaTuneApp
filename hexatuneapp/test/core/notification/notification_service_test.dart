// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';

class MockLogService extends Mock implements LogService {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

void main() {
  group('NotificationService', () {
    late MockLogService mockLogService;
    late MockLocalNotificationService mockLocalNotificationService;
    late NotificationService service;

    setUp(() {
      mockLogService = MockLogService();
      mockLocalNotificationService = MockLocalNotificationService();
      service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
    });

    test('can be instantiated', () {
      expect(service, isNotNull);
    });

    test('isAvailable is initially false', () {
      expect(service.isAvailable, false);
    });

    test('fcmToken is initially null', () {
      expect(service.fcmToken, isNull);
    });

    test('onTokenRefresh callback can be set', () {
      var called = false;
      service.onTokenRefresh = (_) => called = true;
      expect(called, isFalse);
    });

    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });

    test('constructor injects LogService and LocalNotificationService', () {
      // Verifies DI wiring — both services must be provided.
      final svc = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      expect(svc, isA<NotificationService>());
    });
  });

  group('LocalNotificationService', () {
    test('can be instantiated', () {
      final service = LocalNotificationService(MockLogService());
      expect(service, isNotNull);
    });
  });

  group('firebaseMessagingBackgroundHandler', () {
    test('top-level handler function exists', () {
      expect(firebaseMessagingBackgroundHandler, isA<Function>());
    });
  });
}
