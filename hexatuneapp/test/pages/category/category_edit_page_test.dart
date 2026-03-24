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
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/pages/category/category_edit_page.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _testCategory = CategoryResponse(
  id: 'cat-00100',
  name: 'Alpha Category',
  labels: ['alpha', 'test'],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const CategoryEditPage(categoryId: 'cat-00100'),
  );
}

void main() {
  late MockCategoryRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const UpdateCategoryRequest());
  });

  setUp(() {
    mockRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.getById('cat-00100'),
    ).thenAnswer((_) async => _testCategory);
    when(
      () => mockRepo.update(any(), any()),
    ).thenAnswer((_) async => _testCategory);
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
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

  group('CategoryEditPage', () {
    testWidgets('renders appbar with "Edit Category" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Edit Category'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching category', (
      tester,
    ) async {
      final completer = Completer<CategoryResponse>();
      when(
        () => mockRepo.getById('cat-00100'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testCategory);
      await tester.pumpAndSettle();
    });

    testWidgets('pre-fills name field with category name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(TextFormField, 'Name');
      expect(nameField, findsOneWidget);

      final field = tester.widget<TextFormField>(nameField);
      expect(field.controller?.text, equals('Alpha Category'));
    });

    testWidgets('shows existing labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'alpha'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'test'), findsOneWidget);
    });

    testWidgets('save button triggers update API call', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.update('cat-00100', any())).called(1);
    });

    testWidgets('delete button shows confirmation dialog', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Delete "Alpha Category"? This cannot be undone.'),
        findsOneWidget,
      );
    });

    testWidgets('shows error snackbar on update failure', (tester) async {
      when(
        () => mockRepo.update(any(), any()),
      ).thenAnswer((_) async => throw Exception('Update failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
