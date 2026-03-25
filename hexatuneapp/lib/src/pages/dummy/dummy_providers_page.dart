// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Dummy page for testing provider management endpoints.
class DummyProvidersPage extends StatefulWidget {
  const DummyProvidersPage({super.key});

  @override
  State<DummyProvidersPage> createState() => _DummyProvidersPageState();
}

class _DummyProvidersPageState extends State<DummyProvidersPage> {
  final List<ProviderResponse> _providers = [];
  bool _isLoading = false;
  String? _error;
  bool _showManualGoogle = false;
  bool _showManualApple = false;

  // Link form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _googleTokenController = TextEditingController();
  final _appleTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _googleTokenController.dispose();
    _appleTokenController.dispose();
    super.dispose();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<ProviderRepository>();
      final providers = await repo.listProviders();
      if (mounted) {
        setState(() {
          _providers
            ..clear()
            ..addAll(providers);
        });
      }
      log.devLog(
        '✓ Providers loaded: ${providers.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      log.devLog('✗ Load providers failed: $e', category: LogCategory.ui);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _linkEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email and password are required');
      return;
    }
    await _runAction('Link email provider', () async {
      final repo = getIt<ProviderRepository>();
      await repo.linkEmail(
        LinkEmailProviderRequest(email: email, password: password),
      );
    });
  }

  Future<void> _linkGoogleWithOAuth() async {
    final log = getIt<LogService>();
    try {
      final oauthService = getIt<OAuthService>();
      final request = await oauthService.signInWithGoogle();
      await _runAction('Link Google provider', () async {
        final repo = getIt<ProviderRepository>();
        await repo.linkGoogle(
          LinkGoogleProviderRequest(idToken: request.idToken),
        );
      });
    } on OAuthCancelledException {
      _showSnack('Google Sign-In cancelled');
    } on OAuthException catch (e) {
      if (mounted) setState(() => _error = e.toString());
      log.devLog('✗ Google link sign-in failed: $e', category: LogCategory.ui);
    }
  }

  Future<void> _linkGoogleManual() async {
    final token = _googleTokenController.text.trim();
    if (token.isEmpty) {
      _showSnack('Google ID token is required');
      return;
    }
    await _runAction('Link Google provider', () async {
      final repo = getIt<ProviderRepository>();
      await repo.linkGoogle(LinkGoogleProviderRequest(idToken: token));
    });
  }

  Future<void> _linkAppleWithOAuth() async {
    final log = getIt<LogService>();
    try {
      final oauthService = getIt<OAuthService>();
      final request = await oauthService.signInWithApple();
      await _runAction('Link Apple provider', () async {
        final repo = getIt<ProviderRepository>();
        await repo.linkApple(
          LinkAppleProviderRequest(idToken: request.idToken),
        );
      });
    } on OAuthCancelledException {
      _showSnack('Apple Sign-In cancelled');
    } on OAuthNotAvailableException {
      _showSnack('Apple Sign-In is not available on this platform');
    } on OAuthException catch (e) {
      if (mounted) setState(() => _error = e.toString());
      log.devLog('✗ Apple link sign-in failed: $e', category: LogCategory.ui);
    }
  }

  Future<void> _linkAppleManual() async {
    final token = _appleTokenController.text.trim();
    if (token.isEmpty) {
      _showSnack('Apple ID token is required');
      return;
    }
    await _runAction('Link Apple provider', () async {
      final repo = getIt<ProviderRepository>();
      await repo.linkApple(LinkAppleProviderRequest(idToken: token));
    });
  }

  Future<void> _unlinkProvider(String providerType) async {
    await _runAction('Unlink $providerType', () async {
      final repo = getIt<ProviderRepository>();
      await repo.unlinkProvider(providerType);
    });
  }

  Future<void> _runAction(String label, Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      await action();
      log.devLog('✓ $label succeeded', category: LogCategory.ui);
      _showSnack('$label succeeded');
      await _loadProviders();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      log.devLog('✗ $label failed: $e', category: LogCategory.ui);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Providers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadProviders,
          ),
        ],
      ),
      body: _isLoading && _providers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _providers.isEmpty
          ? Center(child: Text('Error: $_error'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current providers list
                Text(
                  'Linked Providers',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_providers.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No providers linked'),
                    ),
                  )
                else
                  ..._providers.map(_buildProviderCard),

                const Divider(height: 32),

                // Link email provider
                Text(
                  'Link Email Provider',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _linkEmail,
                  child: const Text('Link Email'),
                ),

                const Divider(height: 32),

                // Link Google provider
                Text(
                  'Link Google Provider',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _linkGoogleWithOAuth,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Link with Google'),
                ),
                const SizedBox(height: 8),
                // Advanced: manual token entry
                GestureDetector(
                  onTap: () =>
                      setState(() => _showManualGoogle = !_showManualGoogle),
                  child: Row(
                    children: [
                      Icon(
                        _showManualGoogle
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Advanced: Manual Token',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (_showManualGoogle) ...[
                  const SizedBox(height: 8),
                  Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: TextField(
                      controller: _googleTokenController,
                      decoration: const InputDecoration(
                        labelText: 'Google ID Token',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _linkGoogleManual,
                    child: const Text('Link with Manual Token'),
                  ),
                ],

                const Divider(height: 32),

                // Link Apple provider
                Text(
                  'Link Apple Provider',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (Platform.isIOS || Platform.isMacOS)
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _linkAppleWithOAuth,
                    icon: const Icon(Icons.apple),
                    label: const Text('Link with Apple'),
                  )
                else
                  Text(
                    'Apple Sign-In is only available on iOS/macOS',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                // Advanced: manual token entry
                GestureDetector(
                  onTap: () =>
                      setState(() => _showManualApple = !_showManualApple),
                  child: Row(
                    children: [
                      Icon(
                        _showManualApple
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Advanced: Manual Token',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (_showManualApple) ...[
                  const SizedBox(height: 8),
                  Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: TextField(
                      controller: _appleTokenController,
                      decoration: const InputDecoration(
                        labelText: 'Apple ID Token',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _linkAppleManual,
                    child: const Text('Link with Manual Token'),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildProviderCard(ProviderResponse provider) {
    return Card(
      child: ListTile(
        leading: Icon(_iconForProvider(provider.providerType)),
        title: Text(provider.providerType),
        subtitle: Text(
          provider.email != null
              ? '${provider.email}\nLinked: ${provider.linkedAt}'
              : 'Linked: ${provider.linkedAt}',
        ),
        isThreeLine: provider.email != null,
        trailing: IconButton(
          icon: Icon(
            Icons.link_off,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: _isLoading
              ? null
              : () => _unlinkProvider(provider.providerType),
          tooltip: 'Unlink',
        ),
      ),
    );
  }

  IconData _iconForProvider(String type) {
    switch (type.toLowerCase()) {
      case 'google':
        return Icons.g_mobiledata;
      case 'apple':
        return Icons.apple;
      case 'email':
        return Icons.email;
      default:
        return Icons.link;
    }
  }
}
