// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/device/device_service.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';

class MockLogService extends Mock implements LogService {}

class MockDeviceService extends Mock implements DeviceService {}

class MockTokenManager extends Mock implements TokenManager {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AppBootstrap', () {
    late MockLogService mockLog;
    late MockDeviceService mockDevice;
    late MockTokenManager mockTokenManager;
    late MockLocalNotificationService mockLocalNotif;
    late MockNotificationService mockNotif;
    late MockAuthService mockAuth;

    setUp(() {
      mockLog = MockLogService();
      mockDevice = MockDeviceService();
      mockTokenManager = MockTokenManager();
      mockLocalNotif = MockLocalNotificationService();
      mockNotif = MockNotificationService();
      mockAuth = MockAuthService();

      // Register mocks in get_it.
      getIt.allowReassignment = true;
      getIt.registerSingleton<LogService>(mockLog);
      getIt.registerSingleton<DeviceService>(mockDevice);
      getIt.registerSingleton<TokenManager>(mockTokenManager);
      getIt.registerSingleton<LocalNotificationService>(mockLocalNotif);
      getIt.registerSingleton<NotificationService>(mockNotif);
      getIt.registerSingleton<AuthService>(mockAuth);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('calls all services in order', () async {
      when(() => mockDevice.init()).thenAnswer((_) async {});
      when(() => mockDevice.deviceId).thenReturn('test-device-id');
      when(() => mockTokenManager.loadTokens()).thenAnswer((_) async {});
      when(() => mockTokenManager.hasToken).thenReturn(false);
      when(() => mockTokenManager.sessionId).thenReturn(null);
      when(() => mockTokenManager.expiresAt).thenReturn(null);
      when(() => mockLocalNotif.init()).thenAnswer((_) async {});
      when(() => mockNotif.init()).thenAnswer((_) async {});
      when(() => mockNotif.fcmToken).thenReturn(null);
      when(() => mockAuth.checkAuthStatus()).thenAnswer((_) async {});
      when(() => mockAuth.currentState).thenReturn(AuthState.unauthenticated);
      when(
        () => mockAuth.authEvents,
      ).thenAnswer((_) => const Stream<AuthEvent>.empty());

      await AppBootstrap.initialize();

      verifyInOrder([
        () => mockDevice.init(),
        () => mockTokenManager.loadTokens(),
        () => mockLocalNotif.init(),
        () => mockNotif.init(),
        () => mockAuth.checkAuthStatus(),
      ]);
    });

    test('continues when notification service fails', () async {
      when(() => mockDevice.init()).thenAnswer((_) async {});
      when(() => mockDevice.deviceId).thenReturn('test-device-id');
      when(() => mockTokenManager.loadTokens()).thenAnswer((_) async {});
      when(() => mockTokenManager.hasToken).thenReturn(false);
      when(() => mockTokenManager.sessionId).thenReturn(null);
      when(() => mockTokenManager.expiresAt).thenReturn(null);
      when(() => mockLocalNotif.init()).thenAnswer((_) async {});
      when(() => mockNotif.init()).thenThrow(Exception('No Firebase'));
      when(() => mockAuth.checkAuthStatus()).thenAnswer((_) async {});
      when(() => mockAuth.currentState).thenReturn(AuthState.unauthenticated);
      when(
        () => mockAuth.authEvents,
      ).thenAnswer((_) => const Stream<AuthEvent>.empty());

      // Should not throw despite notification failure.
      await AppBootstrap.initialize();

      // Auth check should still be called.
      verify(() => mockAuth.checkAuthStatus()).called(1);
    });

    test('rethrows on critical failure', () async {
      when(() => mockDevice.init()).thenThrow(StateError('Device init failed'));

      expect(() => AppBootstrap.initialize(), throwsStateError);
    });
  });
}
