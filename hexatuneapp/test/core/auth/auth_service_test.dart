// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';
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
  });
}
