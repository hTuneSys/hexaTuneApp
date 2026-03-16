// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';

class MockLogService extends Mock implements LogService {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

void main() {
  group('NotificationService', () {
    late MockLogService mockLogService;
    late MockLocalNotificationService mockLocalNotificationService;

    setUp(() {
      mockLogService = MockLogService();
      mockLocalNotificationService = MockLocalNotificationService();
    });

    test('can be instantiated', () {
      final service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      expect(service, isNotNull);
    });

    test('isAvailable is initially false', () {
      final service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      expect(service.isAvailable, false);
    });

    test('fcmToken is initially null', () {
      final service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      expect(service.fcmToken, isNull);
    });

    test('onTokenRefresh callback can be set', () {
      final service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      var called = false;
      service.onTokenRefresh = (_) => called = true;
      expect(called, isFalse);
    });

    test('dispose does not throw', () {
      final service = NotificationService(
        mockLogService,
        mockLocalNotificationService,
      );
      expect(() => service.dispose(), returnsNormally);
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
