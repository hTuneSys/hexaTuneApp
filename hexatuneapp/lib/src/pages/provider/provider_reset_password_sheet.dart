// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/storage/otp_timer_service.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/otp_input_field.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/password_strength_indicator.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Bottom sheet for resetting password of a linked email provider.
///
/// Flow: forgotPassword → OTP + new password → resetPassword.
class ProviderResetPasswordSheet extends StatefulWidget {
  const ProviderResetPasswordSheet({
    required this.email,
    this.onSuccess,
    super.key,
  });

  final String email;
  final VoidCallback? onSuccess;

  @override
  State<ProviderResetPasswordSheet> createState() =>
      _ProviderResetPasswordSheetState();
}

class _ProviderResetPasswordSheetState
    extends State<ProviderResetPasswordSheet> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _otpCode = '';
  bool _isLoading = false;
  bool _isResending = false;
  bool _isSendingOtp = false;
  bool _otpSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  int _resendSeconds = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _checkExistingTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkExistingTimer() {
    final otpTimer = getIt<OtpTimerService>();
    final remaining = otpTimer.getRemainingSeconds(
      OtpFlow.passwordReset,
      widget.email,
    );
    if (remaining > 0) {
      _resendSeconds = remaining;
      _otpSent = true;
      _startCountdown();
    }
  }

  // ---------------------------------------------------------------------------
  // Send OTP
  // ---------------------------------------------------------------------------

  Future<void> _sendOtp() async {
    setState(() => _isSendingOtp = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Forgot password for provider: ${widget.email}',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      final result = await authRepo.forgotPassword(
        ForgotPasswordRequest(email: widget.email),
      );

      final otpTimer = getIt<OtpTimerService>();
      await otpTimer.saveOtpExpiry(
        OtpFlow.passwordReset,
        widget.email,
        result.expiresInSeconds,
      );

      log.devLog('✓ Password reset OTP sent', category: LogCategory.ui);

      if (!mounted) return;
      setState(() {
        _otpSent = true;
        _resendSeconds = result.expiresInSeconds;
      });
      _startCountdown();
    } catch (e) {
      log.devLog('✗ Send OTP failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Reset password
  // ---------------------------------------------------------------------------

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;

    if (_otpCode.length < 6) {
      AppSnackBar.error(context, message: l10n.otpRequired);
      return;
    }

    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.isEmpty) {
      AppSnackBar.error(context, message: l10n.passwordRequired);
      return;
    }
    if (password != confirm) {
      AppSnackBar.error(context, message: l10n.passwordsDoNotMatch);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Reset password for provider: ${widget.email}',
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

      log.devLog('✓ Provider password reset', category: LogCategory.ui);

      if (!mounted) return;
      AppSnackBar.success(context, message: l10n.providerPasswordResetSuccess);
      widget.onSuccess?.call();
      Navigator.of(context).pop();
    } catch (e) {
      log.devLog('✗ Reset password failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
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
        '→ Resend password reset OTP: ${widget.email}',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      final result = await authRepo.resendPasswordReset(
        ResendPasswordResetRequest(email: widget.email),
      );

      final otpTimer = getIt<OtpTimerService>();
      await otpTimer.saveOtpExpiry(
        OtpFlow.passwordReset,
        widget.email,
        result.expiresInSeconds,
      );

      log.devLog('✓ Password reset OTP resent', category: LogCategory.ui);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.success(context, message: l10n.otpSentTo(widget.email));
      setState(() => _resendSeconds = result.expiresInSeconds);
      _startCountdown();
    } catch (e) {
      log.devLog('✗ Resend failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Timer
  // ---------------------------------------------------------------------------

  void _startCountdown() {
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
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              l10n.providerResetPasswordTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.providerResetPasswordSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            if (!_otpSent) ...[
              // Send OTP button
              FilledButton(
                onPressed: _isSendingOtp ? null : _sendOtp,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSendingOtp
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
            ] else ...[
              // OTP input
              OtpInputField(
                onCompleted: (code) => _otpCode = code,
                onChanged: (code) => _otpCode = code,
              ),
              const SizedBox(height: 24),

              // New Password
              Material(
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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 8),
              PasswordStrengthIndicator(password: _passwordController.text),
              const SizedBox(height: 16),

              // Confirm Password
              Material(
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
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _resetPassword(),
                ),
              ),
              const SizedBox(height: 24),

              // Reset button
              FilledButton(
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
              const SizedBox(height: 16),

              // Resend section
              Center(
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
