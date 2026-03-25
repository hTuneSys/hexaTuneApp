// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/pages/category/category_create_page.dart';

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
    home: const CategoryCreatePage(),
  );
}

void main() {
  late MockCategoryRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const CreateCategoryRequest(name: ''));
  });

  setUp(() {
    mockRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(() => mockRepo.create(any())).thenAnswer((_) async => _testCategory);
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

  group('CategoryCreatePage', () {
    testWidgets('renders appbar with "Create Category" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create Category'), findsOneWidget);
    });

    testWidgets('shows name text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextFormField, 'Enter category name'),
        findsOneWidget,
      );
    });

    testWidgets('shows description text field (disabled)', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final descField = find.widgetWithText(
        TextFormField,
        'Enter category description',
      );
      expect(descField, findsOneWidget);

      final field = tester.widget<TextFormField>(descField);
      expect(field.enabled, isFalse);
    });

    testWidgets('shows add label text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Add label'), findsOneWidget);
    });

    testWidgets('adding a label creates a chip', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final labelField = find.widgetWithText(TextField, 'Add label');
      await tester.enterText(labelField, 'new-label');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'new-label'), findsOneWidget);
    });

    testWidgets('removing a chip removes the label', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Add a label first
      final labelField = find.widgetWithText(TextField, 'Add label');
      await tester.enterText(labelField, 'removable');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'removable'), findsOneWidget);

      // Tap the delete icon on the chip
      final deleteIcon = find.descendant(
        of: find.widgetWithText(Chip, 'removable'),
        matching: find.byIcon(Icons.cancel),
      );
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'removable'), findsNothing);
    });

    testWidgets('create button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Create'), findsOneWidget);
    });

    testWidgets('create button triggers API call on valid form', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Fill in the name field
      final nameField = find.widgetWithText(
        TextFormField,
        'Enter category name',
      );
      await tester.enterText(nameField, 'New Category');
      await tester.pumpAndSettle();

      // Tap the create button
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.create(any())).called(1);
    });

    testWidgets('shows error snackbar on create failure', (tester) async {
      when(
        () => mockRepo.create(any()),
      ).thenAnswer((_) async => throw Exception('Create failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Fill in the name field
      final nameField = find.widgetWithText(
        TextFormField,
        'Enter category name',
      );
      await tester.enterText(nameField, 'Failing Category');
      await tester.pumpAndSettle();

      // Tap the create button
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
