// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Dummy page for testing formula CRUD endpoints.
class DummyFormulasPage extends StatefulWidget {
  const DummyFormulasPage({super.key});

  @override
  State<DummyFormulasPage> createState() => _DummyFormulasPageState();
}

class _DummyFormulasPageState extends State<DummyFormulasPage> {
  final _searchCtrl = TextEditingController();
  final List<FormulaResponse> _formulas = [];
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
      final repo = getIt<FormulaRepository>();
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
          if (!loadMore) _formulas.clear();
          _formulas.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      if (Env.isDev) {
        log.devLog(
          '✓ Formulas loaded: ${resp.data.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Load formulas failed: $e', category: LogCategory.ui);
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
        title: const Text('Create Formula'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name *',
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
      final repo = getIt<FormulaRepository>();
      final labels = labelsCtrl.text.trim().isEmpty
          ? <String>[]
          : labelsCtrl.text.split(',').map((e) => e.trim()).toList();
      await repo.create(
        CreateFormulaRequest(
          name: nameCtrl.text.trim(),
          labels: labels.isEmpty ? null : labels,
        ),
      );
      if (mounted) {
        _showMessage('Formula created');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDetail(FormulaResponse formula) async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<FormulaRepository>();
      final detail = await repo.getById(formula.id);
      if (!mounted) return;
      setState(() => _isLoading = false);

      await showDialog<void>(
        context: context,
        builder: (ctx) {
          final nameCtrl = TextEditingController(text: detail.name);
          final labelsCtrl = TextEditingController(
            text: detail.labels.join(', '),
          );
          return AlertDialog(
            title: Text(detail.name),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('ID: ${detail.id}'),
                  SelectableText('Labels: ${detail.labels.join(", ")}'),
                  SelectableText('Items: ${detail.items.length}'),
                  SelectableText('Created: ${detail.createdAt}'),
                  SelectableText('Updated: ${detail.updatedAt}'),
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
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/dev/formulas/${detail.id}/items');
                },
                child: const Text('Manage Items'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _delete(detail.id);
                },
                child: const Text('Delete'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _update(detail.id, nameCtrl.text, labelsCtrl.text);
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
      final repo = getIt<FormulaRepository>();
      final labels = labelsStr.trim().isEmpty
          ? <String>[]
          : labelsStr.split(',').map((e) => e.trim()).toList();
      await repo.update(
        id,
        UpdateFormulaRequest(
          name: name.trim().isEmpty ? null : name.trim(),
          labels: labels.isEmpty ? null : labels,
        ),
      );
      if (mounted) {
        _showMessage('Formula updated');
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
      final repo = getIt<FormulaRepository>();
      await repo.delete(id);
      if (mounted) {
        _showMessage('Formula deleted');
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
        title: const Text('Formulas'),
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
                hintText: 'Search formulas…',
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
      body: _isLoading && _formulas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _formulas.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _formulas.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final f = _formulas[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.science),
                      title: Text(f.name),
                      subtitle: Text(
                        f.labels.isEmpty ? 'No labels' : f.labels.join(', '),
                      ),
                      trailing: Text(
                        f.id.substring(0, 8),
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
