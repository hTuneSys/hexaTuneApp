// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approval_request_response_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/device_response.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/unregister_push_token_request.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_devices_page.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockDeviceService extends Mock implements DeviceService {}

class MockLogService extends Mock implements LogService {}

class MockNotificationService extends Mock implements NotificationService {}

class FakeRegisterPushTokenRequest extends Fake
    implements RegisterPushTokenRequest {}

class FakeUnregisterPushTokenRequest extends Fake
    implements UnregisterPushTokenRequest {}

class FakeCreateApprovalRequestDto extends Fake
    implements CreateApprovalRequestDto {}

class FakeApproveRequestDto extends Fake implements ApproveRequestDto {}

class FakeRejectRequestDto extends Fake implements RejectRequestDto {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyDevicesPage(),
  );
}

void main() {
  late MockDeviceRepository mockRepo;
  late MockDeviceService mockDeviceService;
  late MockLogService mockLog;
  late MockNotificationService mockNotifService;

  setUpAll(() {
    registerFallbackValue(FakeRegisterPushTokenRequest());
    registerFallbackValue(FakeUnregisterPushTokenRequest());
    registerFallbackValue(FakeCreateApprovalRequestDto());
    registerFallbackValue(FakeApproveRequestDto());
    registerFallbackValue(FakeRejectRequestDto());
  });

  setUp(() {
    mockRepo = MockDeviceRepository();
    mockDeviceService = MockDeviceService();
    mockLog = MockLogService();
    mockNotifService = MockNotificationService();

    when(() => mockDeviceService.deviceId).thenReturn('test-device-id');
    when(() => mockNotifService.fcmToken).thenReturn('test-fcm-token');
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<DeviceRepository>(mockRepo);
    getIt.registerSingleton<DeviceService>(mockDeviceService);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<NotificationService>(mockNotifService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyDevicesPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Devices & Approvals'), findsOneWidget);
    });

    testWidgets('shows section titles', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Push Token'), findsOneWidget);
      expect(find.text('Device Approval'), findsOneWidget);
      expect(find.text('Approval Actions'), findsOneWidget);
      expect(find.text('Device Management'), findsOneWidget);
    });

    testWidgets('shows push token buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('shows approval action buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Check Status'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });

    testWidgets('shows device management buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal device management section
      await tester.scrollUntilVisible(
        find.text('Delete Device'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('List Devices'), findsOneWidget);
      expect(find.text('Delete Device'), findsOneWidget);
    });

    testWidgets('register push token calls repo', (tester) async {
      when(() => mockRepo.registerPushToken(any())).thenAnswer((_) async {});

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register'));
      await tester.pump();

      verify(() => mockRepo.registerPushToken(any())).called(1);
      expect(
        find.textContaining('Token registered', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('remove push token calls repo', (tester) async {
      when(() => mockRepo.removePushToken(any())).thenAnswer((_) async {});

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove'));
      await tester.pump();

      verify(() => mockRepo.removePushToken(any())).called(1);
      expect(
        find.textContaining('Push token removed', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('list devices calls repo and shows result', (tester) async {
      when(() => mockRepo.listDevices()).thenAnswer(
        (_) async => const [
          DeviceResponse(
            id: 'dev-001',
            isTrusted: true,
            userAgent: 'Flutter/3.0',
            ipAddress: '192.168.1.1',
            firstSeenAt: '2025-01-01T00:00:00Z',
            lastSeenAt: '2025-01-02T00:00:00Z',
          ),
        ],
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('List Devices'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('List Devices'));
      await tester.pump();

      verify(() => mockRepo.listDevices()).called(1);
      expect(
        find.textContaining('dev-001', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('delete device calls repo', (tester) async {
      when(() => mockRepo.deleteDevice(any())).thenAnswer((_) async {});

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Delete Device'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      final deviceIdField = find.widgetWithText(TextField, 'Device ID (UUID)');
      await tester.enterText(deviceIdField, 'dev-001');
      await tester.tap(find.text('Delete Device'));
      await tester.pump();

      verify(() => mockRepo.deleteDevice('dev-001')).called(1);
      expect(
        find.textContaining('dev-001 deleted', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('shows loading indicator during operation', (tester) async {
      final completer = Completer<List<DeviceResponse>>();
      when(() => mockRepo.listDevices()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('List Devices'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('List Devices'));
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator, skipOffstage: false),
        findsOneWidget,
      );

      completer.complete(const []);
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message on failure', (tester) async {
      when(
        () => mockRepo.listDevices(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('List Devices'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('List Devices'));
      await tester.pump();

      expect(
        find.textContaining('Network error', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('request approval calls repo', (tester) async {
      when(() => mockRepo.requestApproval(any())).thenAnswer(
        (_) async => const ApprovalRequestResponseDto(
          requestId: 'req-001',
          accountId: 'acc-001',
          requestingDeviceId: 'test-device-id',
          operationType: 'device_login',
          status: 'pending',
          expiresAt: '2025-12-31T00:00:00Z',
          createdAt: '2025-01-01T00:00:00Z',
          isExpired: false,
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Approval'));
      await tester.pump();

      verify(() => mockRepo.requestApproval(any())).called(1);
      expect(
        find.textContaining('Request ID: req-001', skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
