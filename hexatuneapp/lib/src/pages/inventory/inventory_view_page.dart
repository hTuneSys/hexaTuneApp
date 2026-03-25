// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Read-only page for viewing an inventory item's details.
class InventoryViewPage extends StatefulWidget {
  const InventoryViewPage({required this.inventoryId, super.key});

  final String inventoryId;

  @override
  State<InventoryViewPage> createState() => _InventoryViewPageState();
}

class _InventoryViewPageState extends State<InventoryViewPage> {
  bool _isLoading = true;
  InventoryResponse? _inventory;
  String? _categoryName;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final invRepo = getIt<InventoryRepository>();
      final inv = await invRepo.getById(widget.inventoryId);
      String? catName;
      try {
        final catRepo = getIt<CategoryRepository>();
        final cat = await catRepo.getById(inv.categoryId);
        catName = cat.name;
      } catch (_) {
        catName = inv.categoryId;
      }
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
          _categoryName = catName;
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
        AppSnackBar.error(context, message: e.toString());
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryView)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _inventory == null
          ? Center(
              child: Text(
                l10n.inventoryEmptyTitle,
                style: theme.textTheme.bodyLarge,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image area
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageUrl != null
                        ? ClipRRect(
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
                          )
                        : Center(
                            child: Icon(
                              _inventory!.imageUploaded
                                  ? Icons.image
                                  : Icons.image_not_supported_outlined,
                              size: 64,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.inventoryName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _inventory!.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.inventoryDescription,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _inventory!.description ?? '—',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _inventory!.description != null
                              ? null
                              : theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.inventoryCategory,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _categoryName ?? '—',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.inventoryLabels,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_inventory!.labels.isEmpty)
                    Text(
                      l10n.inventoryNoLabels,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _inventory!.labels
                          .map((l) => Chip(label: Text(l)))
                          .toList(),
                    ),
                ],
              ),
            ),
    );
  }
}
