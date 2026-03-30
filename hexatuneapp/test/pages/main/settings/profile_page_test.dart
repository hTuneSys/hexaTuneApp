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
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/pages/main/settings/profile_page.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockLogService extends Mock implements LogService {}

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
      final profileCompleter = Completer<ProfileResponse>();
      when(
        () => mockRepo.getProfile(),
      ).thenAnswer((_) => profileCompleter.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      profileCompleter.complete(_testProfile);
      await tester.pumpAndSettle();
    });

    testWidgets('shows form with pre-filled text fields after load', (
      tester,
    ) async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Display Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Avatar URL'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Bio'), findsOneWidget);

      final displayNameField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Display Name'),
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
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);
      when(
        () => mockRepo.updateProfile(any()),
      ).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(FilledButton, 'Save Profile');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      verify(() => mockRepo.updateProfile(any())).called(1);
      expect(find.text('Profile updated'), findsOneWidget);
    });

    testWidgets('shows error and retry button on load failure', (tester) async {
      when(() => mockRepo.getProfile()).thenThrow(Exception('network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('—'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('retry button triggers reload', (tester) async {
      when(() => mockRepo.getProfile()).thenThrow(Exception('network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('refresh button triggers reload', (tester) async {
      when(() => mockRepo.getProfile()).thenAnswer((_) async => _testProfile);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      clearInteractions(mockRepo);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getProfile()).called(1);
    });
  });
}
