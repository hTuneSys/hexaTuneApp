// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/account/account_repository.dart';
import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Dummy page for testing account and profile endpoints.
class DummyAccountPage extends StatefulWidget {
  const DummyAccountPage({super.key});

  @override
  State<DummyAccountPage> createState() => _DummyAccountPageState();
}

class _DummyAccountPageState extends State<DummyAccountPage> {
  final _displayNameCtrl = TextEditingController();
  final _avatarUrlCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  AccountResponse? _account;
  ProfileResponse? _profile;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _avatarUrlCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAccount() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<AccountRepository>();
      final account = await repo.getAccount();
      final profile = await repo.getProfile();
      if (mounted) {
        setState(() {
          _account = account;
          _profile = profile;
          _displayNameCtrl.text = profile.displayName ?? '';
          _avatarUrlCtrl.text = profile.avatarUrl ?? '';
          _bioCtrl.text = profile.bio ?? '';
        });
      }
      log.devLog('✓ Account loaded: ${account.id}', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Load account failed: $e', category: LogCategory.ui);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<AccountRepository>();
      final updated = await repo.updateProfile(
        UpdateProfileRequest(
          displayName: _displayNameCtrl.text.trim().isEmpty
              ? null
              : _displayNameCtrl.text.trim(),
          avatarUrl: _avatarUrlCtrl.text.trim().isEmpty
              ? null
              : _avatarUrlCtrl.text.trim(),
          bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
        ),
      );
      if (mounted) {
        setState(() => _profile = updated);
        _showMessage('Profile updated');
      }
      log.devLog('✓ Profile updated', category: LogCategory.ui);
    } catch (e) {
      log.devLog('✗ Update profile failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadAccount,
          ),
        ],
      ),
      body: _isLoading && _account == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _account == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAccount,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account info
                Text('Account', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_account != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow('ID', _account!.id),
                          _infoRow('Status', _account!.status),
                          _infoRow('Created', _account!.createdAt),
                          _infoRow('Updated', _account!.updatedAt),
                          if (_account!.lockedAt != null)
                            _infoRow('Locked At', _account!.lockedAt!),
                          if (_account!.suspendedAt != null)
                            _infoRow('Suspended At', _account!.suspendedAt!),
                        ],
                      ),
                    ),
                  ),
                const Divider(height: 32),

                // Profile
                Text('Profile', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_profile != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow('Account ID', _profile!.accountId),
                          _infoRow(
                            'Display Name',
                            _profile!.displayName ?? '—',
                          ),
                          _infoRow('Avatar URL', _profile!.avatarUrl ?? '—'),
                          _infoRow('Bio', _profile!.bio ?? '—'),
                          _infoRow('Updated', _profile!.updatedAt),
                        ],
                      ),
                    ),
                  ),
                const Divider(height: 32),

                // Update profile form
                Text('Update Profile', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _displayNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _avatarUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Avatar URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Profile'),
                ),
              ],
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
