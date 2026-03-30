// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/rest/session/session_repository.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Sessions management page for viewing and revoking active sessions.
class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  static const _borderRadius = 12.0;
  static const _pageLimit = 20;

  final _searchController = TextEditingController();
  final _log = getIt<LogService>();
  final _repo = getIt<SessionRepository>();

  final List<SessionResponse> _sessions = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
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

  // ── Data loading ─────────────────────────────────────────────────────────

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    try {
      final searchText = _searchController.text.trim();
      final resp = await _repo.listSessions(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: _pageLimit,
          query: searchText.isEmpty ? null : searchText,
          sort: _sortValue.isEmpty ? null : _sortValue,
        ),
      );
      if (!mounted) return;
      setState(() {
        if (!loadMore) _sessions.clear();
        _sessions.addAll(resp.data);
        _nextCursor = resp.pagination.nextCursor;
        _hasMore = resp.pagination.hasMore;
      });
      _log.debug(
        'Sessions loaded: ${resp.data.length}, hasMore=$_hasMore',
        category: LogCategory.ui,
      );
    } catch (e) {
      _log.warning('Load sessions failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Revoke actions ───────────────────────────────────────────────────────

  Future<void> _revokeOthers() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sessionsRevokeOthersTitle),
        content: Text(l10n.sessionsRevokeOthersMessage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.sessionsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.sessionsRevoke),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final resp = await _repo.revokeOthers();
      if (!mounted) return;
      AppSnackBar.success(
        context,
        message: l10n.sessionsRevokedCount(resp.revokedCount),
      );
      _load();
    } catch (e) {
      _log.warning('Revoke others failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _revokeAll() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sessionsRevokeAllTitle),
        content: Text(l10n.sessionsRevokeAllMessage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.sessionsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.sessionsRevoke),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await _repo.revokeAll();
    } catch (e) {
      _log.warning('Revoke all failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionsTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'others') _revokeOthers();
              if (v == 'all') _revokeAll();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'others',
                child: Text(l10n.sessionsRevokeOthers),
              ),
              PopupMenuItem(value: 'all', child: Text(l10n.sessionsRevokeAll)),
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
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(_borderRadius),
                    color: colorScheme.surfaceContainerLow,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.sessionsSearch,
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _load(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortValue,
                  hint: Text(l10n.sessionsSort),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(l10n.sessionsSortDefault),
                    ),
                    DropdownMenuItem(
                      value: '-last_activity_at',
                      child: Text(l10n.sessionsSortRecentActivity),
                    ),
                    DropdownMenuItem(
                      value: 'last_activity_at',
                      child: Text(l10n.sessionsSortOldestActivity),
                    ),
                    DropdownMenuItem(
                      value: '-created_at',
                      child: Text(l10n.sessionsSortNewest),
                    ),
                    DropdownMenuItem(
                      value: 'created_at',
                      child: Text(l10n.sessionsSortOldest),
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
      body: _buildBody(l10n, theme, colorScheme),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (_isLoading && _sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => _load(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          8,
          8,
          8,
          8 + AppBottomBar.scrollPadding,
        ),
        itemCount: _sessions.length + (_hasMore ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (i == _sessions.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton(
                  onPressed: _isLoading ? null : () => _load(loadMore: true),
                  child: Text(l10n.sessionsLoadMore),
                ),
              ),
            );
          }
          return _buildSessionCard(_sessions[i], l10n, theme, colorScheme);
        },
      ),
    );
  }

  Widget _buildSessionCard(
    SessionResponse session,
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final truncatedId = session.id.length > 8
        ? '${session.id.substring(0, 8)}…'
        : session.id;
    final truncatedDevice = session.deviceId.length > 8
        ? '${session.deviceId.substring(0, 8)}…'
        : session.deviceId;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: ListTile(
        leading: Icon(Icons.devices, color: colorScheme.primary),
        title: Text(truncatedId, style: theme.textTheme.titleSmall),
        subtitle: Text(
          '${l10n.sessionsDevice}: $truncatedDevice\n'
          '${l10n.sessionsCreated}: ${session.createdAt}\n'
          '${l10n.sessionsExpires}: ${session.expiresAt}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
