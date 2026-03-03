// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_home_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_login_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_register_page.dart';

/// Application router with auth-aware redirect logic.
@singleton
class AppRouter {
  AppRouter(this._authService, this._logService);

  final AuthService _authService;
  final LogService _logService;

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthNotifier(_authService),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const _PlaceholderPage(title: 'Loading'),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const DummyLoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const DummyRegisterPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const DummyHomePage(),
      ),
      GoRoute(
        path: RouteNames.reAuth,
        builder: (context, state) => const _PlaceholderPage(title: 'Re-Auth'),
      ),
      GoRoute(
        path: RouteNames.deviceApproval,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Device Approval'),
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _authService.currentState;
    final currentPath = state.uri.path;

    // Still initializing — stay on splash.
    if (authState == AuthState.unknown) {
      final decision =
          currentPath == RouteNames.splash ? null : RouteNames.splash;
      _logRedirect(currentPath, authState, decision);
      return decision;
    }

    final isOnPublicPage =
        currentPath == RouteNames.login || currentPath == RouteNames.register;
    final isAuthenticated = authState == AuthState.authenticated;

    if (!isAuthenticated && !isOnPublicPage) {
      _logRedirect(currentPath, authState, RouteNames.login);
      return RouteNames.login;
    }

    if (isAuthenticated && isOnPublicPage) {
      _logRedirect(currentPath, authState, RouteNames.home);
      return RouteNames.home;
    }

    _logRedirect(currentPath, authState, null);
    return null;
  }

  void _logRedirect(String path, AuthState authState, String? redirect) {
    if (Env.isDev) {
      _logService.devLog(
        '🧭 Router: path=$path, auth=${authState.name} '
        '→ ${redirect ?? 'no redirect'}',
        category: LogCategory.router,
      );
    }
  }
}

/// Bridges [AuthService.authState] stream to [Listenable] for GoRouter.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthService authService) {
    authService.authState.listen((_) => notifyListeners());
  }
}

/// Temporary placeholder page used until real UI screens are built.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
