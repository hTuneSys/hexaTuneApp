// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/workspace/workspace_pin_service.dart';

/// Bottom sheet for managing pinned formulas.
///
/// Shows currently pinned formulas with remove option, and a search field
/// to find and pin new formulas from the API.
class WorkspacePinSheet extends StatefulWidget {
  const WorkspacePinSheet({super.key, required this.pinService});

  final WorkspacePinService pinService;

  @override
  State<WorkspacePinSheet> createState() => _WorkspacePinSheetState();
}

class _WorkspacePinSheetState extends State<WorkspacePinSheet> {
  final _searchCtrl = TextEditingController();
  final List<FormulaResponse> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }
    setState(() => _isSearching = true);
    try {
      final repo = getIt<FormulaRepository>();
      final response = await repo.list(
        params: PaginationParams(query: query.trim(), limit: 20),
      );
      if (mounted) {
        setState(() {
          _searchResults
            ..clear()
            ..addAll(response.data);
        });
      }
    } catch (e) {
      if (mounted) ApiErrorHandler.handle(context, e);
      getIt<LogService>().devLog(
        'Formula search failed: $e',
        category: LogCategory.ui,
      );
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _pin(FormulaResponse formula) async {
    await widget.pinService.pin(formula.id, formula.name);
    if (mounted) setState(() {});
  }

  Future<void> _unpin(String id) async {
    await widget.pinService.unpin(id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pins = widget.pinService.pins;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.workspacePinnedFormulas,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (pins.isNotEmpty)
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pins.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (ctx, i) {
                        final pin = pins[i];
                        return SizedBox(
                          width: 80,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => _unpin(pin.id),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.errorContainer,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 14,
                                            color: colorScheme.onErrorContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pin.name,
                                style: theme.textTheme.labelSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.surfaceContainerLow,
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: l10n.workspaceSearchToPin,
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                          ),
                          onSubmitted: _search,
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: () => _search(_searchCtrl.text),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _isSearching
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: scrollCtrl,
                          itemCount: _searchResults.length,
                          itemBuilder: (ctx, i) {
                            final formula = _searchResults[i];
                            final pinned = widget.pinService.isPinned(
                              formula.id,
                            );
                            return ListTile(
                              title: Text(
                                formula.name,
                                style: theme.textTheme.bodyMedium,
                              ),
                              trailing: pinned
                                  ? Icon(
                                      Icons.check_circle,
                                      color: colorScheme.primary,
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: colorScheme.primary,
                                      ),
                                      onPressed: () => _pin(formula),
                                    ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
