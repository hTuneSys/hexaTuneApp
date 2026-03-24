// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/media/image_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

/// Page for editing an existing inventory item.
class InventoryEditPage extends StatefulWidget {
  const InventoryEditPage({required this.inventoryId, super.key});

  final String inventoryId;

  @override
  State<InventoryEditPage> createState() => _InventoryEditPageState();
}

class _InventoryEditPageState extends State<InventoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _labelInputCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<String> _labels = [];
  List<CategoryResponse> _categories = [];
  String? _selectedCategoryId;
  ({String name, Uint8List bytes})? _pickedImage;
  String? _imageUrl;
  bool _isLoading = true;
  bool _isSubmitting = false;
  InventoryResponse? _inventory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _labelInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final invRepo = getIt<InventoryRepository>();
      final catRepo = getIt<CategoryRepository>();
      final results = await Future.wait([
        invRepo.getById(widget.inventoryId),
        catRepo.list(params: const PaginationParams(limit: 100)),
      ]);
      final inv = results[0] as InventoryResponse;
      final catResp = results[1];
      String? imgUrl;
      if (inv.imageUploaded) {
        try {
          final imgResp = await invRepo.getImageUrl(widget.inventoryId);
          imgUrl = imgResp.url;
        } catch (_) {
          // Image URL fetch failed — show placeholder
        }
      }
      if (mounted) {
        setState(() {
          _inventory = inv;
          _nameCtrl.text = inv.name;
          _descCtrl.text = inv.description ?? '';
          _labels
            ..clear()
            ..addAll(inv.labels);
          _categories = (catResp as dynamic).data as List<CategoryResponse>;
          _selectedCategoryId = _categories.any((c) => c.id == inv.categoryId)
              ? inv.categoryId
              : null;
          _imageUrl = imgUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load inventory: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _addLabel() {
    final label = _labelInputCtrl.text.trim();
    if (label.isNotEmpty && !_labels.contains(label)) {
      setState(() => _labels.add(label));
      _labelInputCtrl.clear();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final xFile = await _picker.pickImage(source: source);
      if (xFile == null) return;
      final imageService = getIt<ImageService>();
      final bytes = await imageService.processFile(File(xFile.path));
      if (bytes != null && mounted) {
        setState(() => _pickedImage = (name: xFile.name, bytes: bytes));
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Image pick failed: $e',
        category: LogCategory.ui,
      );
    }
  }

  void _showImageSourceDialog() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.inventoryAddImage,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.inventoryImageCamera),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.inventoryImageGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeLabel(String label) {
    setState(() => _labels.remove(label));
  }

  Future<void> _showCategoryPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final addNewCtrl = TextEditingController();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final sheetTheme = Theme.of(ctx);
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.inventoryCategory,
                    style: sheetTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: addNewCtrl,
                          decoration: InputDecoration(
                            hintText: l10n.inventoryCategoryAddNew,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) async {
                            final name = addNewCtrl.text.trim();
                            if (name.isEmpty) return;
                            await _createCategoryInline(
                              name,
                              ctx,
                              setSheetState,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final name = addNewCtrl.text.trim();
                          if (name.isEmpty) return;
                          await _createCategoryInline(name, ctx, setSheetState);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      itemBuilder: (ctx, i) {
                        final cat = _categories[i];
                        final selected = cat.id == _selectedCategoryId;
                        return ListTile(
                          title: Text(cat.name),
                          selected: selected,
                          selectedTileColor:
                              sheetTheme.colorScheme.primaryContainer,
                          onTap: () => Navigator.pop(ctx, cat.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (result != null && mounted) {
      setState(() => _selectedCategoryId = result);
    }
  }

  Future<void> _createCategoryInline(
    String name,
    BuildContext sheetContext,
    StateSetter setSheetState,
  ) async {
    try {
      final catRepo = getIt<CategoryRepository>();
      final newCat = await catRepo.create(CreateCategoryRequest(name: name));
      if (mounted) {
        setState(() => _categories = [..._categories, newCat]);
        setSheetState(() {});
        if (sheetContext.mounted) Navigator.pop(sheetContext, newCat.id);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to create category inline: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await getIt<InventoryRepository>().update(
        widget.inventoryId,
        categoryId: _selectedCategoryId,
        name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        labels: _labels.isEmpty ? null : _labels,
        imageBytes: _pickedImage?.bytes,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.inventoryUpdated),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Update inventory failed: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _inventory?.name ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.inventoryDeleteConfirm(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    try {
      await getIt<InventoryRepository>().delete(widget.inventoryId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.inventoryDeleted),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _selectedCategoryName() {
    if (_selectedCategoryId == null) return null;
    final match = _categories.where((c) => c.id == _selectedCategoryId);
    return match.isEmpty ? null : match.first.name;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryEdit)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image area
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _pickedImage != null
                            ? Stack(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        _pickedImage!.bytes,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 8,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _imageUrl != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _imageUrl!,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, error, stack) => Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 64,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 8,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 48,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.inventoryAddImage,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.inventoryName, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.inventoryNameHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.inventoryNameRequired
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.inventoryDescription,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.inventoryDescriptionHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.inventoryCategory,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showCategoryPicker,
                      borderRadius: BorderRadius.circular(4),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedCategoryName() ??
                                    l10n.inventoryCategoryHint,
                                style: _selectedCategoryId != null
                                    ? theme.textTheme.bodyLarge
                                    : theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.outline,
                                      ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.inventoryLabels,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _labelInputCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.inventoryAddLabel,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addLabel,
                        ),
                      ),
                      onSubmitted: (_) => _addLabel(),
                    ),
                    if (_labels.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _labels
                            .map(
                              (label) => Chip(
                                label: Text(label),
                                onDeleted: () => _removeLabel(label),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _delete,
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: Text(l10n.delete),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _save,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : Text(l10n.save),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
