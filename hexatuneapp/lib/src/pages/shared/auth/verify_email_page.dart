// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/auth_header.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/hexagonal_background.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/otp_input_field.dart';

/// Email OTP verification page matching the Figma design.
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({required this.email, super.key});

  final String email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _otpKey = GlobalKey<OtpInputFieldState>();
  String _otpCode = '';
  bool _isLoading = false;
  bool _isResending = false;

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
  // Verify
  // ---------------------------------------------------------------------------

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context)!;
    if (_otpCode.length < 8) {
      _showMessage(l10n.otpRequired, isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Verify email: email=${widget.email}, code=$_otpCode',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      await authRepo.verifyEmail(
        VerifyEmailRequest(email: widget.email, code: _otpCode),
      );

      log.devLog('✓ Email verified successfully', category: LogCategory.ui);

      if (!mounted) return;
      _showMessage(l10n.emailVerifiedSignIn, isError: false);
      context.go(RouteNames.login);
    } catch (e) {
      log.devLog('✗ Verify failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Resend
  // ---------------------------------------------------------------------------

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final log = getIt<LogService>();

    try {
      log.devLog(
        '→ Resend OTP: email=${widget.email}',
        category: LogCategory.ui,
      );

      final authRepo = getIt<AuthRepository>();
      await authRepo.resendVerification(
        ResendVerificationRequest(email: widget.email),
      );

      log.devLog('✓ Verification email resent', category: LogCategory.ui);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showMessage(l10n.verificationCodeResent, isError: false);
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
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? theme.colorScheme.error
            : theme.colorScheme.primary,
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
                  children: [
                    const SizedBox(height: 48),
                    const AuthHeader(),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      l10n.enterOtpCode,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      l10n.verificationCodeSentTo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.enterDigitCodeBelow,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP input
                    OtpInputField(
                      key: _otpKey,
                      onCompleted: (code) {
                        _otpCode = code;
                        _verify();
                      },
                      onChanged: (code) => _otpCode = code,
                    ),
                    const SizedBox(height: 32),

                    // Verify button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _verify,
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
                            : Text(l10n.verify),
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
        ],
      ),
    );
  }
}
