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
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_packages_page.dart';

class MockPackageRepository extends Mock implements PackageRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testPackages = [
  PackageResponse(
    id: 'pkg-001',
    name: 'Alpha Package',
    description: 'First test package',
    labels: ['alpha', 'test'],
    imageUploaded: true,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
  PackageResponse(
    id: 'pkg-002',
    name: 'Beta Package',
    description: 'Second test package',
    labels: ['beta'],
    imageUploaded: false,
    createdAt: '2025-02-01T00:00:00Z',
    updatedAt: '2025-02-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyPackagesPage(),
  );
}

void main() {
  late MockPackageRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockPackageRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.list(
        params: any(named: 'params'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testPackages, pagination: _emptyPagination),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['alpha', 'beta', 'test']);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<PackageRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyPackagesPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Packages'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<PackageResponse>>();
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testPackages, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders package list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Package'), findsOneWidget);
      expect(find.text('Beta Package'), findsOneWidget);
      expect(find.text('alpha, test'), findsOneWidget);
      expect(find.text('beta'), findsWidgets);
    });

    testWidgets('shows empty list when no packages', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Package'), findsNothing);
      expect(find.text('Beta Package'), findsNothing);
    });

    testWidgets('shows label filter chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.text('alpha'), findsWidgets);
      expect(find.text('beta'), findsWidgets);
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Alpha');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('tapping label chip reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(FilterChip, 'alpha');
      expect(chip, findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Package'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: pkg-001'), findsOneWidget);
      expect(find.text('Description: First test package'), findsOneWidget);
      expect(find.text('View Image'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('detail dialog hides View Image when no image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Beta Package'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('View Image'), findsNothing);
    });

    testWidgets('View Image button fetches and shows image', (tester) async {
      when(() => mockRepo.getImageUrl('pkg-001')).thenAnswer(
        (_) async => const ImageUrlResponse(url: 'https://example.com/img.png'),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Package'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Image'));
      await tester.pumpAndSettle();

      expect(find.text('Package Image'), findsOneWidget);
      verify(() => mockRepo.getImageUrl('pkg-001')).called(1);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testPackages,
          pagination: const PaginationMeta(
            hasMore: true,
            limit: 20,
            nextCursor: 'cursor_abc',
          ),
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Load More'), findsOneWidget);
    });

    testWidgets('refresh button reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) async => throw Exception('Network error'));
      when(
        () => mockRepo.listLabels(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('sort dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default sort'), findsOneWidget);
    });

    testWidgets('locale dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default locale'), findsOneWidget);
    });

    testWidgets('selecting sort triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default sort'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name (A→Z)').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('selecting locale triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default locale'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });
  });
}
