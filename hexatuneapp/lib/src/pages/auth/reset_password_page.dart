// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/auth_header.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/otp_input_field.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/password_strength_indicator.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Reset password page with OTP verification + new password, matching Figma.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({required this.email, super.key});

  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _otpCode = '';
  bool _isLoading = false;
  bool _isResending = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Resend countdown
  int _resendSeconds = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _formattedTimer {
    final m = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ---------------------------------------------------------------------------
  // Reset password
  // ---------------------------------------------------------------------------

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;

    if (_otpCode.length < 8) {
      _showMessage(l10n.otpRequired, isError: true);
      return;
    }

    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.isEmpty) {
      _showMessage(l10n.passwordRequired, isError: true);
      return;
    }
    if (password != confirm) {
      _showMessage(l10n.passwordsDoNotMatch, isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Reset password: email=${widget.email}, code=$_otpCode',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      await authRepo.resetPassword(
        ResetPasswordRequest(
          email: widget.email,
          code: _otpCode,
          newPassword: password,
        ),
      );

      log.devLog('✓ Password reset successfully', category: LogCategory.ui);

      if (!mounted) return;
      _showMessage(l10n.passwordResetSuccess, isError: false);
      context.go(RouteNames.login);
    } catch (e) {
      log.devLog('✗ Reset password failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Resend OTP
  // ---------------------------------------------------------------------------

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Resend password reset OTP: email=${widget.email}',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      await authRepo.resendPasswordReset(
        ResendPasswordResetRequest(email: widget.email),
      );

      log.devLog('✓ Password reset OTP resent', category: LogCategory.ui);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showMessage(l10n.otpSentTo(widget.email), isError: false);
        _startResendTimer();
      }
    } catch (e) {
      log.devLog('✗ Resend failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isResending = false);
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
              children: [
                const SizedBox(height: 48),
                const AuthHeader(),
                const SizedBox(height: 32),

                // Title + subtitle
                Text(
                  l10n.resetYourPassword,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.resetPasswordSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // OTP input
                OtpInputField(
                  onCompleted: (code) => _otpCode = code,
                  onChanged: (code) => _otpCode = code,
                ),
                const SizedBox(height: 24),

                // New Password
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surfaceContainerLow,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.newPassword,
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
                ),
                const SizedBox(height: 8),

                // Strength indicator
                PasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: 16),

                // Confirm Password
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surfaceContainerLow,
                    child: TextField(
                      controller: _confirmController,
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _resetPassword(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Reset Password button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _resetPassword,
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
                        : Text(l10n.resetPassword),
                  ),
                ),
                const SizedBox(height: 24),

                // Resend section
                Text(
                  l10n.didntReceiveCode,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                if (_resendSeconds > 0)
                  Text(
                    l10n.resendIn(_formattedTimer),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  TextButton(
                    onPressed: _isResending ? null : _resendOtp,
                    child: _isResending
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Text(l10n.resendCode),
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
