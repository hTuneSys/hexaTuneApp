// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/workspace_pin_service.dart';
import 'package:hexatuneapp/src/pages/main/workspace/workspace_page.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const WorkspacePage(),
  );
}

void main() {
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;

  setUp(() {
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();

    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.info(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<PreferencesService>(mockPrefs);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<WorkspacePinService>(
      WorkspacePinService(mockPrefs, mockLog),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('WorkspacePage', () {
    testWidgets('renders header with "Your Workspace" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Your Workspace'), findsOneWidget);
    });

    testWidgets('shows search and notification icons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows workspace icon in header', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.workspaces_outlined), findsOneWidget);
    });

    testWidgets('displays pinned formulas section with Edit button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Pinned Formulas'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('shows empty pinned formulas message when no pins', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No pinned formulas'), findsOneWidget);
    });

    testWidgets('shows pinned formulas when pins exist', (tester) async {
      const json = '[{"id":"f1","name":"My Formula"}]';
      when(
        () => mockPrefs.getString('workspace_pinned_formulas'),
      ).thenReturn(json);

      getIt.allowReassignment = true;
      getIt.registerSingleton<WorkspacePinService>(
        WorkspacePinService(mockPrefs, mockLog),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('My Formula'), findsOneWidget);
      expect(find.text('No pinned formulas'), findsNothing);
    });

    testWidgets('displays quick add section with chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Quick Add'), findsOneWidget);
      expect(find.byType(ActionChip), findsNWidgets(4));
      expect(find.text('Inventory'), findsWidgets);
      expect(find.text('Category'), findsWidgets);
      expect(find.text('Formula'), findsWidgets);
      expect(find.text('Ambience'), findsWidgets);
    });

    testWidgets('displays stats section with zero counts', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Stats'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(4));
    });

    testWidgets('displays 2x2 navigation grid', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.category_outlined), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
      expect(find.byIcon(Icons.spa_outlined), findsOneWidget);
    });

    testWidgets('displays recently used section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Recently Used'), findsOneWidget);
      expect(find.text('Formula 1'), findsOneWidget);
    });

    testWidgets('recently used items have play icons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
    });

    testWidgets('Edit button opens bottom sheet', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Search to pin'), findsOneWidget);
    });
  });
}
