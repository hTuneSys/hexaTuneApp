// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Dummy page for testing category CRUD endpoints.
class DummyCategoriesPage extends StatefulWidget {
  const DummyCategoriesPage({super.key});

  @override
  State<DummyCategoriesPage> createState() => _DummyCategoriesPageState();
}

class _DummyCategoriesPageState extends State<DummyCategoriesPage> {
  final _searchCtrl = TextEditingController();
  final List<CategoryResponse> _categories = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<CategoryRepository>();
      final resp = await repo.list(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
          query: _searchCtrl.text.trim().isEmpty
              ? null
              : _searchCtrl.text.trim(),
        ),
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _categories.clear();
          _categories.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      if (Env.isDev) {
        log.devLog(
          '✓ Categories loaded: ${resp.data.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Load categories failed: $e', category: LogCategory.ui);
      }
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showCreateDialog() async {
    final nameCtrl = TextEditingController();
    final labelsCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: labelsCtrl,
              decoration: const InputDecoration(
                labelText: 'Labels (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
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
      final repo = getIt<CategoryRepository>();
      final labels = labelsCtrl.text.trim().isEmpty
          ? <String>[]
          : labelsCtrl.text.split(',').map((e) => e.trim()).toList();
      await repo.create(
        CreateCategoryRequest(
          name: nameCtrl.text.trim(),
          labels: labels.isEmpty ? null : labels,
        ),
      );
      if (mounted) {
        _showMessage('Category created');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDetail(String id) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<CategoryRepository>();
      final cat = await repo.getById(id);
      if (!mounted) return;
      setState(() => _isLoading = false);

      await showDialog<void>(
        context: context,
        builder: (ctx) {
          final nameCtrl = TextEditingController(text: cat.name);
          final labelsCtrl = TextEditingController(text: cat.labels.join(', '));
          return AlertDialog(
            title: Text(cat.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText('ID: ${cat.id}'),
                SelectableText('Labels: ${cat.labels.join(", ")}'),
                SelectableText('Created: ${cat.createdAt}'),
                SelectableText('Updated: ${cat.updatedAt}'),
                const Divider(),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: labelsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Labels (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _delete(id);
                },
                child: const Text('Delete'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _update(id, nameCtrl.text, labelsCtrl.text);
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(e.toString(), isError: true);
      }
    }
  }

  Future<void> _update(String id, String name, String labelsStr) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<CategoryRepository>();
      final labels = labelsStr.trim().isEmpty
          ? <String>[]
          : labelsStr.split(',').map((e) => e.trim()).toList();
      await repo.update(
        id,
        UpdateCategoryRequest(
          name: name.trim().isEmpty ? null : name.trim(),
          labels: labels.isEmpty ? null : labels,
        ),
      );
      if (mounted) {
        _showMessage('Category updated');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete(String id) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<CategoryRepository>();
      await repo.delete(id);
      if (mounted) {
        _showMessage('Category deleted');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _load(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search categories…',
                border: const OutlineInputBorder(),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading && _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _categories.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _categories.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final c = _categories[i];
                  return Card(
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Text(
                        c.labels.isEmpty ? 'No labels' : c.labels.join(', '),
                      ),
                      trailing: Text(
                        c.id.substring(0, 8),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _showDetail(c.id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
