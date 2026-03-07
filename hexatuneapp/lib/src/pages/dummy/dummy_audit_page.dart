// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/audit/audit_repository.dart';
import 'package:hexatuneapp/src/core/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/audit/models/audit_log_query_params.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

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
  final List<AuditLogDto> _logs = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _actionCtrl.dispose();
    _resourceTypeCtrl.dispose();
    _actorTypeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<AuditRepository>();
      final resp = await repo.queryLogs(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
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
      if (Env.isDev) {
        log.devLog(
          '✓ Audit logs loaded: ${resp.data.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Load audit logs failed: $e', category: LogCategory.ui);
      }
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
      _dateRange = null;
    });
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _actionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Action',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _resourceTypeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Resource Type',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _actorTypeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Actor Type',
                          border: OutlineInputBorder(),
                          isDense: true,
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
