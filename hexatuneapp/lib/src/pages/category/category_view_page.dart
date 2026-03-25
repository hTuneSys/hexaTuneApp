// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Read-only page for viewing a category's details.
class CategoryViewPage extends StatefulWidget {
  const CategoryViewPage({required this.categoryId, super.key});

  final String categoryId;

  @override
  State<CategoryViewPage> createState() => _CategoryViewPageState();
}

class _CategoryViewPageState extends State<CategoryViewPage> {
  bool _isLoading = true;
  CategoryResponse? _category;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    try {
      final cat = await getIt<CategoryRepository>().getById(widget.categoryId);
      if (mounted) {
        setState(() {
          _category = cat;
          _isLoading = false;
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load category: $e',
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
      appBar: AppBar(title: Text(l10n.categoryView)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _category == null
          ? Center(
              child: Text(
                l10n.categoryEmptyTitle,
                style: theme.textTheme.bodyLarge,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.categoryName,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_category!.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 20),
                      Text(
                        l10n.categoryDescription,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '—',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.categoryLabels,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_category!.labels.isEmpty)
                        Text(
                          l10n.categoryNoLabels,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _category!.labels
                              .map((l) => Chip(label: Text(l)))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
