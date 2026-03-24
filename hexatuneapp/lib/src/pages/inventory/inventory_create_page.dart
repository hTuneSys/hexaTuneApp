// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';

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
  final List<String> _labels = [];
  List<CategoryResponse> _categories = [];
  String? _selectedCategoryId;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.inventoryCategoryRequired,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
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
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.inventoryCreated),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Create inventory failed: $e',
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
              // Image placeholder area
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
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
              Text(l10n.inventoryCategory, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              InkWell(
                onTap: _isCategoriesLoading ? null : _showCategoryPicker,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
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
                    : Text(l10n.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
