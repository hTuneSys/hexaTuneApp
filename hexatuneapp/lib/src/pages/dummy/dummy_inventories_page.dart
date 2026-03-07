// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/category/category_repository.dart';
import 'package:hexatuneapp/src/core/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Dummy page for testing inventory CRUD endpoints.
class DummyInventoriesPage extends StatefulWidget {
  const DummyInventoriesPage({super.key});

  @override
  State<DummyInventoriesPage> createState() => _DummyInventoriesPageState();
}

class _DummyInventoriesPageState extends State<DummyInventoriesPage> {
  final _searchCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<InventoryResponse> _items = [];
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
      final repo = getIt<InventoryRepository>();
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
          if (!loadMore) _items.clear();
          _items.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      if (Env.isDev) {
        log.devLog(
          '✓ Inventories loaded: ${resp.data.length}',
          category: LogCategory.ui,
        );
      }
    } catch (e) {
      if (Env.isDev) {
        log.devLog('✗ Load inventories failed: $e', category: LogCategory.ui);
      }
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    return _picker.pickImage(source: source);
  }

  Future<List<CategoryResponse>> _fetchCategories() async {
    final catRepo = getIt<CategoryRepository>();
    final resp = await catRepo.list(params: const PaginationParams(limit: 100));
    return resp.data;
  }

  Future<void> _showCreateDialog() async {
    List<CategoryResponse> categories = [];
    try {
      categories = await _fetchCategories();
    } catch (e) {
      if (mounted) _showMessage('Failed to load categories: $e', isError: true);
      return;
    }
    if (!mounted) return;

    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final labelsCtrl = TextEditingController();
    XFile? pickedImage;
    String? selectedCategoryId;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Inventory'),
          content: SingleChildScrollView(
            child: Column(
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
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() => selectedCategoryId = val);
                  },
                  hint: const Text('Select a category'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: labelsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Labels (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () async {
                        final f = await _pickImage(ImageSource.camera);
                        if (f != null) {
                          setDialogState(() => pickedImage = f);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo),
                      label: const Text('Gallery'),
                      onPressed: () async {
                        final f = await _pickImage(ImageSource.gallery);
                        if (f != null) {
                          setDialogState(() => pickedImage = f);
                        }
                      },
                    ),
                  ],
                ),
                if (pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Image: ${pickedImage!.name}'),
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
      ),
    );
    if (result != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<InventoryRepository>();
      final labels = labelsCtrl.text.trim().isEmpty
          ? <String>[]
          : labelsCtrl.text.split(',').map((e) => e.trim()).toList();
      await repo.create(
        categoryId: selectedCategoryId ?? '',
        name: nameCtrl.text.trim(),
        description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
        labels: labels.isEmpty ? null : labels,
        imageFile: pickedImage != null ? XFile(pickedImage!.path) : null,
      );
      if (mounted) {
        _showMessage('Inventory created');
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
      final repo = getIt<InventoryRepository>();
      final item = await repo.getById(id);
      if (!mounted) return;
      setState(() => _isLoading = false);

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(item.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText('ID: ${item.id}'),
                SelectableText('Category: ${item.categoryId}'),
                SelectableText('Description: ${item.description ?? "—"}'),
                SelectableText('Labels: ${item.labels.join(", ")}'),
                SelectableText('Image: ${item.imageUploaded}'),
                SelectableText('Created: ${item.createdAt}'),
                SelectableText('Updated: ${item.updatedAt}'),
              ],
            ),
          ),
          actions: [
            if (item.imageUploaded)
              TextButton(
                onPressed: () async {
                  try {
                    final resp = await repo.getImageUrl(id);
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
              onPressed: () async {
                Navigator.pop(ctx);
                await _delete(id);
              },
              child: const Text('Delete'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showEditDialog(item);
              },
              child: const Text('Edit'),
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
        title: const Text('Inventory Image'),
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

  Future<void> _showEditDialog(InventoryResponse item) async {
    List<CategoryResponse> categories = [];
    try {
      categories = await _fetchCategories();
    } catch (e) {
      if (mounted) _showMessage('Failed to load categories: $e', isError: true);
      return;
    }
    if (!mounted) return;

    final nameCtrl = TextEditingController(text: item.name);
    final descCtrl = TextEditingController(text: item.description ?? '');
    final labelsCtrl = TextEditingController(text: item.labels.join(', '));
    XFile? pickedImage;
    String? selectedCategoryId = categories.any((c) => c.id == item.categoryId)
        ? item.categoryId
        : null;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Inventory'),
          content: SingleChildScrollView(
            child: Column(
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
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() => selectedCategoryId = val);
                  },
                  hint: const Text('Select a category'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: labelsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Labels (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () async {
                        final f = await _pickImage(ImageSource.camera);
                        if (f != null) {
                          setDialogState(() => pickedImage = f);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo),
                      label: const Text('Gallery'),
                      onPressed: () async {
                        final f = await _pickImage(ImageSource.gallery);
                        if (f != null) {
                          setDialogState(() => pickedImage = f);
                        }
                      },
                    ),
                  ],
                ),
                if (pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('New image: ${pickedImage!.name}'),
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
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
    if (result != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<InventoryRepository>();
      final labels = labelsCtrl.text.trim().isEmpty
          ? <String>[]
          : labelsCtrl.text.split(',').map((e) => e.trim()).toList();
      await repo.update(
        item.id,
        categoryId: selectedCategoryId,
        name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
        description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
        labels: labels.isEmpty ? null : labels,
        imageFile: pickedImage != null ? XFile(pickedImage!.path) : null,
      );
      if (mounted) {
        _showMessage('Inventory updated');
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
      final repo = getIt<InventoryRepository>();
      await repo.delete(id);
      if (mounted) {
        _showMessage('Inventory deleted');
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
        title: const Text('Inventories'),
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
                hintText: 'Search inventories…',
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
      body: _isLoading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length + (_hasMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == _items.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => _load(loadMore: true),
                        child: const Text('Load More'),
                      ),
                    );
                  }
                  final item = _items[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        item.imageUploaded ? Icons.image : Icons.inventory_2,
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.description ?? "No description"}\n'
                        'Labels: ${item.labels.isEmpty ? "—" : item.labels.join(", ")}',
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        item.id.substring(0, 8),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _showDetail(item.id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
