// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/pages/category/category_view_page.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _testCategoryWithLabels = CategoryResponse(
  id: 'cat-00100',
  name: 'Alpha Category',
  labels: ['alpha', 'test'],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testCategoryNoLabels = CategoryResponse(
  id: 'cat-00200',
  name: 'Beta Category',
  labels: [],
  createdAt: '2025-01-02T00:00:00Z',
  updatedAt: '2025-01-02T00:00:00Z',
);

Widget _buildApp({String categoryId = 'cat-00100'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: CategoryViewPage(categoryId: categoryId),
  );
}

void main() {
  late MockCategoryRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.getById('cat-00100'),
    ).thenAnswer((_) async => _testCategoryWithLabels);
    when(
      () => mockRepo.getById('cat-00200'),
    ).thenAnswer((_) async => _testCategoryNoLabels);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<CategoryRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('CategoryViewPage', () {
    testWidgets('renders appbar with "View Category" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('View Category'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<CategoryResponse>();
      when(
        () => mockRepo.getById('cat-00100'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testCategoryWithLabels);
      await tester.pumpAndSettle();
    });

    testWidgets('displays category name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Category'), findsOneWidget);
    });

    testWidgets('displays category labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'alpha'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'test'), findsOneWidget);
    });

    testWidgets('shows description placeholder', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('shows "No labels" when category has no labels', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(categoryId: 'cat-00200'));
      await tester.pumpAndSettle();

      expect(find.text('No labels'), findsOneWidget);
    });
  });
}
