// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/tenant_membership_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/tenant_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_tenants_page.dart';

class MockTenantRepository extends Mock implements TenantRepository {}

class MockTokenManager extends Mock implements TokenManager {}

class MockLogService extends Mock implements LogService {}

const _testMemberships = [
  TenantMembershipResponse(
    id: 'mem-00100',
    tenantId: 'ten-00100',
    role: 'admin',
    status: 'active',
    isOwner: true,
    joinedAt: '2025-01-01T00:00:00Z',
  ),
  TenantMembershipResponse(
    id: 'mem-00200',
    tenantId: 'ten-00200',
    role: 'member',
    status: 'active',
    isOwner: false,
    joinedAt: '2025-01-15T00:00:00Z',
  ),
];

const _testSwitchResponse = SwitchTenantResponse(
  accessToken: 'new-access-token',
  refreshToken: 'new-refresh-token',
  sessionId: 'new-session-id',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyTenantsPage(),
  );
}

void main() {
  late MockTenantRepository mockRepo;
  late MockTokenManager mockTokenManager;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const SwitchTenantRequest(tenantId: ''));
  });

  setUp(() {
    mockRepo = MockTenantRepository();
    mockTokenManager = MockTokenManager();
    mockLog = MockLogService();

    when(
      () => mockRepo.listTenantMemberships(),
    ).thenAnswer((_) async => _testMemberships);
    when(
      () => mockRepo.switchTenant(any()),
    ).thenAnswer((_) async => _testSwitchResponse);
    when(
      () => mockTokenManager.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<TenantRepository>(mockRepo);
    getIt.registerSingleton<TokenManager>(mockTokenManager);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyTenantsPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Tenants'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<List<TenantMembershipResponse>>();
      when(
        () => mockRepo.listTenantMemberships(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testMemberships);
      await tester.pumpAndSettle();
    });

    testWidgets('renders membership cards', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Tenant: ten-00100'), findsOneWidget);
      expect(find.textContaining('Tenant: ten-00200'), findsOneWidget);
    });

    testWidgets('shows membership details', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('admin'), findsOneWidget);
      expect(find.text('member'), findsOneWidget);
    });

    testWidgets('shows owner icon for owner membership', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.business), findsOneWidget);
    });

    testWidgets('shows Switch buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Switch'), findsNWidgets(2));
    });

    testWidgets('shows refresh button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('refresh reloads memberships', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.listTenantMemberships()).called(greaterThan(1));
    });

    testWidgets('shows empty state when no memberships', (tester) async {
      when(() => mockRepo.listTenantMemberships()).thenAnswer((_) async => []);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No tenant memberships'), findsOneWidget);
    });

    testWidgets('switch tenant calls repository and saves tokens', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Tap the first Switch button
      await tester.tap(find.text('Switch').first);
      await tester.pumpAndSettle();

      verify(() => mockRepo.switchTenant(any())).called(1);
      verify(
        () => mockTokenManager.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).called(1);
    });

    testWidgets('handles load error gracefully', (tester) async {
      when(
        () => mockRepo.listTenantMemberships(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('handles switch tenant error gracefully', (tester) async {
      when(
        () => mockRepo.switchTenant(any()),
      ).thenAnswer((_) async => throw Exception('Switch failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Switch').first);
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.text('Tenants'), findsOneWidget);
    });
  });
}
