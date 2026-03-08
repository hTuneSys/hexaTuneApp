// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('TokenManager', () {
    late TokenManager tokenManager;
    late MockSecureStorageService mockStorage;
    late MockLogService mockLog;

    setUp(() {
      mockStorage = MockSecureStorageService();
      mockLog = MockLogService();
      tokenManager = TokenManager(mockStorage, mockLog);
    });

    group('loadTokens', () {
      test('loads tokens from secure storage', () async {
        when(
          () => mockStorage.getAccessToken(),
        ).thenAnswer((_) async => 'auth_123');
        when(
          () => mockStorage.getRefreshToken(),
        ).thenAnswer((_) async => 'refresh_456');
        when(() => mockStorage.getSessionId()).thenAnswer((_) async => null);
        when(() => mockStorage.getExpiresAt()).thenAnswer((_) async => null);

        await tokenManager.loadTokens();

        expect(tokenManager.accessToken, 'auth_123');
        expect(tokenManager.refreshToken, 'refresh_456');
        expect(tokenManager.hasToken, isTrue);
      });

      test('handles missing tokens gracefully', () async {
        when(() => mockStorage.getAccessToken()).thenAnswer((_) async => null);
        when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => null);
        when(() => mockStorage.getSessionId()).thenAnswer((_) async => null);
        when(() => mockStorage.getExpiresAt()).thenAnswer((_) async => null);

        await tokenManager.loadTokens();

        expect(tokenManager.accessToken, isNull);
        expect(tokenManager.refreshToken, isNull);
        expect(tokenManager.hasToken, isFalse);
      });
    });

    group('saveTokens', () {
      test('stores tokens in memory and secure storage', () async {
        when(() => mockStorage.saveAccessToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.saveRefreshToken(any()),
        ).thenAnswer((_) async {});
        when(() => mockStorage.saveSessionId(any())).thenAnswer((_) async {});
        when(() => mockStorage.saveExpiresAt(any())).thenAnswer((_) async {});

        await tokenManager.saveTokens(
          accessToken: 'new_auth',
          refreshToken: 'new_refresh',
        );

        expect(tokenManager.accessToken, 'new_auth');
        expect(tokenManager.refreshToken, 'new_refresh');
        expect(tokenManager.hasToken, isTrue);

        verify(() => mockStorage.saveAccessToken('new_auth')).called(1);
        verify(() => mockStorage.saveRefreshToken('new_refresh')).called(1);
      });
    });

    group('clearTokens', () {
      test('clears tokens from memory and secure storage', () async {
        when(() => mockStorage.saveAccessToken(any())).thenAnswer((_) async {});
        when(
          () => mockStorage.saveRefreshToken(any()),
        ).thenAnswer((_) async {});
        when(() => mockStorage.saveSessionId(any())).thenAnswer((_) async {});
        when(() => mockStorage.saveExpiresAt(any())).thenAnswer((_) async {});
        when(() => mockStorage.clearTokens()).thenAnswer((_) async {});

        // First save some tokens.
        await tokenManager.saveTokens(
          accessToken: 'auth',
          refreshToken: 'refresh',
        );
        expect(tokenManager.hasToken, isTrue);

        // Then clear.
        await tokenManager.clearTokens();

        expect(tokenManager.accessToken, isNull);
        expect(tokenManager.refreshToken, isNull);
        expect(tokenManager.hasToken, isFalse);
        verify(() => mockStorage.clearTokens()).called(1);
      });
    });
  });
}
