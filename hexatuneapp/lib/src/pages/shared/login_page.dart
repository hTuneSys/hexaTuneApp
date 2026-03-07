// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/auth/auth_service.dart';
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
import 'package:hexatuneapp/src/pages/shared/widgets/auth_header.dart';
import 'package:hexatuneapp/src/pages/shared/widgets/hexagonal_background.dart';
import 'package:hexatuneapp/src/pages/shared/widgets/social_sign_in_buttons.dart';

/// Login page matching the Figma design.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Email login
  // ---------------------------------------------------------------------------

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError(l10n.emailAndPasswordRequired);
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
  // OAuth flows
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
          '✓ Google sign-in: sessionId=${response.sessionId}, '
          'isNewAccount=${response.isNewAccount}',
          category: LogCategory.ui,
        );
      }

      if (mounted && response.isNewAccount) {
        final l10n = AppLocalizations.of(context)!;
        _showInfo(l10n.newAccountViaGoogle);
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
      final l10n = AppLocalizations.of(context)!;
      _showError(l10n.appleSignInNotAvailable);
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
          '✓ Apple sign-in: sessionId=${response.sessionId}, '
          'isNewAccount=${response.isNewAccount}',
          category: LogCategory.ui,
        );
      }

      if (mounted && response.isNewAccount) {
        final l10n = AppLocalizations.of(context)!;
        _showInfo(l10n.newAccountViaApple);
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
      if (fcmToken == null) return;

      final deviceRepo = getIt<DeviceRepository>();
      await deviceRepo.registerPushToken(
        RegisterPushTokenRequest(
          token: fcmToken,
          platform: Platform.isIOS ? 'ios' : 'android',
        ),
      );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const HexagonalBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Center(child: AuthHeader()),
                    const SizedBox(height: 48),

                    // Title
                    Text(
                      l10n.signInTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.emailAddress,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                    ),

                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go(RouteNames.forgotPassword),
                        child: Text(
                          l10n.forgotPasswordQuestion,
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Sign In button
                    FilledButton(
                      onPressed: _isLoading ? null : _login,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Text(l10n.signIn),
                    ),
                    const SizedBox(height: 24),

                    // Social sign-in
                    SocialSignInButtons(
                      onApplePressed: _signInWithApple,
                      onGooglePressed: _signInWithGoogle,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccountPrefix,
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => context.go(RouteNames.register),
                          child: Text(
                            l10n.createAccount,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
