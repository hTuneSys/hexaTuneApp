// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  group('NotificationService', () {
    late MockLogService mockLogService;

    setUp(() {
      mockLogService = MockLogService();
    });

    test('can be instantiated', () {
      final service = NotificationService(mockLogService);
      expect(service, isNotNull);
    });

    test('isAvailable is initially false', () {
      final service = NotificationService(mockLogService);
      expect(service.isAvailable, false);
    });

    test('fcmToken is initially null', () {
      final service = NotificationService(mockLogService);
      expect(service.fcmToken, isNull);
    });
  });

  group('LocalNotificationService', () {
    test('can be instantiated', () {
      final service = LocalNotificationService(MockLogService());
      expect(service, isNotNull);
    });
  });
}
