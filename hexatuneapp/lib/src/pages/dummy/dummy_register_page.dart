// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

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
      if (Env.isDev) {
        log.devLog(
          '→ Register attempt: email=$email',
          category: LogCategory.ui,
        );
      }

      final authRepo = getIt<AuthRepository>();
      final response = await authRepo.register(
        CreateAccountRequest(email: email, password: password),
      );

      if (Env.isDev) {
        log.devLog(
          '✓ Register success: ${response.toJson()}',
          category: LogCategory.ui,
        );
      }

      if (!mounted) return;
      _showMessage('Account created! Please verify your email.');

      // Navigate to OTP verification page with the registered email.
      context.go('${RouteNames.verifyEmail}?email=${Uri.encodeComponent(email)}');
    } catch (e) {
      if (Env.isDev) {
        log.devLog(
          '✗ Register failed: $e',
          category: LogCategory.ui,
        );
      }
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
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
                'Create Account',
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
                onSubmitted: (_) => _register(),
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
            ],
          ),
        ),
      ),
    );
  }
}
