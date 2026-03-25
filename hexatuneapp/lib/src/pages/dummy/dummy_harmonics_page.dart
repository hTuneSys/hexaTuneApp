// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Dummy page for testing the harmonics generation endpoint.
class DummyHarmonicsPage extends StatefulWidget {
  const DummyHarmonicsPage({super.key});

  @override
  State<DummyHarmonicsPage> createState() => _DummyHarmonicsPageState();
}

class _DummyHarmonicsPageState extends State<DummyHarmonicsPage> {
  static const _generationTypes = [
    'Monaural',
    'Binaural',
    'Magnetic',
    'Photonic',
    'Quantal',
  ];
  static const _sourceTypes = ['Flow', 'Formula'];

  final List<FormulaResponse> _formulas = [];
  bool _isLoading = false;
  GenerateHarmonicsResponse? _lastResponse;

  String _selectedGenType = 'Monaural';
  String _selectedSourceType = 'Formula';
  String? _selectedSourceId;

  @override
  void initState() {
    super.initState();
    _loadFormulas();
  }

  Future<void> _loadFormulas() async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<FormulaRepository>();
      final resp = await repo.list(params: const PaginationParams(limit: 50));
      if (mounted) {
        setState(() {
          _formulas
            ..clear()
            ..addAll(resp.data);
        });
      }
      log.devLog(
        '✓ Formulas loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load formulas failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generate() async {
    if (_selectedSourceId == null) {
      _showMessage('Select a source', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<HarmonicsRepository>();
      final request = GenerateHarmonicsRequest(
        generationType: _selectedGenType,
        sourceType: _selectedSourceType,
        sourceId: _selectedSourceId!,
      );
      final response = await repo.generate(request);

      if (mounted) {
        setState(() => _lastResponse = response);
      }
      log.devLog(
        '✓ Harmonics generated: ${response.totalItems} packets, '
        'requestId=${response.requestId}',
        category: LogCategory.ui,
      );
      if (mounted) {
        _showMessage('Generated ${response.totalItems} harmonic packets');
      }
    } catch (e) {
      log.devLog('✗ Generate harmonics failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
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
            onPressed: _isLoading ? null : _loadFormulas,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading || _selectedSourceId == null ? null : _generate,
        icon: const Icon(Icons.music_note),
        label: const Text('Generate'),
      ),
      body: Column(
        children: [
          if (_lastResponse != null) _buildResponseBanner(colorScheme),

          // Generation type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedGenType,
              decoration: const InputDecoration(labelText: 'Generation Type'),
              items: _generationTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedGenType = val);
              },
            ),
          ),

          // Source type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedSourceType,
              decoration: const InputDecoration(labelText: 'Source Type'),
              items: _sourceTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSourceType = val;
                    _selectedSourceId = null;
                  });
                }
              },
            ),
          ),

          // Source ID selector (formulas)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedSourceId,
              decoration: const InputDecoration(labelText: 'Source'),
              items: _formulas
                  .map(
                    (f) => DropdownMenuItem(value: f.id, child: Text(f.name)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedSourceId = val),
              hint: const Text('Select a source'),
            ),
          ),

          const Divider(),

          // Packet sequence list (from last response)
          if (_lastResponse != null && _lastResponse!.sequence.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Sequence', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Text(
                    '${_lastResponse!.sequence.length} packets',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading && _formulas.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _lastResponse == null || _lastResponse!.sequence.isEmpty
                ? Center(
                    child: Text(
                      'Select parameters and generate',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      0,
                      8,
                      AppBottomBar.scrollPadding,
                    ),
                    itemCount: _lastResponse!.sequence.length,
                    itemBuilder: (ctx, i) => _buildPacketTile(
                      _lastResponse!.sequence[i],
                      i,
                      colorScheme,
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
      child: ListTile(
        leading: Icon(Icons.check_circle, color: colorScheme.primary),
        title: Text(
          '${resp.totalItems} packets — ${resp.generationType}',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        subtitle: Text(
          'Source: ${resp.sourceType}/${resp.sourceId}\n'
          'Request: ${resp.requestId}',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
      ),
    );
  }

  Widget _buildPacketTile(
    HarmonicPacketDto packet,
    int index,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.tertiary,
          child: Text(
            '${index + 1}',
            style: TextStyle(color: colorScheme.onTertiary, fontSize: 12),
          ),
        ),
        title: Text('Value: ${packet.value}'),
        subtitle: Text(
          'Duration: ${packet.durationMs}ms'
          '${packet.isOneShot ? ' • One-shot' : ''}',
        ),
        trailing: packet.isOneShot
            ? Icon(Icons.looks_one, color: colorScheme.tertiary)
            : null,
      ),
    );
  }
}
