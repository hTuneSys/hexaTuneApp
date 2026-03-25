// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Dummy page for testing read-only package endpoints.
class DummyPackagesPage extends StatefulWidget {
  const DummyPackagesPage({super.key});

  @override
  State<DummyPackagesPage> createState() => _DummyPackagesPageState();
}

class _DummyPackagesPageState extends State<DummyPackagesPage> {
  final _searchCtrl = TextEditingController();
  final List<PackageResponse> _packages = [];
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
      final repo = getIt<PackageRepository>();
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
        'Failed to load package labels: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<PackageRepository>();
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
          if (!loadMore) _packages.clear();
          _packages.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        '✓ Packages loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load packages failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDetail(PackageResponse pkg) async {
    final repo = getIt<PackageRepository>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pkg.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText('ID: ${pkg.id}'),
              SelectableText('Description: ${pkg.description}'),
              SelectableText('Labels: ${pkg.labels.join(", ")}'),
              SelectableText('Image: ${pkg.imageUploaded}'),
              SelectableText('Created: ${pkg.createdAt}'),
              SelectableText('Updated: ${pkg.updatedAt}'),
            ],
          ),
        ),
        actions: [
          if (pkg.imageUploaded)
            TextButton(
              onPressed: () async {
                try {
                  final resp = await repo.getImageUrl(pkg.id);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    _showImagePreview(resp.url);
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    if (mounted) ApiErrorHandler.handle(context, e);
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
        title: const Text('Package Image'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packages'),
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
                            hintText: 'Search packages…',
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
      body: _isLoading && _packages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  8 + AppBottomBar.scrollPadding,
                ),
                itemCount: _packages.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _packages.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final p = _packages[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.inventory_2),
                      title: Text(p.name),
                      subtitle: Text(
                        p.labels.isEmpty ? 'No labels' : p.labels.join(', '),
                      ),
                      trailing: Text(
                        p.id.length >= 8 ? p.id.substring(0, 8) : p.id,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _showDetail(p),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
