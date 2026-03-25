// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';
import 'package:hexatuneapp/src/core/rest/step/step_repository.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Dummy page for testing read-only step endpoints.
class DummyStepsPage extends StatefulWidget {
  const DummyStepsPage({super.key});

  @override
  State<DummyStepsPage> createState() => _DummyStepsPageState();
}

class _DummyStepsPageState extends State<DummyStepsPage> {
  final _searchCtrl = TextEditingController();
  final List<StepResponse> _steps = [];
  final List<String> _availableLabels = [];
  final Set<String> _selectedLabels = {};
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  String _locale = '';
  String _sortValue = '';

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLabels() async {
    try {
      final repo = getIt<StepRepository>();
      final labels = await repo.listLabels();
      if (mounted) {
        setState(
          () => _availableLabels
            ..clear()
            ..addAll(labels),
        );
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load step labels: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<StepRepository>();
      final resp = await repo.list(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
          query: _searchCtrl.text.trim().isEmpty
              ? null
              : _searchCtrl.text.trim(),
          labels: _selectedLabels.isEmpty ? null : _selectedLabels.join(','),
          sort: _sortValue.isEmpty ? null : _sortValue,
        ),
        locale: _locale.isEmpty ? null : _locale,
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _steps.clear();
          _steps.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        '✓ Steps loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load steps failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDetail(StepResponse step) async {
    final repo = getIt<StepRepository>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(step.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText('ID: ${step.id}'),
              SelectableText('Description: ${step.description}'),
              SelectableText('Labels: ${step.labels.join(", ")}'),
              SelectableText('Image: ${step.imageUploaded}'),
              SelectableText('Created: ${step.createdAt}'),
              SelectableText('Updated: ${step.updatedAt}'),
            ],
          ),
        ),
        actions: [
          if (step.imageUploaded)
            TextButton(
              onPressed: () async {
                try {
                  final resp = await repo.getImageUrl(step.id);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    _showImagePreview(resp.url);
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    _showMessage(e.toString(), isError: true);
                  }
                }
              },
              child: const Text('View Image'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String url) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Step Image'),
        content: Image.network(url, errorBuilder: (_, e, s) => Text('$e')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
        title: const Text('Steps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _load(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_availableLabels.isEmpty ? 56 : 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          decoration: InputDecoration(
                            hintText: 'Search steps…',
                            isDense: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () => _load(),
                            ),
                          ),
                          onSubmitted: (_) => _load(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _locale,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Default locale'),
                        ),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'tr', child: Text('Turkish')),
                        DropdownMenuItem(value: 'de', child: Text('German')),
                      ],
                      onChanged: (v) {
                        setState(() => _locale = v ?? '');
                        _load();
                      },
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _sortValue,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Default sort'),
                        ),
                        DropdownMenuItem(
                          value: 'name',
                          child: Text('Name (A→Z)'),
                        ),
                        DropdownMenuItem(
                          value: '-name',
                          child: Text('Name (Z→A)'),
                        ),
                        DropdownMenuItem(
                          value: '-created_at',
                          child: Text('Newest first'),
                        ),
                        DropdownMenuItem(
                          value: 'created_at',
                          child: Text('Oldest first'),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() => _sortValue = v ?? '');
                        _load();
                      },
                    ),
                  ],
                ),
                if (_availableLabels.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _availableLabels
                          .map(
                            (label) => Padding(
                              padding: const EdgeInsets.only(right: 6, top: 4),
                              child: FilterChip(
                                label: Text(label),
                                selected: _selectedLabels.contains(label),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedLabels.add(label);
                                    } else {
                                      _selectedLabels.remove(label);
                                    }
                                  });
                                  _load();
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading && _steps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _steps.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _steps.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final s = _steps[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_walk),
                      title: Text(s.name),
                      subtitle: Text(
                        s.labels.isEmpty ? 'No labels' : s.labels.join(', '),
                      ),
                      trailing: Text(
                        s.id.length >= 8 ? s.id.substring(0, 8) : s.id,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _showDetail(s),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
