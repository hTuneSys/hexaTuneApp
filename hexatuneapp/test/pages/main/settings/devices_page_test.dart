// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/models/device_response.dart';
import 'package:hexatuneapp/src/pages/main/settings/devices_page.dart';

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockLogService extends Mock implements LogService {}

const _trustedDevice = DeviceResponse(
  id: 'dev-1',
  isTrusted: true,
  userAgent: 'Flutter/3.0',
  ipAddress: '192.168.1.1',
  firstSeenAt: '2025-01-01',
  lastSeenAt: '2025-03-01',
);

const _untrustedDevice = DeviceResponse(
  id: 'dev-2',
  isTrusted: false,
  userAgent: 'Chrome/120',
  ipAddress: '10.0.0.1',
  firstSeenAt: '2025-02-01',
  lastSeenAt: '2025-03-01',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DevicesPage(),
  );
}

void main() {
  late MockDeviceRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockDeviceRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.listDevices(),
    ).thenAnswer((_) async => [_trustedDevice, _untrustedDevice]);
    when(() => mockRepo.deleteDevice(any())).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<DeviceRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DevicesPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<List<DeviceResponse>>();
      when(() => mockRepo.listDevices()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([_trustedDevice, _untrustedDevice]);
      await tester.pumpAndSettle();
    });

    testWidgets('shows device cards after load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Flutter/3.0'), findsOneWidget);
      expect(find.text('192.168.1.1'), findsOneWidget);
      expect(find.text('Chrome/120'), findsOneWidget);
      expect(find.text('10.0.0.1'), findsOneWidget);
    });

    testWidgets('shows trusted chip for trusted device', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Trusted'), findsOneWidget);
    });

    testWidgets('shows not-trusted chip for untrusted device', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Not trusted'), findsOneWidget);
    });

    testWidgets('delete button shows confirmation dialog', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this device?'),
        findsOneWidget,
      );
    });

    testWidgets('confirming delete calls repo and removes device', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Flutter/3.0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // Tap the filled "Delete" button in the dialog
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.deleteDevice('dev-1')).called(1);
      expect(find.text('Flutter/3.0'), findsNothing);
    });

    testWidgets('cancel in delete dialog does not call deleteDevice', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => mockRepo.deleteDevice(any()));
    });

    testWidgets('shows empty state when no devices', (tester) async {
      when(() => mockRepo.listDevices()).thenAnswer((_) async => []);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No registered devices'), findsOneWidget);
    });

    testWidgets('shows error state with retry on load failure', (tester) async {
      when(
        () => mockRepo.listDevices(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      // Reset stub so retry succeeds
      when(
        () => mockRepo.listDevices(),
      ).thenAnswer((_) async => [_trustedDevice]);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Flutter/3.0'), findsOneWidget);
    });

    testWidgets('refresh button triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // First call was during init
      verify(() => mockRepo.listDevices()).called(1);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.listDevices()).called(1);
    });
  });
}
