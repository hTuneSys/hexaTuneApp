// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_hexagen_page.dart';

class MockHexagenService extends Mock implements HexagenService {}

class MockLogService extends Mock implements LogService {}

class FakeATCommand extends Fake implements ATCommand {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyHexagenPage(),
  );
}

void main() {
  late MockHexagenService mockHexagenService;
  late MockLogService mockLogService;
  late StreamController<HexagenState> stateController;

  setUpAll(() {
    registerFallbackValue(FakeATCommand());
  });

  setUp(() {
    mockHexagenService = MockHexagenService();
    mockLogService = MockLogService();
    stateController = StreamController<HexagenState>.broadcast();

    when(
      () => mockHexagenService.currentState,
    ).thenReturn(const HexagenState());
    when(
      () => mockHexagenService.state,
    ).thenAnswer((_) => stateController.stream);
    when(() => mockHexagenService.isConnected).thenReturn(false);
    when(() => mockHexagenService.init()).thenAnswer((_) async {});
    when(() => mockHexagenService.refresh()).thenAnswer((_) async {});
    when(() => mockHexagenService.generateId()).thenReturn(1);
    when(
      () => mockHexagenService.sendATCommand(any()),
    ).thenAnswer((_) async {});
    when(() => mockHexagenService.currentOperationStatus).thenReturn(null);
    when(() => mockHexagenService.currentGeneratingStepId).thenReturn(null);
    when(() => mockHexagenService.currentOperationId).thenReturn(null);
    when(() => mockHexagenService.resetOperationState()).thenReturn(null);
    when(
      () => mockLogService.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<HexagenService>(mockHexagenService);
    getIt.registerSingleton<LogService>(mockLogService);
  });

  tearDown(() async {
    await stateController.close();
    await getIt.reset();
  });

  group('DummyHexagenPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('hexaGen Device'), findsOneWidget);
    });

    testWidgets('shows connection card with bluetooth icon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bluetooth_disabled), findsOneWidget);
    });

    testWidgets('shows Init button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Initialize'), findsOneWidget);
    });

    testWidgets('shows Reset button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('shows RGB section with color fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('RGB LED'), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);
      expect(find.text('R'), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('shows frequency sweep section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Frequency Sweep'), findsOneWidget);
      expect(find.byIcon(Icons.graphic_eq), findsOneWidget);
    });

    testWidgets('refresh button exists in app bar', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows disconnected status initially', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Disconnected'), findsOneWidget);
    });

    testWidgets('handles init error gracefully', (tester) async {
      when(
        () => mockHexagenService.init(),
      ).thenThrow(Exception('Connection failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Initialize'));
      await tester.pump();

      expect(
        find.textContaining('Connection failed', skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
