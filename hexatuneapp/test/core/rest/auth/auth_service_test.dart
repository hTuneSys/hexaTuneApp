// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/oauth_login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';

class MockTokenManager extends Mock implements TokenManager {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthInterceptor extends Mock implements AuthInterceptor {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockTokenManager mockTokenManager;
    late MockAuthRepository mockAuthRepository;
    late MockAuthInterceptor mockAuthInterceptor;
    late MockLogService mockLogService;

    setUp(() {
      mockTokenManager = MockTokenManager();
      mockAuthRepository = MockAuthRepository();
      mockAuthInterceptor = MockAuthInterceptor();
      mockLogService = MockLogService();
      authService = AuthService(
        mockTokenManager,
        mockAuthRepository,
        mockAuthInterceptor,
        mockLogService,
      );
    });

    tearDown(() {
      authService.dispose();
    });

    group('initial state', () {
      test('starts as unknown', () {
        expect(authService.currentState, AuthState.unknown);
      });
    });

    group('checkAuthStatus', () {
      test('emits authenticated when token exists', () async {
        when(() => mockTokenManager.loadTokens()).thenAnswer((_) async {});
        when(() => mockTokenManager.hasToken).thenReturn(true);

        final states = <AuthState>[];
        authService.authState.listen(states.add);

        await authService.checkAuthStatus();

        expect(authService.currentState, AuthState.authenticated);
        await Future<void>.delayed(Duration.zero);
        expect(states, contains(AuthState.authenticated));
      });

      test('emits unauthenticated when no token', () async {
        when(() => mockTokenManager.loadTokens()).thenAnswer((_) async {});
        when(() => mockTokenManager.hasToken).thenReturn(false);

        final states = <AuthState>[];
        authService.authState.listen(states.add);

        await authService.checkAuthStatus();

        expect(authService.currentState, AuthState.unauthenticated);
        await Future<void>.delayed(Duration.zero);
        expect(states, contains(AuthState.unauthenticated));
      });
    });

    group('forceLogout', () {
      test('clears tokens and emits unauthenticated', () async {
        when(() => mockTokenManager.clearTokens()).thenAnswer((_) async {});

        final states = <AuthState>[];
        authService.authState.listen(states.add);

        await authService.forceLogout();

        expect(authService.currentState, AuthState.unauthenticated);
        verify(() => mockTokenManager.clearTokens()).called(1);
      });
    });

    group('loginWithGoogle', () {
      test('saves tokens and emits authenticated', () async {
        const request = GoogleAuthRequest(
          idToken: 'google-jwt',
          deviceId: 'dev-1',
        );
        const response = OAuthLoginResponse(
          accessToken: 'at-google',
          refreshToken: 'rt-google',
          sessionId: 'sess-google',
          accountId: 'acc-google',
          expiresAt: '2026-12-31T23:59:59Z',
          isNewAccount: false,
        );

        when(
          () => mockAuthRepository.loginWithGoogle(request),
        ).thenAnswer((_) async => response);
        when(
          () => mockTokenManager.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            sessionId: any(named: 'sessionId'),
            expiresAt: any(named: 'expiresAt'),
          ),
        ).thenAnswer((_) async {});

        final states = <AuthState>[];
        authService.authState.listen(states.add);

        final result = await authService.loginWithGoogle(request);

        expect(result.accessToken, 'at-google');
        expect(result.isNewAccount, isFalse);
        expect(authService.currentState, AuthState.authenticated);
        verify(
          () => mockTokenManager.saveTokens(
            accessToken: 'at-google',
            refreshToken: 'rt-google',
            sessionId: 'sess-google',
            expiresAt: '2026-12-31T23:59:59Z',
          ),
        ).called(1);
      });
    });

    group('loginWithApple', () {
      test('saves tokens and emits authenticated', () async {
        const request = AppleAuthRequest(
          idToken: 'apple-jwt',
          authorizationCode: 'auth-code',
          deviceId: 'dev-2',
        );
        const response = OAuthLoginResponse(
          accessToken: 'at-apple',
          refreshToken: 'rt-apple',
          sessionId: 'sess-apple',
          accountId: 'acc-apple',
          expiresAt: '2026-12-31T23:59:59Z',
          isNewAccount: true,
        );

        when(
          () => mockAuthRepository.loginWithApple(request),
        ).thenAnswer((_) async => response);
        when(
          () => mockTokenManager.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            sessionId: any(named: 'sessionId'),
            expiresAt: any(named: 'expiresAt'),
          ),
        ).thenAnswer((_) async {});

        final states = <AuthState>[];
        authService.authState.listen(states.add);

        final result = await authService.loginWithApple(request);

        expect(result.accessToken, 'at-apple');
        expect(result.isNewAccount, isTrue);
        expect(authService.currentState, AuthState.authenticated);
        verify(
          () => mockTokenManager.saveTokens(
            accessToken: 'at-apple',
            refreshToken: 'rt-apple',
            sessionId: 'sess-apple',
            expiresAt: '2026-12-31T23:59:59Z',
          ),
        ).called(1);
      });
    });
  });
}
