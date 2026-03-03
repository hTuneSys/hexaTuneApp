// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';

class MockAuthService extends Mock implements AuthService {}

/// Builds a [GoRouter] that mirrors the production redirect logic
/// from [AppRouter], but without requiring the full DI container.
GoRouter _buildTestRouter(AuthService authService) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthNotifier(authService),
    redirect: (context, state) {
      final authState = authService.currentState;
      final currentPath = state.uri.path;

      if (authState == AuthState.unknown) {
        return currentPath == RouteNames.splash ? null : RouteNames.splash;
      }

      final isOnLogin = currentPath == RouteNames.login;
      final isAuthenticated = authState == AuthState.authenticated;

      if (!isAuthenticated && !isOnLogin) {
        return RouteNames.login;
      }

      if (isAuthenticated && isOnLogin) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) =>
            const _Page(key: Key('splash'), title: 'Loading'),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) =>
            const _Page(key: Key('login'), title: 'Login'),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) =>
            const _Page(key: Key('home'), title: 'Home'),
      ),
    ],
  );
}

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthService authService) {
    authService.authState.listen((_) => notifyListeners());
  }
}

class _Page extends StatelessWidget {
  const _Page({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}

void main() {
  group('Router redirect', () {
    late MockAuthService mockAuth;
    late StreamController<AuthState> authStream;

    setUp(() {
      mockAuth = MockAuthService();
      authStream = StreamController<AuthState>.broadcast();
      when(() => mockAuth.authState).thenAnswer((_) => authStream.stream);
    });

    tearDown(() {
      authStream.close();
    });

    testWidgets('shows splash when auth state is unknown', (tester) async {
      when(() => mockAuth.currentState).thenReturn(AuthState.unknown);

      final router = _buildTestRouter(mockAuth);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Loading'), findsOneWidget);
    });

    testWidgets(
      'redirects to login when unauthenticated',
      (tester) async {
        when(() => mockAuth.currentState).thenReturn(AuthState.unauthenticated);

        final router = _buildTestRouter(mockAuth);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        expect(find.text('Login'), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to home when authenticated from login',
      (tester) async {
        // Start unauthenticated → show login.
        when(() => mockAuth.currentState)
            .thenReturn(AuthState.unauthenticated);

        final router = _buildTestRouter(mockAuth);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();
        expect(find.text('Login'), findsOneWidget);

        // Now become authenticated.
        when(() => mockAuth.currentState)
            .thenReturn(AuthState.authenticated);
        authStream.add(AuthState.authenticated);
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to login when auth state changes to unauthenticated',
      (tester) async {
        when(() => mockAuth.currentState)
            .thenReturn(AuthState.authenticated);

        final router = _buildTestRouter(mockAuth);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        // Navigate to home first.
        router.go(RouteNames.home);
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);

        // Now lose auth.
        when(() => mockAuth.currentState)
            .thenReturn(AuthState.unauthenticated);
        authStream.add(AuthState.unauthenticated);
        await tester.pumpAndSettle();

        expect(find.text('Login'), findsOneWidget);
      },
    );
  });
}
