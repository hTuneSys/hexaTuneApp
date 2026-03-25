// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/rest/session/session_repository.dart';

/// Dummy page for testing session management endpoints.
class DummySessionsPage extends StatefulWidget {
  const DummySessionsPage({super.key});

  @override
  State<DummySessionsPage> createState() => _DummySessionsPageState();
}

class _DummySessionsPageState extends State<DummySessionsPage> {
  final _searchController = TextEditingController();
  final List<SessionResponse> _sessions = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  String? _error;
  String _sortValue = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<SessionRepository>();
      final searchText = _searchController.text.trim();
      final resp = await repo.listSessions(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
          query: searchText.isEmpty ? null : searchText,
          sort: _sortValue.isEmpty ? null : _sortValue,
        ),
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _sessions.clear();
          _sessions.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        '✓ Sessions loaded: ${resp.data.length}, hasMore=$_hasMore',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load sessions failed: $e', category: LogCategory.ui);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _revokeOthers() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Other Sessions'),
        content: const Text(
          'This will terminate all sessions except the current one.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<SessionRepository>();
      final resp = await repo.revokeOthers();
      if (mounted) {
        _showMessage('Revoked ${resp.revokedCount} sessions');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _revokeAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke ALL Sessions'),
        content: const Text(
          'This will terminate ALL sessions including the current one. '
          'You will be logged out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revoke All'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<SessionRepository>();
      await repo.revokeAll();
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _load(),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'others') _revokeOthers();
              if (v == 'all') _revokeAll();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'others', child: Text('Revoke Others')),
              PopupMenuItem(value: 'all', child: Text('Revoke All')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _load(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortValue,
                  hint: const Text('Sort'),
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Default')),
                    DropdownMenuItem(
                      value: '-last_activity_at',
                      child: Text('Recent activity'),
                    ),
                    DropdownMenuItem(
                      value: 'last_activity_at',
                      child: Text('Oldest activity'),
                    ),
                    DropdownMenuItem(
                      value: '-created_at',
                      child: Text('Newest'),
                    ),
                    DropdownMenuItem(
                      value: 'created_at',
                      child: Text('Oldest'),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => _sortValue = v ?? '');
                    _load();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading && _sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _sessions.isEmpty
          ? Center(child: Text(_error!))
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _sessions.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _sessions.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final s = _sessions[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.devices),
                      title: Text('Session ${s.id.substring(0, 8)}…'),
                      subtitle: Text(
                        'Device: ${s.deviceId.substring(0, 8)}…\n'
                        'Created: ${s.createdAt}\n'
                        'Expires: ${s.expiresAt}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
