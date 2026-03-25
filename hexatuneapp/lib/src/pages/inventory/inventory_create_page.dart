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
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Page for creating a new inventory item.
class InventoryCreatePage extends StatefulWidget {
  const InventoryCreatePage({super.key});

  @override
  State<InventoryCreatePage> createState() => _InventoryCreatePageState();
}

class _InventoryCreatePageState extends State<InventoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _labelInputCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<String> _labels = [];
  List<CategoryResponse> _categories = [];
  String? _selectedCategoryId;
  ({String name, Uint8List bytes})? _pickedImage;
  bool _isSubmitting = false;
  bool _isCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _labelInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final catRepo = getIt<CategoryRepository>();
      final resp = await catRepo.list(
        params: const PaginationParams(limit: 100),
      );
      if (mounted) {
        setState(() {
          _categories = resp.data;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load categories: $e',
        category: LogCategory.ui,
      );
      if (mounted) setState(() => _isCategoriesLoading = false);
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
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(ctx).colorScheme.surfaceContainerLow,
                          child: TextField(
                            controller: addNewCtrl,
                            decoration: InputDecoration(
                              hintText: l10n.inventoryCategoryAddNew,
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
        AppSnackBar.error(context, message: e.toString());
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      AppSnackBar.error(
        context,
        message: AppLocalizations.of(context)!.inventoryCategoryRequired,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await getIt<InventoryRepository>().create(
        categoryId: _selectedCategoryId!,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        labels: _labels.isEmpty ? null : _labels,
        imageBytes: _pickedImage?.bytes,
      );
      if (mounted) {
        AppSnackBar.success(context, message: l10n.inventoryCreated);
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Create inventory failed: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        AppSnackBar.error(context, message: e.toString());
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
      appBar: AppBar(title: Text(l10n.inventoryCreate)),
      body: SingleChildScrollView(
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
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerLow,
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(hintText: l10n.inventoryNameHint),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.inventoryNameRequired
                      : null,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.inventoryDescription,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerLow,
                child: TextFormField(
                  controller: _descCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.inventoryDescriptionHint,
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.inventoryCategory, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              InkWell(
                onTap: _isCategoriesLoading ? null : _showCategoryPicker,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedCategoryName() ?? l10n.inventoryCategoryHint,
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
              Text(l10n.inventoryLabels, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerLow,
                child: TextField(
                  controller: _labelInputCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.inventoryAddLabel,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addLabel,
                    ),
                  ),
                  onSubmitted: (_) => _addLabel(),
                ),
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
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  elevation: 1,
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
                    : Text(l10n.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
