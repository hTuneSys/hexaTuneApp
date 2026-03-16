// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_harmonics_page.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockHarmonicsRepository extends Mock implements HarmonicsRepository {}

class MockLogService extends Mock implements LogService {}

const _testPagination = PaginationMeta(
  hasMore: false,
  limit: 50,
  nextCursor: null,
);

const _testFormulas = [
  FormulaResponse(
    id: 'frm-001',
    name: 'Alpha Formula',
    labels: ['test'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  FormulaResponse(
    id: 'frm-002',
    name: 'Beta Formula',
    labels: ['prod'],
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

const _testResponse = GenerateHarmonicsResponse(
  requestId: 'req-001',
  generationType: 'Monaural',
  sourceType: 'Formula',
  sourceId: 'frm-001',
  sequence: [
    HarmonicPacketDto(value: 440, durationMs: 1000, isOneShot: false),
    HarmonicPacketDto(value: 880, durationMs: 500, isOneShot: true),
  ],
  totalItems: 2,
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyHarmonicsPage(),
  );
}

void main() {
  late MockFormulaRepository mockFormulaRepo;
  late MockHarmonicsRepository mockHarmonicsRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(
      const GenerateHarmonicsRequest(
        generationType: '',
        sourceType: '',
        sourceId: '',
      ),
    );
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockFormulaRepo = MockFormulaRepository();
    mockHarmonicsRepo = MockHarmonicsRepository();
    mockLog = MockLogService();

    when(() => mockFormulaRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testFormulas, pagination: _testPagination),
    );
    when(
      () => mockHarmonicsRepo.generate(any()),
    ).thenAnswer((_) async => _testResponse);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockFormulaRepo);
    getIt.registerSingleton<HarmonicsRepository>(mockHarmonicsRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyHarmonicsPage', () {
    testWidgets('shows appbar title Harmonics', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Harmonics'), findsOneWidget);
    });

    testWidgets('shows loading indicator while formulas load', (tester) async {
      final completer = Completer<PaginatedResponse<FormulaResponse>>();
      when(
        () => mockFormulaRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testFormulas, pagination: _testPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows Generation Type dropdown', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Generation Type'), findsOneWidget);
    });

    testWidgets('shows Source Type dropdown', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Source Type'), findsOneWidget);
    });

    testWidgets('shows FAB with Generate label', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.text('Generate'), findsOneWidget);
    });

    testWidgets('shows placeholder text when no response', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Select parameters and generate'), findsOneWidget);
    });

    testWidgets('refresh button reloads formulas', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(
        () => mockFormulaRepo.list(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('handles formula load error gracefully', (tester) async {
      when(
        () => mockFormulaRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
