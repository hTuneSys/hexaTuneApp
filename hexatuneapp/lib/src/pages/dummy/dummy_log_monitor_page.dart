// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Temporary debug page that displays all in-memory log entries captured
/// by [DebugLogBuffer] since app launch. Supports real-time streaming,
/// one-tap copy, and level-based filtering.
///
/// Will be removed after debugging is complete.
class DummyLogMonitorPage extends StatefulWidget {
  const DummyLogMonitorPage({super.key});

  @override
  State<DummyLogMonitorPage> createState() => _DummyLogMonitorPageState();
}

class _DummyLogMonitorPageState extends State<DummyLogMonitorPage> {
  late final StreamSubscription<DebugLogEntry> _subscription;
  final _scrollController = ScrollController();
  String? _levelFilter;
  String _searchQuery = '';
  bool _autoScroll = true;

  static const _levelColors = <String, Color>{
    'VERBOSE': Colors.grey,
    'DEBUG': Colors.blue,
    'INFO': Colors.green,
    'WARN': Colors.orange,
    'ERROR': Colors.red,
    'CRITICAL': Colors.purple,
    'HTTP-REQ': Colors.teal,
    'HTTP-RES': Colors.cyan,
    'HTTP-ERR': Colors.redAccent,
  };

  @override
  void initState() {
    super.initState();
    _subscription = DebugLogBuffer.instance.stream.listen((_) {
      if (mounted) {
        setState(() {});
        if (_autoScroll) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  List<DebugLogEntry> get _filteredEntries {
    var entries = DebugLogBuffer.instance.entries;
    if (_levelFilter != null) {
      entries = entries.where((e) => e.level == _levelFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      entries = entries
          .where(
            (e) =>
                e.message.toLowerCase().contains(query) ||
                e.level.toLowerCase().contains(query),
          )
          .toList();
    }
    return entries;
  }

  Future<void> _copyAll() async {
    final entries = _filteredEntries;
    if (entries.isEmpty) {
      _showSnackBar('No log entries to copy');
      return;
    }
    final text = entries.map((e) => e.formatted).join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      _showSnackBar('Copied ${entries.length} log entries to clipboard');
    }
  }

  void _clearLogs() {
    DebugLogBuffer.instance.clear();
    setState(() {});
    _showSnackBar('Logs cleared');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    AppSnackBar.success(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = _filteredEntries;
    final totalCount = DebugLogBuffer.instance.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.settings),
        ),
        title: Text('Log Monitor ($totalCount)'),
        actions: [
          IconButton(
            icon: Icon(_autoScroll ? Icons.vertical_align_bottom : Icons.pause),
            tooltip: _autoScroll ? 'Auto-scroll ON' : 'Auto-scroll OFF',
            onPressed: () => setState(() => _autoScroll = !_autoScroll),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy all',
            onPressed: _copyAll,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
            onPressed: _clearLogs,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(theme),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      _levelFilter != null || _searchQuery.isNotEmpty
                          ? 'No matching entries'
                          : 'No log entries yet',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      4,
                      8,
                      4 + AppBottomBar.scrollPadding,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) =>
                        _buildLogEntry(entries[index], theme),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    final levels = <String>[
      'DEBUG',
      'INFO',
      'WARN',
      'ERROR',
      'CRITICAL',
      'HTTP-REQ',
      'HTTP-RES',
      'HTTP-ERR',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceContainerLow,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search logs...',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String?>(
            value: _levelFilter,
            hint: const Text('All'),
            isDense: true,
            items: [
              const DropdownMenuItem(child: Text('All')),
              ...levels.map((l) => DropdownMenuItem(value: l, child: Text(l))),
            ],
            onChanged: (value) => setState(() => _levelFilter = value),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(DebugLogEntry entry, ThemeData theme) {
    final color = _levelColors[entry.level] ?? theme.colorScheme.onSurface;
    final ts = entry.timestamp.toIso8601String().substring(11, 23);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SelectableText.rich(
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            fontSize: 11,
          ),
          children: [
            TextSpan(
              text: '$ts ',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
            TextSpan(
              text: '[${entry.level}] ',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: entry.message),
          ],
        ),
      ),
    );
  }
}
