// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Page for editing an existing category.
class CategoryEditPage extends StatefulWidget {
  const CategoryEditPage({required this.categoryId, super.key});

  final String categoryId;

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _labelInputCtrl = TextEditingController();
  final List<String> _labels = [];
  final _labelFocusNode = FocusNode();
  List<String> _availableLabels = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  CategoryResponse? _category;

  @override
  void initState() {
    super.initState();
    _loadCategory();
    _loadLabels();
  }

  @override
  void dispose() {
    _labelFocusNode.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _labelInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLabels() async {
    try {
      final labels = await getIt<CategoryRepository>().listLabels();
      if (mounted) setState(() => _availableLabels = labels);
    } catch (_) {}
  }

  Future<void> _loadCategory() async {
    try {
      final cat = await getIt<CategoryRepository>().getById(widget.categoryId);
      if (mounted) {
        setState(() {
          _category = cat;
          _nameCtrl.text = cat.name;
          _labels
            ..clear()
            ..addAll(cat.labels);
          _isLoading = false;
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load category: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ApiErrorHandler.handle(context, e);
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

  void _removeLabel(String label) {
    setState(() => _labels.remove(label));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await getIt<CategoryRepository>().update(
        widget.categoryId,
        UpdateCategoryRequest(
          name: _nameCtrl.text.trim(),
          labels: _labels.isEmpty ? null : _labels,
        ),
      );
      if (mounted) {
        AppSnackBar.success(context, message: l10n.categoryUpdated);
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Update category failed: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ApiErrorHandler.handle(context, e);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _category?.name ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.categoryDeleteConfirm(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              elevation: 1,
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
      await getIt<CategoryRepository>().delete(widget.categoryId);
      if (mounted) {
        AppSnackBar.success(context, message: l10n.categoryDeleted);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ApiErrorHandler.handle(context, e);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoryEdit)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + AppBottomBar.scrollPadding,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.categoryName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.categoryNameHint,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.categoryName
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.categoryDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.categoryDescriptionHint,
                        ),
                        maxLines: 3,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.categoryLabels,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RawAutocomplete<String>(
                      textEditingController: _labelInputCtrl,
                      focusNode: _labelFocusNode,
                      optionsBuilder: (textEditingValue) {
                        final filtered = _availableLabels
                            .where((l) => !_labels.contains(l))
                            .where(
                              (l) =>
                                  textEditingValue.text.isEmpty ||
                                  l.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            )
                            .toList();
                        return filtered;
                      },
                      onSelected: (String selection) {
                        if (!_labels.contains(selection)) {
                          setState(() => _labels.add(selection));
                        }
                        _labelInputCtrl.clear();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            return Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLow,
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: l10n.categoryAddLabel,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: _addLabel,
                                  ),
                                ),
                                onSubmitted: (_) => _addLabel(),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
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
                              elevation: 1,
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
