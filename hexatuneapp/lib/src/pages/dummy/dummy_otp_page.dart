// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';

/// Dummy OTP verification page for testing — will be replaced with production UI.
class DummyOtpPage extends StatefulWidget {
  const DummyOtpPage({required this.email, super.key});

  final String email;

  @override
  State<DummyOtpPage> createState() => _DummyOtpPageState();
}

class _DummyOtpPageState extends State<DummyOtpPage> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _showMessage('Please enter the OTP code', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();

    try {
      if (Env.isDev) {
        log.devLog(
          '→ Verify email: email=${widget.email}, code=$code',
          category: LogCategory.ui,
        );
      }

      final authRepo = getIt<AuthRepository>();
      await authRepo.verifyEmail(
        VerifyEmailRequest(email: widget.email, code: code),
      );

      if (Env.isDev) {
        log.devLog('✓ Email verified successfully', category: LogCategory.ui);
      }

      if (!mounted) return;
      _showMessage('Email verified! Please sign in.');
      context.go(RouteNames.login);
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Verify failed: $e', category: LogCategory.ui);
      }
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final log = getIt<LogService>();

    try {
      if (Env.isDev) {
        log.devLog(
          '→ Resend OTP: email=${widget.email}',
          category: LogCategory.ui,
        );
      }

      final authRepo = getIt<AuthRepository>();
      await authRepo.resendVerification(
        ResendVerificationRequest(email: widget.email),
      );

      if (Env.isDev) {
        log.devLog('✓ Verification email resent', category: LogCategory.ui);
      }

      if (mounted) _showMessage('Verification code resent to ${widget.email}');
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Resend failed: $e', category: LogCategory.ui);
      }
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

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
                'Verify Email',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the 8-digit code sent to\n${widget.email}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'OTP Code',
                  hintText: '12345678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 8,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verify(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verify,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isResending ? null : _resendOtp,
                child: _isResending
                    ? const Text('Sending...')
                    : const Text('Resend Code'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
