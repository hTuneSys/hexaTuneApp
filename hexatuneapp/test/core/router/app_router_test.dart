// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/app_router.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';

class _FakeAuthService extends Fake implements AuthService {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get authState => _controller.stream;

  @override
  AuthState get currentState => AuthState.unknown;

  void close() => _controller.close();
}

class MockLogService extends Mock implements LogService {}

void main() {
  group('RouteNames', () {
    test('splash path is /', () {
      expect(RouteNames.splash, '/');
    });

    test('login path is /login', () {
      expect(RouteNames.login, '/login');
    });

    test('register path is /register', () {
      expect(RouteNames.register, '/register');
    });

    test('verifyEmail path is /verify-email', () {
      expect(RouteNames.verifyEmail, '/verify-email');
    });

    test('forgotPassword path is /forgot-password', () {
      expect(RouteNames.forgotPassword, '/forgot-password');
    });

    test('resetPassword path is /reset-password', () {
      expect(RouteNames.resetPassword, '/reset-password');
    });

    test('home path is /home', () {
      expect(RouteNames.home, '/home');
    });
  });

  group('AppRouter', () {
    late _FakeAuthService fakeAuth;
    late MockLogService mockLog;

    setUp(() {
      fakeAuth = _FakeAuthService();
      mockLog = MockLogService();

      when(
        () => mockLog.devLog(any(), category: any(named: 'category')),
      ).thenReturn(null);
    });

    tearDown(() {
      fakeAuth.close();
    });

    test('can be instantiated', () {
      final appRouter = AppRouter(fakeAuth, mockLog);
      expect(appRouter, isNotNull);
    });

    test('creates a GoRouter instance', () {
      final appRouter = AppRouter(fakeAuth, mockLog);
      expect(appRouter.router, isA<GoRouter>());
    });

    test('router has expected number of top-level routes', () {
      final appRouter = AppRouter(fakeAuth, mockLog);
      final routes = appRouter.router.configuration.routes;

      // 6 top-level GoRoutes + 1 ShellRoute = 7
      expect(routes.length, 7);
    });

    test('initial location is splash', () {
      final appRouter = AppRouter(fakeAuth, mockLog);
      final config = appRouter.router.configuration;

      expect(config.routes.first, isA<GoRoute>());
      final firstRoute = config.routes.first as GoRoute;
      expect(firstRoute.path, RouteNames.splash);
    });

    test('shell route contains expected number of sub-routes', () {
      final appRouter = AppRouter(fakeAuth, mockLog);
      final routes = appRouter.router.configuration.routes;

      final shellRoute = routes.whereType<ShellRoute>().first;
      expect(shellRoute.routes.length, 34);
    });
  });
}
