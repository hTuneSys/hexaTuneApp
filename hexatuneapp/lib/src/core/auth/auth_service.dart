// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/auth/models/login_response.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';

/// Orchestrates login, logout, token refresh, and re-auth flows.
@singleton
class AuthService {
  AuthService(
    this._tokenManager,
    this._authRepository,
    this._authInterceptor,
    this._logService,
  );

  final TokenManager _tokenManager;
  final AuthRepository _authRepository;
  final AuthInterceptor _authInterceptor;
  final LogService _logService;

  final _authStateController = StreamController<AuthState>.broadcast();

  /// Current authentication state stream for routing decisions.
  Stream<AuthState> get authState => _authStateController.stream;

  AuthState _currentState = AuthState.unknown;

  AuthState get currentState => _currentState;

  /// Evaluate stored tokens and emit the initial auth state.
  Future<void> checkAuthStatus() async {
    await _tokenManager.loadTokens();
    if (_tokenManager.hasToken) {
      _updateState(AuthState.authenticated);
    } else {
      _updateState(AuthState.unauthenticated);
    }
  }

  /// Log in with the given [request]. On success, stores tokens.
  Future<LoginResponse> login(LoginRequest request) async {
    _logService.info('Login attempt', category: LogCategory.auth);

    final loginResponse = await _authRepository.login(request);

    await _tokenManager.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
      sessionId: loginResponse.sessionId,
      expiresAt: loginResponse.expiresAt,
    );

    _updateState(AuthState.authenticated);
    _logService.info('Login successful', category: LogCategory.auth);

    return loginResponse;
  }

  /// Log out: notify backend, clear local tokens, update state.
  Future<void> logout() async {
    _logService.info('Logout initiated', category: LogCategory.auth);

    // Best-effort server notification.
    try {
      await _authRepository.logout();
    } catch (e) {
      _logService.warning(
        'Logout server call failed (non-critical)',
        category: LogCategory.auth,
        exception: e,
      );
    }

    await _tokenManager.clearTokens();
    _updateState(AuthState.unauthenticated);
    _logService.info('Logout complete', category: LogCategory.auth);
  }

  /// Force logout without server call (e.g. after failed refresh).
  Future<void> forceLogout() async {
    await _tokenManager.clearTokens();
    _updateState(AuthState.unauthenticated);
    _logService.warning('Force logout', category: LogCategory.auth);
  }

  /// Auth event stream from the interceptor (re-auth, device approval).
  Stream<AuthEvent> get authEvents => _authInterceptor.authEvents;

  void _updateState(AuthState state) {
    _currentState = state;
    _authStateController.add(state);
  }

  void dispose() {
    _authStateController.close();
  }
}

enum AuthState {
  unknown,
  authenticated,
  unauthenticated,
}
