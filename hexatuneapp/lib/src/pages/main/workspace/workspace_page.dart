// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/core/workspace/models/pinned_formula.dart';
import 'package:hexatuneapp/src/core/workspace/workspace_pin_service.dart';
import 'package:hexatuneapp/src/pages/main/workspace/workspace_pin_sheet.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Main workspace page accessible from the bottom navigation bar.
///
/// Displays pinned formulas, quick-add shortcuts, stats overview,
/// a 2×2 navigation grid, and a recently-used formula list.
class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  late final WorkspacePinService _pinService;

  static const _recentCount = 20;

  @override
  void initState() {
    super.initState();
    _pinService = getIt<WorkspacePinService>();
    _loadPins();
  }

  Future<void> _loadPins() async {
    await _pinService.load();
    if (mounted) setState(() {});
  }

  void _openPinSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (ctx) => WorkspacePinSheet(pinService: _pinService),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + AppBottomBar.scrollPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(l10n, theme, colorScheme),
              const SizedBox(height: 16),
              _buildMainCard(l10n, theme, colorScheme),
              const SizedBox(height: 24),
              _buildNavGrid(l10n, theme, colorScheme),
              const SizedBox(height: 24),
              _buildRecentlyUsed(l10n, theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(Icons.workspaces_outlined, color: colorScheme.onSurface, size: 28),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.workspaceTitle,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        IconButton(
          icon: Icon(Icons.search, color: colorScheme.onSurface),
          onPressed: () {
            getIt<LogService>().devLog(
              'Search icon tapped (not yet implemented)',
              category: LogCategory.ui,
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            getIt<LogService>().devLog(
              'Notification icon tapped (not yet implemented)',
              category: LogCategory.ui,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainCard(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final pins = _pinService.pins;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pinned formulas header
            Row(
              children: [
                Icon(
                  Icons.push_pin_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.workspacePinnedFormulas,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _openPinSheet,
                  child: Text(l10n.workspacePinnedEdit),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (pins.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l10n.workspaceNoPinnedFormulas,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pins.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (ctx, i) =>
                      _buildPinnedItem(pins[i], theme, colorScheme),
                ),
              ),
            const Divider(height: 24),
            // Quick add section
            Row(
              children: [
                Icon(Icons.add, size: 18, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  l10n.workspaceQuickAdd,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ActionChip(
                    label: Text(l10n.workspaceInventory),
                    onPressed: () => context.push(RouteNames.inventoryCreate),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionChip(
                    label: Text(l10n.workspaceCategory),
                    onPressed: () => context.push(RouteNames.categoryCreate),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionChip(
                    label: Text(l10n.workspaceFormula),
                    onPressed: () => context.push(RouteNames.formulaCreate),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionChip(
                    label: Text(l10n.workspaceAmbience),
                    onPressed: () => context.push(RouteNames.ambienceCreate),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Stats section
            Row(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.workspaceStats,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    l10n.workspaceCategory,
                    0,
                    theme,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatItem(
                    l10n.workspaceInventory,
                    0,
                    theme,
                    colorScheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    l10n.workspaceFormula,
                    0,
                    theme,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatItem(
                    l10n.workspaceAmbience,
                    0,
                    theme,
                    colorScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int count,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedItem(
    PinnedFormula pin,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
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
            child: IconButton(
              icon: Icon(
                Icons.join_inner_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                getIt<LogService>().devLog(
                  'Play pinned formula tapped: ${pin.id}',
                  category: LogCategory.ui,
                );
              },
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
  }

  Widget _buildNavGrid(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final items = <(IconData, String, String)>[
      (
        Icons.category_outlined,
        l10n.workspaceCategory,
        RouteNames.categoryList,
      ),
      (
        Icons.inventory_2_outlined,
        l10n.workspaceInventory,
        RouteNames.inventoryList,
      ),
      (Icons.science_outlined, l10n.workspaceFormula, RouteNames.formulaList),
      (Icons.spa_outlined, l10n.workspaceAmbience, RouteNames.ambienceList),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: items.map((item) {
        return Card(
          color: colorScheme.surfaceContainerLow,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(item.$3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(item.$1, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.$2, style: theme.textTheme.titleSmall),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentlyUsed(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, size: 18, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              l10n.workspaceRecentlyUsed,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentCount,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (ctx, i) {
            final name = 'Formula ${i + 1}';
            return Card(
              child: ListTile(
                title: Text(name, style: theme.textTheme.bodyMedium),
                trailing: IconButton(
                  icon: Icon(
                    Icons.join_inner_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    getIt<LogService>().devLog(
                      'Play recently used formula tapped: $name',
                      category: LogCategory.ui,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
