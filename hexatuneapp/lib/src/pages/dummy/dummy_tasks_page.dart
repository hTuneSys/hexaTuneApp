// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_summary_dto.dart';
import 'package:hexatuneapp/src/core/rest/task/task_repository.dart';

/// Dummy page for testing task workflow endpoints.
class DummyTasksPage extends StatefulWidget {
  const DummyTasksPage({super.key});

  @override
  State<DummyTasksPage> createState() => _DummyTasksPageState();
}

class _DummyTasksPageState extends State<DummyTasksPage> {
  final List<TaskSummaryDto> _tasks = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  String? _statusFilter;
  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<TaskRepository>();
      final resp = await repo.list(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
        ),
        status: _statusFilter,
        taskType: _typeFilter,
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _tasks.clear();
          _tasks.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      if (Env.isDev) {
        log.devLog(
          '✓ Tasks loaded: ${resp.data.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Load tasks failed: $e', category: LogCategory.ui);
      }
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showCreateDialog() async {
    final typeCtrl = TextEditingController();
    final payloadCtrl = TextEditingController(text: '{}');
    final cronCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Task Type *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: payloadCtrl,
                decoration: const InputDecoration(
                  labelText: 'Payload (JSON) *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cronCtrl,
                decoration: const InputDecoration(
                  labelText: 'Cron Expression (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (result != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<TaskRepository>();
      final payload =
          json.decode(payloadCtrl.text.trim()) as Map<String, dynamic>;
      final resp = await repo.create(
        CreateTaskRequest(
          taskType: typeCtrl.text.trim(),
          payload: payload,
          cronExpression: cronCtrl.text.trim().isEmpty
              ? null
              : cronCtrl.text.trim(),
        ),
      );
      if (mounted) {
        _showMessage('Task created: ${resp.taskId}');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showTaskStatus(String taskId) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<TaskRepository>();
      final status = await repo.getStatus(taskId);
      if (!mounted) return;
      setState(() => _isLoading = false);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Task ${status.taskId.substring(0, 8)}…'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText('ID: ${status.taskId}'),
                SelectableText('Type: ${status.taskType}'),
                SelectableText('Status: ${status.status}'),
                SelectableText('Scheduled: ${status.scheduledAt}'),
                SelectableText(
                  'Retries: ${status.retryCount}/${status.maxRetries}',
                ),
                if (status.startedAt != null)
                  SelectableText('Started: ${status.startedAt}'),
                if (status.completedAt != null)
                  SelectableText('Completed: ${status.completedAt}'),
                if (status.failedAt != null)
                  SelectableText('Failed: ${status.failedAt}'),
                if (status.cancelledAt != null)
                  SelectableText('Cancelled: ${status.cancelledAt}'),
                if (status.errorMessage != null)
                  SelectableText('Error: ${status.errorMessage}'),
                if (status.progressPercentage != null)
                  SelectableText('Progress: ${status.progressPercentage}%'),
                if (status.progressStatus != null)
                  SelectableText('Progress Status: ${status.progressStatus}'),
                const Divider(),
                SelectableText(
                  'Payload: ${const JsonEncoder.withIndent("  ").convert(status.payload)}',
                ),
                if (status.result != null)
                  SelectableText(
                    'Result: ${const JsonEncoder.withIndent("  ").convert(status.result)}',
                  ),
              ],
            ),
          ),
          actions: [
            if (status.status == 'pending' || status.status == 'running')
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _cancelTask(taskId);
                },
                child: const Text('Cancel'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(e.toString(), isError: true);
      }
    }
  }

  Future<void> _cancelTask(String taskId) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Task'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Task'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<TaskRepository>();
      await repo.cancel(
        taskId,
        CancelTaskRequest(
          reason: reasonCtrl.text.trim().isEmpty
              ? null
              : reasonCtrl.text.trim(),
        ),
      );
      if (mounted) {
        _showMessage('Task cancelled');
        _load();
      }
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

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'pending':
        return colorScheme.tertiary;
      case 'running':
        return colorScheme.primary;
      case 'completed':
        return colorScheme.secondary;
      case 'failed':
        return colorScheme.error;
      case 'cancelled':
        return colorScheme.outline;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _load(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                for (final s in [
                  null,
                  'pending',
                  'running',
                  'completed',
                  'failed',
                  'cancelled',
                ])
                  ChoiceChip(
                    label: Text(s ?? 'All'),
                    selected: _statusFilter == s,
                    onSelected: (_) {
                      setState(() => _statusFilter = s);
                      _load();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading && _tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _load(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _tasks.length + (_hasMore ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i == _tasks.length) {
                          return Center(
                            child: TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _load(loadMore: true),
                              child: const Text('Load More'),
                            ),
                          );
                        }
                        final t = _tasks[i];
                        final colorScheme = Theme.of(context).colorScheme;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _statusColor(
                                t.status,
                                colorScheme,
                              ),
                              child: Icon(
                                Icons.task,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            title: Text(t.taskType),
                            subtitle: Text(
                              'Status: ${t.status}\n'
                              'Retries: ${t.retryCount}/${t.maxRetries}\n'
                              'Scheduled: ${t.scheduledAt}',
                            ),
                            isThreeLine: true,
                            onTap: () => _showTaskStatus(t.taskId),
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
