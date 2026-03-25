// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/auth_header.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/password_strength_indicator.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/social_sign_in_buttons.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Registration page matching the Figma design.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Email registration
  // ---------------------------------------------------------------------------

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(l10n.emailAndPasswordRequired, isError: true);
      return;
    }
    if (password != confirm) {
      _showMessage(l10n.passwordsDoNotMatch, isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Register attempt: email=$email', category: LogCategory.ui);

      final authRepo = getIt<AuthRepository>();
      await authRepo.register(
        CreateAccountRequest(email: email, password: password),
      );

      log.devLog('✓ Register success', category: LogCategory.ui);

      if (!mounted) return;
      _showMessage(l10n.accountCreatedVerifyEmail, isError: false);

      context.go(
        '${RouteNames.verifyEmail}?email=${Uri.encodeComponent(email)}',
      );
    } catch (e) {
      log.devLog('✗ Register failed: $e', category: LogCategory.ui);
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // OAuth sign-up (unified endpoint)
  // ---------------------------------------------------------------------------

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
      final l10n = AppLocalizations.of(context)!;
      if (response.isNewAccount) {
        _showMessage(l10n.newAccountViaGoogle, isError: false);
      }
    } on OAuthCancelledException {
      log.devLog('→ Google sign-up cancelled', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Google sign-up failed: $e', category: LogCategory.ui);
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithApple() async {
    final oauthService = getIt<OAuthService>();
    if (!oauthService.isAppleSignInAvailable) {
      final l10n = AppLocalizations.of(context)!;
      _showMessage(l10n.appleSignInNotAvailable, isError: true);
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
      final l10n = AppLocalizations.of(context)!;
      if (response.isNewAccount) {
        _showMessage(l10n.newAccountViaApple, isError: false);
      }
    } on OAuthCancelledException {
      log.devLog('→ Apple sign-up cancelled', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Apple sign-up failed: $e', category: LogCategory.ui);
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Center(child: AuthHeader()),
                const SizedBox(height: 32),

                // Title + subtitle
                Text(
                  l10n.createAnAccount,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.signUpSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Email
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: l10n.emailAddress),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.password,
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
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 8),

                // Strength indicator
                PasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: 16),

                // Confirm password
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _register(),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up button
                FilledButton(
                  onPressed: _isLoading ? null : _register,
                  style: FilledButton.styleFrom(
                    elevation: 1,
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
                      : Text(l10n.signUp),
                ),
                const SizedBox(height: 24),

                // Social
                SocialSignInButtons(
                  onApplePressed: _signUpWithApple,
                  onGooglePressed: _signUpWithGoogle,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccountPrefix,
                      style: theme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.login),
                      child: Text(
                        l10n.signInLink,
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
    );
  }
}
