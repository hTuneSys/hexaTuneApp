// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/device/device_repository.dart';
import 'package:hexatuneapp/src/core/device/device_service.dart';
import 'package:hexatuneapp/src/core/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

/// Dummy login page for testing auth flow — will be replaced with production UI.
class DummyLoginPage extends StatefulWidget {
  const DummyLoginPage({super.key});

  @override
  State<DummyLoginPage> createState() => _DummyLoginPageState();
}

class _DummyLoginPageState extends State<DummyLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password are required');
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

      // Register push token after successful login.
      await _registerPushToken();

      // Router will auto-redirect to home via auth state change.
    } catch (e) {
      if (Env.isDev) {
        log.devLog(
          '✗ Login failed: $e',
          category: LogCategory.ui,
        );
      }
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _registerPushToken() async {
    try {
      final notificationService = getIt<NotificationService>();

      // Attempt to initialize notification service if not already done.
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
      if (fcmToken == null) {
        if (Env.isDev) {
          getIt<LogService>().devLog(
            'Push token registration skipped — no FCM token',
            category: LogCategory.notification,
          );
        }
        return;
      }

      final deviceRepo = getIt<DeviceRepository>();
      await deviceRepo.registerPushToken(
        RegisterPushTokenRequest(
          token: fcmToken,
          platform: Platform.isIOS ? 'ios' : 'android',
        ),
      );
      getIt<LogService>().info(
        'Push token registered after login',
        category: LogCategory.notification,
      );
      if (Env.isDev) {
        getIt<LogService>().devLog(
          '✓ Push token registered: $fcmToken',
          category: LogCategory.notification,
        );
      }
    } catch (e) {
      getIt<LogService>().warning(
        'Push token registration failed (non-critical)',
        category: LogCategory.notification,
        exception: e,
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                'hexaTune',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(RouteNames.register),
                child: const Text('or Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
