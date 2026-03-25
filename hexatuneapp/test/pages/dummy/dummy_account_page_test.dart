// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/account/account_repository.dart';
import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_account_page.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockLogService extends Mock implements LogService {}

const _testAccount = AccountResponse(
  id: 'acc-001',
  status: 'active',
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
  lockedAt: null,
  suspendedAt: null,
);

const _testProfile = ProfileResponse(
  accountId: 'acc-001',
  displayName: 'Test User',
  avatarUrl: 'https://example.com/avatar.png',
  bio: 'Hello',
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyAccountPage(),
  );
}

void main() {
  late MockAccountRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(
      const UpdateProfileRequest(displayName: null, avatarUrl: null, bio: null),
    );
  });

  setUp(() {
    mockRepo = MockAccountRepository();
    mockLog = MockLogService();

    when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
    when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);
    when(
      () => mockRepo.updateProfile(any()),
    ).thenAnswer((_) async => _testProfile);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AccountRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyAccountPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Account & Profile'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<AccountResponse>();
      when(() => mockRepo.getAccount()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testAccount);
      await tester.pumpAndSettle();
    });

    testWidgets('renders account info after load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('acc-001'), findsWidgets);
      expect(find.text('active'), findsOneWidget);
    });

    testWidgets('renders profile info after load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsWidgets);
      expect(find.text('Hello'), findsWidgets);
    });

    testWidgets('shows update profile form fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Display Name'), findsWidgets);
      expect(find.text('Avatar URL'), findsWidgets);
      expect(find.text('Bio'), findsWidgets);
    });

    testWidgets('refresh button reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getAccount()).called(greaterThan(1));
      verify(() => mockRepo.getProfile()).called(greaterThan(1));
    });

    testWidgets('save profile button calls updateProfile', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Save Profile'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.updateProfile(any())).called(1);
    });

    testWidgets('handles load error gracefully', (tester) async {
      when(
        () => mockRepo.getAccount(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('handles update error gracefully', (tester) async {
      when(
        () => mockRepo.updateProfile(any()),
      ).thenAnswer((_) async => throw Exception('Update failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Save Profile'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      // Error handled via snackbar without crash
      expect(find.byType(DummyAccountPage), findsOneWidget);
    });
  });
}
