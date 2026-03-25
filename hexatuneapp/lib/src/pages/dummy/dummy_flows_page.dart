// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/flow/flow_repository.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart';

/// Dummy page for testing read-only flow endpoints.
class DummyFlowsPage extends StatefulWidget {
  const DummyFlowsPage({super.key});

  @override
  State<DummyFlowsPage> createState() => _DummyFlowsPageState();
}

class _DummyFlowsPageState extends State<DummyFlowsPage> {
  final _searchCtrl = TextEditingController();
  final List<FlowResponse> _flows = [];
  final List<String> _availableLabels = [];
  final Set<String> _selectedLabels = {};
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  final _packageRepo = getIt<PackageRepository>();
  final List<PackageResponse> _packages = [];
  String? _selectedPackageId;
  String _locale = '';
  String _sortValue = '';

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _loadPackages();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLabels() async {
    try {
      final repo = getIt<FlowRepository>();
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
        'Failed to load flow labels: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _loadPackages() async {
    try {
      final resp = await _packageRepo.list();
      if (mounted) {
        setState(
          () => _packages
            ..clear()
            ..addAll(resp.data),
        );
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load packages: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<FlowRepository>();
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
        packageId: _selectedPackageId,
        locale: _locale.isEmpty ? null : _locale,
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _flows.clear();
          _flows.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        '✓ Flows loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load flows failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDetail(FlowResponse flow) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<FlowRepository>();
      final detail = await repo.getById(flow.id);
      if (!mounted) return;
      setState(() => _isLoading = false);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(detail.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText('ID: ${detail.id}'),
                SelectableText('Description: ${detail.description}'),
                SelectableText('Labels: ${detail.labels.join(", ")}'),
                SelectableText('Image: ${detail.imageUploaded}'),
                SelectableText('Steps: ${detail.steps.length}'),
                SelectableText('Created: ${detail.createdAt}'),
                SelectableText('Updated: ${detail.updatedAt}'),
                if (detail.steps.isNotEmpty) ...[
                  const Divider(),
                  Text('Flow Steps', style: Theme.of(ctx).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  ...detail.steps.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SelectableText(
                        '#${s.sortOrder} — step: ${s.stepId.length >= 8 ? s.stepId.substring(0, 8) : s.stepId}… '
                        '×${s.quantity} ${s.timeMs}ms',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (detail.imageUploaded)
              TextButton(
                onPressed: () async {
                  try {
                    final resp = await repo.getImageUrl(detail.id);
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(e.toString(), isError: true);
      }
    }
  }

  void _showImagePreview(String url) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Flow Image'),
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
        title: const Text('Flows'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _load(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_availableLabels.isEmpty ? 104 : 148),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search flows…',
                      isDense: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _load(),
                      ),
                    ),
                    onSubmitted: (_) => _load(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String?>(
                        value: _selectedPackageId,
                        isExpanded: true,
                        isDense: true,
                        hint: const Text('All packages'),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All packages'),
                          ),
                          ..._packages.map(
                            (p) => DropdownMenuItem<String?>(
                              value: p.id,
                              child: Text(p.name),
                            ),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedPackageId = v);
                          _load();
                        },
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
                          child: Text('Name (A\u2192Z)'),
                        ),
                        DropdownMenuItem(
                          value: '-name',
                          child: Text('Name (Z\u2192A)'),
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
      body: _isLoading && _flows.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _flows.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _flows.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final f = _flows[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.account_tree),
                      title: Text(f.name),
                      subtitle: Text(
                        f.labels.isEmpty ? 'No labels' : f.labels.join(', '),
                      ),
                      trailing: Text(
                        f.id.length >= 8 ? f.id.substring(0, 8) : f.id,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _showDetail(f),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
