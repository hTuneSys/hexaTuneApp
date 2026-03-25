// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/auth_header.dart';

/// Forgot password page — sends OTP reset code to the given email.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError(l10n.emailRequired);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Forgot password: email=$email', category: LogCategory.ui);

      final authRepo = getIt<AuthRepository>();
      await authRepo.forgotPassword(ForgotPasswordRequest(email: email));

      log.devLog('✓ Reset code sent', category: LogCategory.ui);

      if (!mounted) return;
      _showInfo(l10n.otpSentTo(email));

      context.go(
        '${RouteNames.resetPassword}?email=${Uri.encodeComponent(email)}',
      );
    } catch (e) {
      log.devLog('✗ Forgot password failed: $e', category: LogCategory.ui);
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                const SizedBox(height: 48),
                const Center(child: AuthHeader()),
                const SizedBox(height: 48),

                // Title + subtitle
                Text(
                  l10n.forgotPasswordTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.forgotPasswordSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email field
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: l10n.emailAddress),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _sendResetCode(),
                  ),
                ),
                const SizedBox(height: 24),

                // Send Reset Code button
                FilledButton(
                  onPressed: _isLoading ? null : _sendResetCode,
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
                      : Text(l10n.sendResetCode),
                ),
                const SizedBox(height: 24),

                // Back to sign in
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
