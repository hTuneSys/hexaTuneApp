// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/workspace_pin_service.dart';
import 'package:hexatuneapp/src/pages/main/workspace/workspace_pin_sheet.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testFormulas = [
  FormulaResponse(
    id: 'frm-001',
    name: 'Alpha Formula',
    labels: ['alpha'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  FormulaResponse(
    id: 'frm-002',
    name: 'Beta Formula',
    labels: ['beta'],
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

Widget _buildApp(WorkspacePinService pinService) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => SizedBox(
              height: 500,
              child: WorkspacePinSheet(pinService: pinService),
            ),
          ),
          child: const Text('Open Sheet'),
        ),
      ),
    ),
  );
}

void main() {
  late MockFormulaRepository mockRepo;
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;
  late WorkspacePinService pinService;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockRepo = MockFormulaRepository();
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();
    pinService = WorkspacePinService(mockPrefs, mockLog);

    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.info(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
    );

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('WorkspacePinSheet', () {
    testWidgets('renders search field with placeholder', (tester) async {
      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Search to pin'), findsOneWidget);
    });

    testWidgets('renders pinned formulas title', (tester) async {
      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Pinned Formulas'), findsOneWidget);
    });

    testWidgets('search triggers API call and shows results', (tester) async {
      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'alpha');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      verify(() => mockRepo.list(params: any(named: 'params'))).called(1);
      expect(find.text('Alpha Formula'), findsOneWidget);
      expect(find.text('Beta Formula'), findsOneWidget);
    });

    testWidgets('add button triggers search', (tester) async {
      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test');

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      verify(() => mockRepo.list(params: any(named: 'params'))).called(1);
    });

    testWidgets('pin button adds formula', (tester) async {
      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'alpha');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add_circle_outline);
      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      expect(pinService.isPinned('frm-001'), isTrue);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows pinned formulas with remove button', (tester) async {
      await pinService.pin('f1', 'Pinned One');

      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Pinned One'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('remove button unpins formula', (tester) async {
      await pinService.pin('f1', 'Pinned One');

      await tester.pumpWidget(_buildApp(pinService));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(pinService.isPinned('f1'), isTrue);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(pinService.isPinned('f1'), isFalse);
    });
  });
}
