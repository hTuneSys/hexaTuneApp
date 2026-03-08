// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_assignment_dto.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

/// Dummy page for testing the harmonics generation endpoint.
class DummyHarmonicsPage extends StatefulWidget {
  const DummyHarmonicsPage({super.key});

  @override
  State<DummyHarmonicsPage> createState() => _DummyHarmonicsPageState();
}

class _DummyHarmonicsPageState extends State<DummyHarmonicsPage> {
  final List<InventoryResponse> _inventories = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = false;
  GenerateHarmonicsResponse? _lastResponse;

  @override
  void initState() {
    super.initState();
    _loadInventories();
  }

  Future<void> _loadInventories() async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<InventoryRepository>();
      final resp = await repo.list(params: const PaginationParams(limit: 50));
      if (mounted) {
        setState(() {
          _inventories
            ..clear()
            ..addAll(resp.data);
        });
      }
      log.devLog(
        '✓ Inventories loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load inventories failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generate() async {
    if (_selectedIds.isEmpty) {
      _showMessage('Select at least one inventory item', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<HarmonicsRepository>();
      final request = GenerateHarmonicsRequest(
        inventoryIds: _selectedIds.toList(),
      );
      final response = await repo.generate(request);

      if (mounted) {
        setState(() {
          _lastResponse = response;
          _selectedIds.clear();
        });
      }
      log.devLog(
        '✓ Harmonics generated: ${response.totalAssigned} assignments, '
        'requestId=${response.requestId}',
        category: LogCategory.ui,
      );
      if (mounted) {
        _showMessage(
          'Generated ${response.totalAssigned} harmonic assignments',
        );
      }
    } catch (e) {
      log.devLog('✗ Generate harmonics failed: $e', category: LogCategory.ui);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmonics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadInventories,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _generate,
        icon: const Icon(Icons.music_note),
        label: Text('Generate (${_selectedIds.length})'),
      ),
      body: Column(
        children: [
          // Result banner
          if (_lastResponse != null) _buildResponseBanner(colorScheme),

          // Inventory selection list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Select inventory items',
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                if (_selectedIds.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _selectedIds.clear()),
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading && _inventories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadInventories,
                    child: _inventories.isEmpty
                        ? const Center(child: Text('No inventories found'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: _inventories.length,
                            itemBuilder: (ctx, i) {
                              final inv = _inventories[i];
                              final selected = _selectedIds.contains(inv.id);
                              return CheckboxListTile(
                                value: selected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedIds.add(inv.id);
                                    } else {
                                      _selectedIds.remove(inv.id);
                                    }
                                  });
                                },
                                title: Text(inv.name),
                                subtitle: Text(
                                  inv.description ?? inv.id,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondary: Icon(
                                  Icons.inventory_2,
                                  color: selected
                                      ? colorScheme.primary
                                      : colorScheme.outline,
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseBanner(ColorScheme colorScheme) {
    final resp = _lastResponse!;
    return Card(
      margin: const EdgeInsets.all(8),
      color: colorScheme.primaryContainer,
      child: ExpansionTile(
        leading: Icon(Icons.check_circle, color: colorScheme.primary),
        title: Text(
          '${resp.totalAssigned} assignments',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        subtitle: Text(
          'Request: ${resp.requestId}',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        children: [
          for (final a in resp.assignments)
            _buildAssignmentTile(a, colorScheme),
        ],
      ),
    );
  }

  Widget _buildAssignmentTile(
    HarmonicAssignmentDto assignment,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: colorScheme.tertiary,
        child: Text(
          '${assignment.harmonicNumber}',
          style: TextStyle(color: colorScheme.onTertiary, fontSize: 12),
        ),
      ),
      title: SelectableText(assignment.inventoryId),
      subtitle: Text('Assigned: ${assignment.assignedAt}'),
    );
  }
}
