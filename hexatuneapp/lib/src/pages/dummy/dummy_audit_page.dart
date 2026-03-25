// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/audit/audit_repository.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Dummy page for testing audit log query endpoint.
class DummyAuditPage extends StatefulWidget {
  const DummyAuditPage({super.key});

  @override
  State<DummyAuditPage> createState() => _DummyAuditPageState();
}

class _DummyAuditPageState extends State<DummyAuditPage> {
  final _actionCtrl = TextEditingController();
  final _resourceTypeCtrl = TextEditingController();
  final _actorTypeCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final List<AuditLogDto> _logs = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  DateTimeRange? _dateRange;
  String _sortValue = '';
  String? _outcomeFilter;
  String? _severityFilter;

  @override
  void dispose() {
    _actionCtrl.dispose();
    _resourceTypeCtrl.dispose();
    _actorTypeCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<AuditRepository>();
      final searchText = _searchCtrl.text.trim();
      final resp = await repo.queryLogs(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
          query: searchText.isEmpty ? null : searchText,
          sort: _sortValue.isEmpty ? null : _sortValue,
        ),
        filters: AuditLogQueryParams(
          action: _actionCtrl.text.trim().isEmpty
              ? null
              : _actionCtrl.text.trim(),
          resourceType: _resourceTypeCtrl.text.trim().isEmpty
              ? null
              : _resourceTypeCtrl.text.trim(),
          actorType: _actorTypeCtrl.text.trim().isEmpty
              ? null
              : _actorTypeCtrl.text.trim(),
          outcome: _outcomeFilter,
          severity: _severityFilter,
          from: _dateRange?.start.toUtc().toIso8601String(),
          to: _dateRange?.end.toUtc().toIso8601String(),
        ),
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _logs.clear();
          _logs.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        '✓ Audit logs loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load audit logs failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
    }
  }

  void _clearFilters() {
    setState(() {
      _actionCtrl.clear();
      _resourceTypeCtrl.clear();
      _actorTypeCtrl.clear();
      _searchCtrl.clear();
      _dateRange = null;
      _sortValue = '';
      _outcomeFilter = null;
      _severityFilter = null;
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear Filters',
            onPressed: _clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search and sort row
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _load(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _sortValue,
                      hint: const Text('Sort'),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('Default')),
                        DropdownMenuItem(
                          value: '-occurred_at',
                          child: Text('Newest'),
                        ),
                        DropdownMenuItem(
                          value: 'occurred_at',
                          child: Text('Oldest'),
                        ),
                        DropdownMenuItem(
                          value: 'severity',
                          child: Text('Severity ↑'),
                        ),
                        DropdownMenuItem(
                          value: '-severity',
                          child: Text('Severity ↓'),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() => _sortValue = v ?? '');
                        _load();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Outcome and severity row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _outcomeFilter,
                        decoration: const InputDecoration(
                          labelText: 'Outcome',
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(
                            value: 'success',
                            child: Text('Success'),
                          ),
                          DropdownMenuItem(
                            value: 'failure',
                            child: Text('Failure'),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => _outcomeFilter = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _severityFilter,
                        decoration: const InputDecoration(
                          labelText: 'Severity',
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(value: 'INFO', child: Text('INFO')),
                          DropdownMenuItem(value: 'LOW', child: Text('LOW')),
                          DropdownMenuItem(
                            value: 'MEDIUM',
                            child: Text('MEDIUM'),
                          ),
                          DropdownMenuItem(value: 'HIGH', child: Text('HIGH')),
                          DropdownMenuItem(
                            value: 'CRITICAL',
                            child: Text('CRITICAL'),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => _severityFilter = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        child: TextField(
                          controller: _actionCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Action',
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        child: TextField(
                          controller: _resourceTypeCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Resource Type',
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        child: TextField(
                          controller: _actorTypeCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Actor Type',
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _dateRange != null
                              ? '${_dateRange!.start.month}/${_dateRange!.start.day} — ${_dateRange!.end.month}/${_dateRange!.end.day}'
                              : 'Date Range',
                        ),
                        onPressed: _pickDateRange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    onPressed: _isLoading ? null : () => _load(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Results
          Expanded(
            child: _isLoading && _logs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _load(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _logs.length + (_hasMore ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i == _logs.length) {
                          return Center(
                            child: TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _load(loadMore: true),
                              child: const Text('Load More'),
                            ),
                          );
                        }
                        final entry = _logs[i];
                        return Card(
                          child: ExpansionTile(
                            leading: Icon(
                              entry.outcome == 'success'
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: entry.outcome == 'success'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.error,
                            ),
                            title: Text(entry.action),
                            subtitle: Text(
                              '${entry.resourceType} • ${entry.actorType} • ${entry.occurredAt}',
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText('ID: ${entry.id}'),
                                    SelectableText('Tenant: ${entry.tenantId}'),
                                    SelectableText(
                                      'Actor: ${entry.actorType} / ${entry.actorId ?? "—"}',
                                    ),
                                    SelectableText(
                                      'Resource: ${entry.resourceType} / ${entry.resourceId ?? "—"}',
                                    ),
                                    SelectableText('Outcome: ${entry.outcome}'),
                                    SelectableText(
                                      'Severity: ${entry.severity}',
                                    ),
                                    SelectableText(
                                      'Trace ID: ${entry.traceId}',
                                    ),
                                    SelectableText('PII: ${entry.containsPii}'),
                                    SelectableText(
                                      'Occurred: ${entry.occurredAt}',
                                    ),
                                    SelectableText(
                                      'Created: ${entry.createdAt}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
