// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/models/switch_tenant_request.dart';
import 'package:hexatuneapp/src/core/auth/models/tenant_membership_response.dart';
import 'package:hexatuneapp/src/core/auth/tenant_repository.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';

/// Dummy page for testing tenant membership and switching endpoints.
class DummyTenantsPage extends StatefulWidget {
  const DummyTenantsPage({super.key});

  @override
  State<DummyTenantsPage> createState() => _DummyTenantsPageState();
}

class _DummyTenantsPageState extends State<DummyTenantsPage> {
  final List<TenantMembershipResponse> _memberships = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMemberships();
  }

  Future<void> _loadMemberships() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<TenantRepository>();
      final memberships = await repo.listTenantMemberships();
      if (mounted) {
        setState(() {
          _memberships
            ..clear()
            ..addAll(memberships);
        });
      }
      if (Env.isDev) {
        log.devLog(
          '✓ Tenant memberships loaded: ${memberships.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      if (Env.isDev) {
        log.devLog('✗ Load memberships failed: $e', category: LogCategory.ui);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _switchTenant(String tenantId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<TenantRepository>();
      final response = await repo.switchTenant(
        SwitchTenantRequest(tenantId: tenantId),
      );

      // Save new tokens from switch response
      final tokenManager = getIt<TokenManager>();
      await tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      if (Env.isDev) {
        log.devLog(
          '✓ Switched to tenant $tenantId, '
          'sessionId=${response.sessionId}',
          category: LogCategory.ui,
        );
      }
      _showSnack('Switched to tenant $tenantId');
      await _loadMemberships();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      if (Env.isDev) {
        log.devLog('✗ Switch tenant failed: $e', category: LogCategory.ui);
      }
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
        title: const Text('Tenants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadMemberships,
          ),
        ],
      ),
      body: _isLoading && _memberships.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _memberships.isEmpty
          ? Center(child: Text('Error: $_error'))
          : _memberships.isEmpty
          ? const Center(child: Text('No tenant memberships'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _memberships.length + (_error != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _memberships.length && _error != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }
                return _buildMembershipCard(_memberships[index]);
              },
            ),
    );
  }

  Widget _buildMembershipCard(TenantMembershipResponse membership) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  membership.isOwner ? Icons.star : Icons.business,
                  color: membership.isOwner
                      ? Colors.amber
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tenant: ${membership.tenantId}',
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow('Membership ID', membership.id),
            _infoRow('Role', membership.role),
            _infoRow('Status', membership.status),
            _infoRow('Owner', membership.isOwner ? 'Yes' : 'No'),
            if (membership.joinedAt != null)
              _infoRow('Joined', membership.joinedAt!),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: _isLoading
                    ? null
                    : () => _switchTenant(membership.tenantId),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Switch'),
              ),
            ),
          ],
        ),
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
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
