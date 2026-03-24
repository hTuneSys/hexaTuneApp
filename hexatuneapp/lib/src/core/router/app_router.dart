// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_account_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_audit_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_auth_extras_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_devices_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_dsp_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_ambience_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_formula_items_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_formulas_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_harmonics_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_harmonizer_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_hexagen_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_home_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_inventories_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_packages_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_flows_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_steps_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_otp_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_wallet_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_log_monitor_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_providers_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_sessions_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_tasks_page.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_tenants_page.dart';
import 'package:hexatuneapp/src/pages/dummy/widgets/mini_harmonizer_bar.dart';
import 'package:hexatuneapp/src/pages/category/category_list_page.dart';
import 'package:hexatuneapp/src/pages/category/category_create_page.dart';
import 'package:hexatuneapp/src/pages/category/category_edit_page.dart';
import 'package:hexatuneapp/src/pages/category/category_view_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_list_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_create_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_edit_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_view_page.dart';
import 'package:hexatuneapp/src/pages/auth/forgot_password_page.dart';
import 'package:hexatuneapp/src/pages/auth/login_page.dart';
import 'package:hexatuneapp/src/pages/auth/register_page.dart';
import 'package:hexatuneapp/src/pages/auth/reset_password_page.dart';
import 'package:hexatuneapp/src/pages/auth/splash_page.dart';
import 'package:hexatuneapp/src/pages/auth/verify_email_page.dart';

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
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailPage(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordPage(email: email);
        },
      ),
      // --- Dummy / dev pages share a shell with a persistent mini-player ---
      ShellRoute(
        builder: (context, state, child) {
          final isHarmonizerPage = state.uri.path == RouteNames.harmonizer;
          return Column(
            children: [
              Expanded(child: child),
              if (!isHarmonizerPage) const MiniHarmonizerBar(),
            ],
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const DummyHomePage(),
          ),
          GoRoute(
            path: RouteNames.reAuth,
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Re-Auth'),
          ),
          GoRoute(
            path: RouteNames.deviceApproval,
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Device Approval'),
          ),
          // Dummy test pages for all API endpoints.
          GoRoute(
            path: RouteNames.authExtras,
            builder: (context, state) => const DummyAuthExtrasPage(),
          ),
          GoRoute(
            path: RouteNames.account,
            builder: (context, state) => const DummyAccountPage(),
          ),
          GoRoute(
            path: RouteNames.sessions,
            builder: (context, state) => const DummySessionsPage(),
          ),
          GoRoute(
            path: RouteNames.devices,
            builder: (context, state) => const DummyDevicesPage(),
          ),
          GoRoute(
            path: RouteNames.providers,
            builder: (context, state) => const DummyProvidersPage(),
          ),
          GoRoute(
            path: RouteNames.tenants,
            builder: (context, state) => const DummyTenantsPage(),
          ),
          GoRoute(
            path: RouteNames.categoryList,
            builder: (context, state) => const CategoryListPage(),
          ),
          GoRoute(
            path: RouteNames.categoryCreate,
            builder: (context, state) => const CategoryCreatePage(),
          ),
          GoRoute(
            path: RouteNames.categoryEdit,
            builder: (context, state) {
              final id = state.pathParameters['categoryId'] ?? '';
              return CategoryEditPage(categoryId: id);
            },
          ),
          GoRoute(
            path: RouteNames.categoryView,
            builder: (context, state) {
              final id = state.pathParameters['categoryId'] ?? '';
              return CategoryViewPage(categoryId: id);
            },
          ),
          GoRoute(
            path: RouteNames.inventoryList,
            builder: (context, state) => const InventoryListPage(),
          ),
          GoRoute(
            path: RouteNames.inventoryCreate,
            builder: (context, state) => const InventoryCreatePage(),
          ),
          GoRoute(
            path: RouteNames.inventoryEdit,
            builder: (context, state) {
              final id = state.pathParameters['inventoryId'] ?? '';
              return InventoryEditPage(inventoryId: id);
            },
          ),
          GoRoute(
            path: RouteNames.inventoryView,
            builder: (context, state) {
              final id = state.pathParameters['inventoryId'] ?? '';
              return InventoryViewPage(inventoryId: id);
            },
          ),
          GoRoute(
            path: RouteNames.inventories,
            builder: (context, state) => const DummyInventoriesPage(),
          ),
          GoRoute(
            path: RouteNames.formulas,
            builder: (context, state) => const DummyFormulasPage(),
          ),
          GoRoute(
            path: RouteNames.formulaItems,
            builder: (context, state) {
              final formulaId = state.pathParameters['formulaId'] ?? '';
              return DummyFormulaItemsPage(formulaId: formulaId);
            },
          ),
          GoRoute(
            path: RouteNames.tasks,
            builder: (context, state) => const DummyTasksPage(),
          ),
          GoRoute(
            path: RouteNames.audit,
            builder: (context, state) => const DummyAuditPage(),
          ),
          GoRoute(
            path: RouteNames.harmonics,
            builder: (context, state) => const DummyHarmonicsPage(),
          ),
          GoRoute(
            path: RouteNames.dsp,
            builder: (context, state) => const DummyDspPage(),
          ),
          GoRoute(
            path: RouteNames.ambience,
            builder: (context, state) => const DummyAmbiencePage(),
          ),
          GoRoute(
            path: RouteNames.hexagen,
            builder: (context, state) => const DummyHexagenPage(),
          ),
          GoRoute(
            path: RouteNames.harmonizer,
            builder: (context, state) => const DummyHarmonizerPage(),
          ),
          GoRoute(
            path: RouteNames.packages,
            builder: (context, state) => const DummyPackagesPage(),
          ),
          GoRoute(
            path: RouteNames.flows,
            builder: (context, state) => const DummyFlowsPage(),
          ),
          GoRoute(
            path: RouteNames.steps,
            builder: (context, state) => const DummyStepsPage(),
          ),
          GoRoute(
            path: RouteNames.otp,
            builder: (context, state) {
              final email = state.uri.queryParameters['email'];
              return DummyOtpPage(
                email: (email != null && email.isNotEmpty) ? email : null,
              );
            },
          ),
          GoRoute(
            path: RouteNames.wallet,
            builder: (context, state) => const DummyWalletPage(),
          ),
          GoRoute(
            path: RouteNames.logMonitor,
            builder: (context, state) => const DummyLogMonitorPage(),
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _authService.currentState;
    final currentPath = state.uri.path;

    // Still initializing — stay on splash.
    if (authState == AuthState.unknown) {
      final decision = currentPath == RouteNames.splash
          ? null
          : RouteNames.splash;
      _logRedirect(currentPath, authState, decision);
      return decision;
    }

    final isOnPublicPage =
        currentPath == RouteNames.login ||
        currentPath == RouteNames.register ||
        currentPath == RouteNames.verifyEmail ||
        currentPath == RouteNames.forgotPassword ||
        currentPath == RouteNames.resetPassword;
    final isAuthenticated = authState == AuthState.authenticated;

    // Authenticated user on splash or public page → go to home.
    if (isAuthenticated &&
        (isOnPublicPage || currentPath == RouteNames.splash)) {
      _logRedirect(currentPath, authState, RouteNames.home);
      return RouteNames.home;
    }

    if (!isAuthenticated && !isOnPublicPage) {
      _logRedirect(currentPath, authState, RouteNames.login);
      return RouteNames.login;
    }

    _logRedirect(currentPath, authState, null);
    return null;
  }

  void _logRedirect(String path, AuthState authState, String? redirect) {
    _logService.devLog(
      '🧭 Router: path=$path, auth=${authState.name} '
      '→ ${redirect ?? 'no redirect'}',
      category: LogCategory.router,
    );
  }
}

/// Bridges [AuthService.authState] stream to [Listenable] for GoRouter.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthService authService) {
    _sub = authService.authState.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
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
