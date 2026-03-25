// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Dummy register page for testing auth flow — will be replaced with production UI.
class DummyRegisterPage extends StatefulWidget {
  const DummyRegisterPage({super.key});

  @override
  State<DummyRegisterPage> createState() => _DummyRegisterPageState();
}

class _DummyRegisterPageState extends State<DummyRegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email and password are required', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Register attempt: email=$email', category: LogCategory.ui);

      final authRepo = getIt<AuthRepository>();
      final response = await authRepo.register(
        CreateAccountRequest(email: email, password: password),
      );

      log.devLog(
        '✓ Register success: ${response.toJson()}',
        category: LogCategory.ui,
      );

      if (!mounted) return;
      _showMessage('Account created! Please verify your email.');

      context.go(
        '${RouteNames.verifyEmail}?email=${Uri.encodeComponent(email)}',
      );
    } catch (e) {
      log.devLog('✗ Register failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      final oauthService = getIt<OAuthService>();
      final authService = getIt<AuthService>();

      final request = await oauthService.signInWithGoogle();
      final response = await authService.loginWithGoogle(request);

      log.devLog(
        '✓ Google sign-up: sessionId=${response.sessionId}, '
        'isNewAccount=${response.isNewAccount}',
        category: LogCategory.ui,
      );

      if (!mounted) return;
      if (response.isNewAccount) {
        _showMessage('Account created via Google!');
      } else {
        _showMessage('Logged in — account already existed', isError: false);
      }
    } on OAuthCancelledException {
      log.devLog('→ Google sign-up cancelled', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Google sign-up failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithApple() async {
    final oauthService = getIt<OAuthService>();
    if (!oauthService.isAppleSignInAvailable) {
      _showMessage('Apple Sign-In is only available on iOS', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      final authService = getIt<AuthService>();

      final request = await oauthService.signInWithApple();
      final response = await authService.loginWithApple(request);

      log.devLog(
        '✓ Apple sign-up: sessionId=${response.sessionId}, '
        'isNewAccount=${response.isNewAccount}',
        category: LogCategory.ui,
      );

      if (!mounted) return;
      if (response.isNewAccount) {
        _showMessage('Account created via Apple!');
      } else {
        _showMessage('Logged in — account already existed', isError: false);
      }
    } on OAuthCancelledException {
      log.devLog('→ Apple sign-up cancelled', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Apple sign-up failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            32,
            32,
            32,
            32 + AppBottomBar.scrollPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 48),

              // — Email registration —
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 16),
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _register(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('or Sign In'),
              ),

              // — OAuth sign-up (unified endpoint) —
              const Divider(height: 48),
              Text(
                'OAuth Sign-Up',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signUpWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign up with Google'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signUpWithApple,
                  icon: const Icon(Icons.apple),
                  label: const Text('Sign up with Apple'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
