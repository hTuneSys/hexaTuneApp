// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/auth/models/re_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
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
  final _resetTokenCtrl = TextEditingController();
  final _resetPasswordCtrl = TextEditingController();
  final _reAuthPasswordCtrl = TextEditingController();
  String? _resultText;
  bool _isLoading = false;

  @override
  void dispose() {
    _forgotEmailCtrl.dispose();
    _resetTokenCtrl.dispose();
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
      if (Env.isDev) {
        log.devLog('→ $label', category: LogCategory.ui);
      }
      final result = await action();
      if (mounted) {
        setState(() => _resultText = '✓ $label\n$result');
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ $label failed: $e', category: LogCategory.ui);
      }
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
          TextField(
            controller: _forgotEmailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
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
                      return 'Reset email sent to ${_forgotEmailCtrl.text.trim()}';
                    }),
            child: const Text('Send Reset Email'),
          ),
          const Divider(height: 32),

          // Reset Password
          Text('Reset Password', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _resetTokenCtrl,
            decoration: const InputDecoration(
              labelText: 'Reset Token',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _resetPasswordCtrl,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Reset Password', () async {
                      final repo = getIt<AuthRepository>();
                      await repo.resetPassword(
                        ResetPasswordRequest(
                          token: _resetTokenCtrl.text.trim(),
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
          TextField(
            controller: _reAuthPasswordCtrl,
            decoration: const InputDecoration(
              labelText: 'Current Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Re-Authenticate', () async {
                      final repo = getIt<AuthRepository>();
                      final resp = await repo.reAuthenticate(
                        ReAuthRequest(
                          password: _reAuthPasswordCtrl.text,
                        ),
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
                      if (refreshToken == null) return 'No refresh token available';
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
