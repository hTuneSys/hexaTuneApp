// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/debug/log_monitor_page.dart';
import 'package:hexatuneapp/src/pages/main/home/home_page.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_bottom_sheet.dart';
import 'package:hexatuneapp/src/pages/category/category_list_page.dart';
import 'package:hexatuneapp/src/pages/category/category_create_page.dart';
import 'package:hexatuneapp/src/pages/category/category_edit_page.dart';
import 'package:hexatuneapp/src/pages/category/category_view_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_list_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_create_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_edit_page.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_view_page.dart';
import 'package:hexatuneapp/src/pages/formula/formula_list_page.dart';
import 'package:hexatuneapp/src/pages/formula/formula_create_page.dart';
import 'package:hexatuneapp/src/pages/formula/formula_edit_page.dart';
import 'package:hexatuneapp/src/pages/formula/formula_view_page.dart';
import 'package:hexatuneapp/src/pages/auth/forgot_password_page.dart';
import 'package:hexatuneapp/src/pages/auth/login_page.dart';
import 'package:hexatuneapp/src/pages/auth/register_page.dart';
import 'package:hexatuneapp/src/pages/auth/reset_password_page.dart';
import 'package:hexatuneapp/src/pages/auth/splash_page.dart';
import 'package:hexatuneapp/src/pages/auth/verify_email_page.dart';
import 'package:hexatuneapp/src/pages/ambience/ambience_list_page.dart';
import 'package:hexatuneapp/src/pages/ambience/ambience_create_page.dart';
import 'package:hexatuneapp/src/pages/ambience/ambience_edit_page.dart';
import 'package:hexatuneapp/src/pages/ambience/ambience_view_page.dart';
import 'package:hexatuneapp/src/pages/main/workspace/workspace_page.dart';
import 'package:hexatuneapp/src/pages/main/settings/settings_page.dart';
import 'package:hexatuneapp/src/pages/main/settings/profile_page.dart';
import 'package:hexatuneapp/src/pages/main/settings/wallet_page.dart';
import 'package:hexatuneapp/src/pages/main/settings/sessions_page.dart';
import 'package:hexatuneapp/src/pages/main/settings/devices_page.dart';
import 'package:hexatuneapp/src/pages/provider/provider_page.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';

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
      // --- Main app shell with bottom bar ---
      ShellRoute(
        builder: (context, state, child) {
          return _HarmonizeCompletionListener(
            child: Scaffold(
              extendBody: true,
              body: child,
              bottomNavigationBar: StreamBuilder<HarmonizerState>(
                stream: getIt<HarmonizerService>().state,
                initialData: getIt<HarmonizerService>().currentState,
                builder: (context, snapshot) {
                  final hState = snapshot.data;
                  final double? progress;
                  if (hState != null &&
                      hState.status == HarmonizerStatus.harmonizing) {
                    final total = hState.totalRepeatDuration;
                    final remaining = hState.totalRemaining;
                    if (total != null &&
                        remaining != null &&
                        total.inMilliseconds > 0) {
                      progress =
                          1.0 -
                          (remaining.inMilliseconds / total.inMilliseconds)
                              .clamp(0.0, 1.0);
                    } else if (total == null) {
                      // Infinite: use cycle progress.
                      final cycleDur = hState.isFirstCycle
                          ? hState.firstCycleDuration
                          : hState.totalCycleDuration;
                      if (cycleDur.inMilliseconds > 0) {
                        progress =
                            1.0 -
                            (hState.remainingInCycle.inMilliseconds /
                                    cycleDur.inMilliseconds)
                                .clamp(0.0, 1.0);
                      } else {
                        progress = null;
                      }
                    } else {
                      progress = null;
                    }
                  } else {
                    progress = null;
                  }

                  return AppBottomBar(
                    harmonizeProgress: progress,
                    onItemTapped: (index) {
                      switch (index) {
                        case 0:
                          context.go(RouteNames.home);
                        case 2:
                          context.go(RouteNames.workspace);
                        case 3:
                          context.go(RouteNames.settings);
                        default:
                          break;
                      }
                    },
                    onCenterTapped: () => showHarmonizerSheet(context),
                  );
                },
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomePage(),
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
            path: RouteNames.formulaList,
            builder: (context, state) => const FormulaListPage(),
          ),
          GoRoute(
            path: RouteNames.formulaCreate,
            builder: (context, state) => const FormulaCreatePage(),
          ),
          GoRoute(
            path: RouteNames.formulaEdit,
            builder: (context, state) {
              final id = state.pathParameters['formulaId'] ?? '';
              return FormulaEditPage(formulaId: id);
            },
          ),
          GoRoute(
            path: RouteNames.formulaView,
            builder: (context, state) {
              final id = state.pathParameters['formulaId'] ?? '';
              return FormulaViewPage(formulaId: id);
            },
          ),
          GoRoute(
            path: RouteNames.ambienceList,
            builder: (context, state) => const AmbienceListPage(),
          ),
          GoRoute(
            path: RouteNames.ambienceCreate,
            builder: (context, state) => const AmbienceCreatePage(),
          ),
          GoRoute(
            path: RouteNames.ambienceEdit,
            builder: (context, state) {
              final id = state.pathParameters['ambienceId'] ?? '';
              return AmbienceEditPage(ambienceId: id);
            },
          ),
          GoRoute(
            path: RouteNames.ambienceView,
            builder: (context, state) {
              final id = state.pathParameters['ambienceId'] ?? '';
              return AmbienceViewPage(ambienceId: id);
            },
          ),
          GoRoute(
            path: RouteNames.workspace,
            builder: (context, state) => const WorkspacePage(),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: RouteNames.providerManagement,
            builder: (context, state) => const ProviderPage(),
          ),
          GoRoute(
            path: RouteNames.settingsProfile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: RouteNames.settingsWallet,
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: RouteNames.settingsSessions,
            builder: (context, state) => const SessionsPage(),
          ),
          GoRoute(
            path: RouteNames.settingsDevices,
            builder: (context, state) => const DevicesPage(),
          ),
          GoRoute(
            path: RouteNames.settingsLogMonitor,
            builder: (context, state) => const LogMonitorPage(),
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

/// Listens to [HarmonizerService] state transitions and shows a global
/// completion snackbar when harmonization ends (success or timeout).
class _HarmonizeCompletionListener extends StatefulWidget {
  const _HarmonizeCompletionListener({required this.child});

  final Widget child;

  @override
  State<_HarmonizeCompletionListener> createState() =>
      _HarmonizeCompletionListenerState();
}

class _HarmonizeCompletionListenerState
    extends State<_HarmonizeCompletionListener> {
  late final HarmonizerService _harmonizer;
  StreamSubscription<HarmonizerState>? _sub;
  HarmonizerStatus _previousStatus = HarmonizerStatus.idle;

  @override
  void initState() {
    super.initState();
    _harmonizer = getIt<HarmonizerService>();
    _previousStatus = _harmonizer.currentState.status;
    _sub = _harmonizer.state.listen(_onStateChanged);
  }

  void _onStateChanged(HarmonizerState state) {
    final newStatus = state.status;
    final wasActive =
        _previousStatus == HarmonizerStatus.harmonizing ||
        _previousStatus == HarmonizerStatus.stopping;
    _previousStatus = newStatus;

    if (!wasActive || newStatus != HarmonizerStatus.idle) return;

    final success = _harmonizer.lastCompletionSuccess;
    if (success == null) return;
    _harmonizer.clearCompletionResult();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (success) {
      AppSnackBar.info(context, message: l10n.harmonizeCompleted);
    } else {
      AppSnackBar.error(context, message: l10n.harmonizeDeviceTimeout);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
