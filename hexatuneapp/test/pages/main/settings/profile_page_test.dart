// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/account/account_repository.dart';
import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/pages/main/settings/profile_page.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockLogService extends Mock implements LogService {}

const _testAccount = AccountResponse(
  id: 'acc-1',
  status: 'active',
  createdAt: '2025-01-01',
  updatedAt: '2025-01-02',
);

const _testProfile = ProfileResponse(
  accountId: 'acc-1',
  displayName: 'Test User',
  avatarUrl: 'http://example.com/avatar.png',
  bio: 'A bio',
  createdAt: '2025-01-01',
  updatedAt: '2025-01-02',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const ProfilePage(),
  );
}

void main() {
  late MockAccountRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const UpdateProfileRequest());
  });

  setUp(() {
    mockRepo = MockAccountRepository();
    mockLog = MockLogService();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.debug(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AccountRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('ProfilePage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final accountCompleter = Completer<AccountResponse>();
      when(
        () => mockRepo.getAccount(),
      ).thenAnswer((_) => accountCompleter.future);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete to avoid pending timer errors
      accountCompleter.complete(_testAccount);
      await tester.pumpAndSettle();
    });

    testWidgets('shows account info after load', (tester) async {
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('acc-1'), findsOneWidget);
      expect(find.text('active'), findsOneWidget);
      expect(find.text('2025-01-01'), findsAtLeast(1));
      expect(find.text('2025-01-02'), findsAtLeast(1));
    });

    testWidgets('shows profile info after load', (tester) async {
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsAtLeast(1));
      expect(find.text('http://example.com/avatar.png'), findsAtLeast(1));
      expect(find.text('A bio'), findsAtLeast(1));
    });

    testWidgets('shows update form with pre-filled text fields', (
      tester,
    ) async {
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Verify three TextFields exist with label text
      expect(find.widgetWithText(TextField, 'Display Name'), findsAtLeast(1));
      expect(find.widgetWithText(TextField, 'Avatar URL'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Bio'), findsOneWidget);

      // Verify pre-filled values via controller text
      final displayNameField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Display Name').first,
      );
      expect(displayNameField.controller?.text, 'Test User');

      final avatarUrlField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Avatar URL'),
      );
      expect(avatarUrlField.controller?.text, 'http://example.com/avatar.png');

      final bioField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Bio'),
      );
      expect(bioField.controller?.text, 'A bio');
    });

    testWidgets('save button triggers updateProfile and shows snackbar', (
      tester,
    ) async {
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);
      when(
        () => mockRepo.updateProfile(any()),
      ).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Scroll to the save button (it may be off-screen)
      final saveButton = find.widgetWithText(ElevatedButton, 'Save Profile');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      verify(() => mockRepo.updateProfile(any())).called(1);
      expect(find.text('Profile updated'), findsOneWidget);
    });

    testWidgets('shows error and retry button on load failure', (tester) async {
      when(() => mockRepo.getAccount()).thenThrow(Exception('network error'));
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Error state shows l10n.profileNoData and retry
      expect(find.text('—'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('retry button triggers reload', (tester) async {
      // First call fails
      when(() => mockRepo.getAccount()).thenThrow(Exception('network error'));
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Set up for successful retry
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('acc-1'), findsOneWidget);
    });

    testWidgets('refresh button triggers reload', (tester) async {
      when(() => mockRepo.getAccount()).thenAnswer((_) async => _testAccount);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Clear call counts
      clearInteractions(mockRepo);

      // Tap refresh icon in AppBar
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getAccount()).called(1);
      verify(() => mockRepo.getProfile()).called(1);
    });
  });
}
