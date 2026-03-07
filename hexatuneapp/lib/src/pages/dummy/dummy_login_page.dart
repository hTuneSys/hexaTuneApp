// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/device/device_repository.dart';
import 'package:hexatuneapp/src/core/device/device_service.dart';
import 'package:hexatuneapp/src/core/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

/// Dummy login page for testing auth flow — will be replaced with production UI.
class DummyLoginPage extends StatefulWidget {
  const DummyLoginPage({super.key});

  @override
  State<DummyLoginPage> createState() => _DummyLoginPageState();
}

class _DummyLoginPageState extends State<DummyLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _googleTokenController = TextEditingController();
  final _appleTokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _googleTokenController.dispose();
    _appleTokenController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Email login
  // ---------------------------------------------------------------------------

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password are required');
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      final authService = getIt<AuthService>();
      final deviceService = getIt<DeviceService>();

      if (Env.isDev) {
        log.devLog(
          '→ Login attempt: email=$email, deviceId=${deviceService.deviceId}',
          category: LogCategory.ui,
        );
      }

      final response = await authService.login(
        LoginRequest(
          email: email,
          password: password,
          deviceId: deviceService.deviceId,
        ),
      );

      if (Env.isDev) {
        log.devLog(
          '✓ Login success: sessionId=${response.sessionId}, '
          'expiresAt=${response.expiresAt}',
          category: LogCategory.ui,
        );
      }

      await _registerPushToken();
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Login failed: $e', category: LogCategory.ui);
      }
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Real OAuth flows (native SDK)
  // ---------------------------------------------------------------------------

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      final oauthService = getIt<OAuthService>();
      final authService = getIt<AuthService>();

      final request = await oauthService.signInWithGoogle();
      final response = await authService.loginWithGoogle(request);

      if (Env.isDev) {
        log.devLog(
          '✓ Google sign-in success: sessionId=${response.sessionId}, '
          'isNewAccount=${response.isNewAccount}',
          category: LogCategory.ui,
        );
      }

      if (mounted && response.isNewAccount) {
        _showInfo('New account created via Google');
      }

      await _registerPushToken();
    } on OAuthCancelledException {
      if (Env.isDev) {
        log.devLog('→ Google sign-in cancelled', category: LogCategory.ui);
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Google sign-in failed: $e', category: LogCategory.ui);
      }
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    final oauthService = getIt<OAuthService>();
    if (!oauthService.isAppleSignInAvailable) {
      _showError('Apple Sign-In is only available on iOS');
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      final authService = getIt<AuthService>();

      final request = await oauthService.signInWithApple();
      final response = await authService.loginWithApple(request);

      if (Env.isDev) {
        log.devLog(
          '✓ Apple sign-in success: sessionId=${response.sessionId}, '
          'isNewAccount=${response.isNewAccount}',
          category: LogCategory.ui,
        );
      }

      if (mounted && response.isNewAccount) {
        _showInfo('New account created via Apple');
      }

      await _registerPushToken();
    } on OAuthCancelledException {
      if (Env.isDev) {
        log.devLog('→ Apple sign-in cancelled', category: LogCategory.ui);
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Apple sign-in failed: $e', category: LogCategory.ui);
      }
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Manual token login (Advanced — for debugging)
  // ---------------------------------------------------------------------------

  Future<void> _loginWithManualGoogleToken() async {
    final idToken = _googleTokenController.text.trim();
    if (idToken.isEmpty) {
      _showError('Google ID token is required');
      return;
    }
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final authService = getIt<AuthService>();
      final deviceService = getIt<DeviceService>();
      final response = await authService.loginWithGoogle(
        GoogleAuthRequest(idToken: idToken, deviceId: deviceService.deviceId),
      );
      if (Env.isDev) {
        log.devLog(
          '✓ Manual Google login: sessionId=${response.sessionId}',
          category: LogCategory.ui,
        );
      }
      await _registerPushToken();
    } catch (e) {
      if (Env.isDev) {
        log.devLog(
          '✗ Manual Google login failed: $e',
          category: LogCategory.ui,
        );
      }
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithManualAppleToken() async {
    final idToken = _appleTokenController.text.trim();
    if (idToken.isEmpty) {
      _showError('Apple ID token is required');
      return;
    }
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final authService = getIt<AuthService>();
      final deviceService = getIt<DeviceService>();
      final response = await authService.loginWithApple(
        AppleAuthRequest(idToken: idToken, deviceId: deviceService.deviceId),
      );
      if (Env.isDev) {
        log.devLog(
          '✓ Manual Apple login: sessionId=${response.sessionId}',
          category: LogCategory.ui,
        );
      }
      await _registerPushToken();
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Manual Apple login failed: $e', category: LogCategory.ui);
      }
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Push token registration
  // ---------------------------------------------------------------------------

  Future<void> _registerPushToken() async {
    try {
      final notificationService = getIt<NotificationService>();

      if (notificationService.fcmToken == null) {
        if (Env.isDev) {
          getIt<LogService>().devLog(
            'Initializing NotificationService after login…',
            category: LogCategory.notification,
          );
        }
        await notificationService.init();
      }

      final fcmToken = notificationService.fcmToken;
      if (fcmToken == null) {
        if (Env.isDev) {
          getIt<LogService>().devLog(
            'Push token registration skipped — no FCM token',
            category: LogCategory.notification,
          );
        }
        return;
      }

      final deviceRepo = getIt<DeviceRepository>();
      await deviceRepo.registerPushToken(
        RegisterPushTokenRequest(
          token: fcmToken,
          platform: Platform.isIOS ? 'ios' : 'android',
        ),
      );
      getIt<LogService>().info(
        'Push token registered after login',
        category: LogCategory.notification,
      );
      if (Env.isDev) {
        getIt<LogService>().devLog(
          '✓ Push token registered: $fcmToken',
          category: LogCategory.notification,
        );
      }
    } catch (e) {
      getIt<LogService>().warning(
        'Push token registration failed (non-critical)',
        category: LogCategory.notification,
        exception: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'hexaTune',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 48),

              // — Email login —
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(RouteNames.register),
                child: const Text('or Sign Up'),
              ),

              // — OAuth sign-in (real SDK flow) —
              const Divider(height: 48),
              Text(
                'OAuth Sign-In',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign in with Google'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithApple,
                  icon: const Icon(Icons.apple),
                  label: const Text('Sign in with Apple'),
                ),
              ),

              // — Advanced: manual token entry —
              const SizedBox(height: 24),
              ExpansionTile(
                title: const Text('Advanced: Manual Token'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          controller: _googleTokenController,
                          decoration: const InputDecoration(
                            labelText: 'Google ID Token',
                            border: OutlineInputBorder(),
                            helperText: 'Paste a Google ID token for testing',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : _loginWithManualGoogleToken,
                            child: const Text('Submit Google Token'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _appleTokenController,
                          decoration: const InputDecoration(
                            labelText: 'Apple ID Token',
                            border: OutlineInputBorder(),
                            helperText: 'Paste an Apple ID token for testing',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : _loginWithManualAppleToken,
                            child: const Text('Submit Apple Token'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
