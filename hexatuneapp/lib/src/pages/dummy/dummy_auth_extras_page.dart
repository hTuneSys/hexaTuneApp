// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Dummy page for testing auth extras: forgot/reset password, re-auth, refresh.
class DummyAuthExtrasPage extends StatefulWidget {
  const DummyAuthExtrasPage({super.key});

  @override
  State<DummyAuthExtrasPage> createState() => _DummyAuthExtrasPageState();
}

class _DummyAuthExtrasPageState extends State<DummyAuthExtrasPage> {
  final _forgotEmailCtrl = TextEditingController();
  final _resetEmailCtrl = TextEditingController();
  final _resetCodeCtrl = TextEditingController();
  final _resetPasswordCtrl = TextEditingController();
  final _reAuthPasswordCtrl = TextEditingController();
  String? _resultText;
  bool _isLoading = false;

  @override
  void dispose() {
    _forgotEmailCtrl.dispose();
    _resetEmailCtrl.dispose();
    _resetCodeCtrl.dispose();
    _resetPasswordCtrl.dispose();
    _reAuthPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _run(String label, Future<String> Function() action) async {
    setState(() {
      _isLoading = true;
      _resultText = null;
    });
    final log = getIt<LogService>();
    try {
      log.devLog('→ $label', category: LogCategory.ui);
      final result = await action();
      if (mounted) {
        setState(() => _resultText = '✓ $label\n$result');
      }
    } catch (e) {
      log.devLog('✗ $label failed: $e', category: LogCategory.ui);
      if (mounted) {
        setState(() => _resultText = '✗ $label\n$e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Extras')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Forgot Password
          Text('Forgot Password', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: TextField(
              controller: _forgotEmailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Forgot Password', () async {
                    final repo = getIt<AuthRepository>();
                    await repo.forgotPassword(
                      ForgotPasswordRequest(
                        email: _forgotEmailCtrl.text.trim(),
                      ),
                    );
                    return 'OTP code sent to ${_forgotEmailCtrl.text.trim()}';
                  }),
            child: const Text('Send Reset OTP'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Resend Password Reset', () async {
                    final repo = getIt<AuthRepository>();
                    await repo.resendPasswordReset(
                      ResendPasswordResetRequest(
                        email: _forgotEmailCtrl.text.trim(),
                      ),
                    );
                    return 'OTP code resent to ${_forgotEmailCtrl.text.trim()}';
                  }),
            child: const Text('Resend OTP'),
          ),
          const Divider(height: 32),

          // Reset Password (OTP-based)
          Text('Reset Password', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: TextField(
              controller: _resetEmailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: TextField(
              controller: _resetCodeCtrl,
              decoration: const InputDecoration(
                labelText: 'OTP Code (6 digits)',
                hintText: '123456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: TextField(
              controller: _resetPasswordCtrl,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Reset Password', () async {
                    final repo = getIt<AuthRepository>();
                    await repo.resetPassword(
                      ResetPasswordRequest(
                        email: _resetEmailCtrl.text.trim(),
                        code: _resetCodeCtrl.text.trim(),
                        newPassword: _resetPasswordCtrl.text,
                      ),
                    );
                    return 'Password reset successfully';
                  }),
            child: const Text('Reset Password'),
          ),
          const Divider(height: 32),

          // Re-Authenticate
          Text('Re-Authenticate', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerLow,
            child: TextField(
              controller: _reAuthPasswordCtrl,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Re-Authenticate', () async {
                    final repo = getIt<AuthRepository>();
                    final resp = await repo.reAuthenticate(
                      ReAuthRequest(password: _reAuthPasswordCtrl.text),
                    );
                    return 'Token: ${resp.token.substring(0, 20)}…\n'
                        'Expires: ${resp.expiresAt}';
                  }),
            child: const Text('Re-Authenticate'),
          ),
          const Divider(height: 32),

          // Refresh Token
          Text('Refresh Token', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Refresh Token', () async {
                    final tokenMgr = getIt<TokenManager>();
                    final refreshToken = tokenMgr.refreshToken;
                    if (refreshToken == null) {
                      return 'No refresh token available';
                    }
                    final repo = getIt<AuthRepository>();
                    final resp = await repo.refresh(
                      RefreshRequest(refreshToken: refreshToken),
                    );
                    await tokenMgr.saveTokens(
                      accessToken: resp.accessToken,
                      refreshToken: resp.refreshToken,
                      sessionId: resp.sessionId,
                      expiresAt: resp.expiresAt,
                    );
                    return 'Session: ${resp.sessionId}\n'
                        'Expires: ${resp.expiresAt}';
                  }),
            child: const Text('Refresh Token'),
          ),
          const Divider(height: 32),

          // Result display
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_resultText != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _resultText!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
