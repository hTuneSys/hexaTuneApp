// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Dummy page for testing the hexaGen hardware device service.
///
/// Provides controls for: connection, version query, RGB LED, reset,
/// frequency sweep (list-based), and operation lifecycle tracking.
/// No firmware update is exposed here intentionally.
class DummyHexagenPage extends StatefulWidget {
  const DummyHexagenPage({super.key});

  @override
  State<DummyHexagenPage> createState() => _DummyHexagenPageState();
}

class _DummyHexagenPageState extends State<DummyHexagenPage> {
  late final HexagenService _hexagenService;
  late final LogService _logService;

  StreamSubscription<HexagenState>? _stateSub;
  HexagenState _state = const HexagenState();

  bool _isInitializing = false;
  bool _isFreqRunning = false;
  bool _isOperationRunning = false;

  // RGB controllers
  final _redCtrl = TextEditingController(text: '0');
  final _greenCtrl = TextEditingController(text: '128');
  final _blueCtrl = TextEditingController(text: '255');

  // Frequency list — each entry is [freq Hz, duration ms]
  final List<_FreqEntry> _freqList = [
    _FreqEntry(freq: 440, durationMs: 1000),
    _FreqEntry(freq: 528, durationMs: 1500),
    _FreqEntry(freq: 639, durationMs: 1000),
  ];

  final _newFreqCtrl = TextEditingController(text: '432');
  final _newDurationCtrl = TextEditingController(text: '1000');

  @override
  void initState() {
    super.initState();
    _hexagenService = getIt<HexagenService>();
    _logService = getIt<LogService>();

    _state = _hexagenService.currentState;
    _stateSub = _hexagenService.state.listen((s) {
      if (mounted) setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _redCtrl.dispose();
    _greenCtrl.dispose();
    _blueCtrl.dispose();
    _newFreqCtrl.dispose();
    _newDurationCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _initService() async {
    setState(() => _isInitializing = true);
    _logService.devLog('→ HexagenService.init()', category: LogCategory.ui);
    try {
      await _hexagenService.init();
      if (mounted) _showToast(AppLocalizations.of(context)!.hexagenInitSuccess);
    } catch (e) {
      if (mounted) _showToast(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  Future<void> _refresh() async {
    _logService.devLog('→ HexagenService.refresh()', category: LogCategory.ui);
    try {
      await _hexagenService.refresh();
      if (mounted) _showToast(AppLocalizations.of(context)!.hexagenRefreshed);
    } catch (e) {
      if (mounted) _showToast(e.toString(), isError: true);
    }
  }

  Future<void> _sendRgb() async {
    final r = int.tryParse(_redCtrl.text.trim()) ?? 0;
    final g = int.tryParse(_greenCtrl.text.trim()) ?? 0;
    final b = int.tryParse(_blueCtrl.text.trim()) ?? 0;
    final id = _hexagenService.generateId();
    final cmd = ATCommand.setRgb(
      id,
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
    );
    _logService.devLog(
      '→ SETRGB id=$id r=$r g=$g b=$b',
      category: LogCategory.ui,
    );
    try {
      await _hexagenService.sendATCommand(cmd);
      if (mounted) {
        _showToast(AppLocalizations.of(context)!.hexagenRgbSent);
      }
    } catch (e) {
      if (mounted) _showToast(e.toString(), isError: true);
    }
  }

  Future<void> _sendReset() async {
    final id = _hexagenService.generateId();
    final cmd = ATCommand.reset(id);
    _logService.devLog('→ RESET id=$id', category: LogCategory.ui);
    try {
      await _hexagenService.sendATCommand(cmd);
      if (mounted) _showToast(AppLocalizations.of(context)!.hexagenResetSent);
    } catch (e) {
      if (mounted) _showToast(e.toString(), isError: true);
    }
  }

  Future<void> _runFreqList() async {
    if (_freqList.isEmpty) return;
    setState(() => _isFreqRunning = true);
    final l10n = AppLocalizations.of(context)!;

    for (int i = 0; i < _freqList.length; i++) {
      if (!mounted || !_isFreqRunning) break;
      final entry = _freqList[i];
      _logService.devLog(
        '→ FREQ [${i + 1}/${_freqList.length}] '
        '${entry.freq} Hz / ${entry.durationMs} ms',
        category: LogCategory.ui,
      );
      if (mounted) {
        _showToast(
          l10n.hexagenFreqProgress(i + 1, _freqList.length, entry.freq),
        );
      }

      final status = await _hexagenService.sendFreqCommandAndWait(
        entry.freq,
        entry.durationMs,
      );

      if (!mounted) break;
      if (status != CommandStatus.success) {
        _showToast(
          l10n.hexagenFreqFailed(entry.freq, status.name),
          isError: true,
        );
        break;
      }
    }

    if (mounted) {
      setState(() => _isFreqRunning = false);
      _showToast(l10n.hexagenFreqListDone);
    }
  }

  void _stopFreqList() {
    setState(() => _isFreqRunning = false);
  }

  Future<void> _runOperation() async {
    setState(() => _isOperationRunning = true);
    final l10n = AppLocalizations.of(context)!;
    final opId = _hexagenService.generateId();

    _logService.devLog(
      '→ OPERATION PREPARE id=$opId',
      category: LogCategory.ui,
    );
    if (mounted) _showToast(l10n.hexagenOpPreparing);

    final prepStatus = await _hexagenService.sendOperationPrepare(opId);
    if (!mounted) return;

    if (prepStatus != CommandStatus.success) {
      _showToast(l10n.hexagenOpPrepareFailed(prepStatus.name), isError: true);
      setState(() => _isOperationRunning = false);
      return;
    }

    _logService.devLog(
      '→ OPERATION GENERATE id=$opId',
      category: LogCategory.ui,
    );
    if (mounted) _showToast(l10n.hexagenOpGenerating);

    await _hexagenService.sendOperationGenerate(opId);

    // Poll status periodically
    for (int i = 0; i < 60; i++) {
      if (!mounted || !_isOperationRunning) break;
      await Future.delayed(const Duration(seconds: 1));
      await _hexagenService.queryOperationStatus();

      final status = _hexagenService.currentOperationStatus;
      final step = _hexagenService.currentGeneratingStepId;

      if (mounted && status != null) {
        _showToast(l10n.hexagenOpStatus(status, step ?? 0));
      }

      if (status == 'COMPLETED' || status == 'ERROR') break;
    }

    _hexagenService.resetOperationState();
    if (mounted) {
      setState(() => _isOperationRunning = false);
      _showToast(l10n.hexagenOpDone);
    }
  }

  void _addFreqEntry() {
    final freq = int.tryParse(_newFreqCtrl.text.trim());
    final dur = int.tryParse(_newDurationCtrl.text.trim());
    if (freq == null || freq <= 0 || dur == null || dur <= 0) return;
    setState(() {
      _freqList.add(_FreqEntry(freq: freq, durationMs: dur));
    });
  }

  void _removeFreqEntry(int index) {
    setState(() => _freqList.removeAt(index));
  }

  void _showToast(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: isError
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hexagenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.hexagenRefresh,
            onPressed: _refresh,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConnectionCard(theme, colorScheme, l10n),
          const SizedBox(height: 12),
          _buildRgbCard(theme, colorScheme, l10n),
          const SizedBox(height: 12),
          _buildFreqCard(theme, colorScheme, l10n),
          const SizedBox(height: 12),
          _buildOperationCard(theme, colorScheme, l10n),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Connection & Status Card
  // ---------------------------------------------------------------------------

  Widget _buildConnectionCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final connected = _state.isConnected;
    final ready = _state.isReady;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  connected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: connected ? colorScheme.primary : colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.hexagenConnection,
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                _buildStatusChip(
                  ready
                      ? l10n.hexagenStatusReady
                      : connected
                      ? l10n.hexagenStatusConnected
                      : l10n.hexagenStatusDisconnected,
                  ready
                      ? colorScheme.primary
                      : connected
                      ? colorScheme.tertiary
                      : colorScheme.error,
                  colorScheme,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              l10n.hexagenDevice,
              _state.deviceName ?? l10n.hexagenNone,
              theme,
            ),
            _buildInfoRow(
              l10n.hexagenDeviceId,
              _state.deviceId ?? l10n.hexagenNone,
              theme,
            ),
            _buildInfoRow(
              l10n.hexagenFirmware,
              _state.firmwareVersion ?? l10n.hexagenNone,
              theme,
            ),
            _buildInfoRow(
              l10n.hexagenInitialized,
              _state.isInitialized ? l10n.hexagenYes : l10n.hexagenNo,
              theme,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isInitializing ? null : _initService,
                    icon: _isInitializing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.power_settings_new),
                    label: Text(l10n.hexagenInit),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sendReset,
                    icon: const Icon(Icons.restart_alt),
                    label: Text(l10n.hexagenReset),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RGB Card
  // ---------------------------------------------------------------------------

  Widget _buildRgbCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: colorScheme.secondary),
                const SizedBox(width: 8),
                Text(l10n.hexagenRgb, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildColorField(
                    _redCtrl,
                    l10n.hexagenRed,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildColorField(
                    _greenCtrl,
                    l10n.hexagenGreen,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildColorField(
                    _blueCtrl,
                    l10n.hexagenBlue,
                    colorScheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildColorPreview(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _state.isConnected ? _sendRgb : null,
                icon: const Icon(Icons.send),
                label: Text(l10n.hexagenSendRgb),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorField(
    TextEditingController ctrl,
    String label,
    ColorScheme colorScheme,
  ) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0–255',
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildColorPreview() {
    final r = (int.tryParse(_redCtrl.text.trim()) ?? 0).clamp(0, 255);
    final g = (int.tryParse(_greenCtrl.text.trim()) ?? 0).clamp(0, 255);
    final b = (int.tryParse(_blueCtrl.text.trim()) ?? 0).clamp(0, 255);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, r, g, b),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Frequency List Card
  // ---------------------------------------------------------------------------

  Widget _buildFreqCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.graphic_eq, color: colorScheme.tertiary),
                const SizedBox(width: 8),
                Text(l10n.hexagenFreqSweep, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            // Existing freq entries
            if (_freqList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.hexagenFreqEmpty,
                  style: theme.textTheme.bodySmall,
                ),
              )
            else
              ..._freqList.asMap().entries.map((e) {
                final i = e.key;
                final entry = e.value;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: colorScheme.tertiaryContainer,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: colorScheme.onTertiaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text('${entry.freq} Hz'),
                  subtitle: Text('${entry.durationMs} ms'),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: colorScheme.error),
                    iconSize: 18,
                    onPressed: _isFreqRunning
                        ? null
                        : () => _removeFreqEntry(i),
                  ),
                );
              }),

            const Divider(),
            // Add new entry
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newFreqCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.hexagenFreqHz,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _newDurationCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.hexagenDurationMs,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isFreqRunning ? null : _addFreqEntry,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _state.isConnected && !_isFreqRunning
                        ? _runFreqList
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.hexagenFreqRun(_freqList.length)),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isFreqRunning)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _stopFreqList,
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.hexagenFreqStop),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Operation Card
  // ---------------------------------------------------------------------------

  Widget _buildOperationCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final opStatus = _hexagenService.currentOperationStatus;
    final opStep = _hexagenService.currentGeneratingStepId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_suggest, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.hexagenOperation, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              l10n.hexagenOpId,
              _hexagenService.currentOperationId?.toString() ??
                  l10n.hexagenNone,
              theme,
            ),
            _buildInfoRow(
              l10n.hexagenOpCurrentStatus,
              opStatus ?? l10n.hexagenNone,
              theme,
            ),
            if (opStep != null)
              _buildInfoRow(l10n.hexagenOpStep, opStep.toString(), theme),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _state.isConnected && !_isOperationRunning
                    ? _runOperation
                    : null,
                icon: _isOperationRunning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_circle),
                label: Text(
                  _isOperationRunning
                      ? l10n.hexagenOpRunning
                      : l10n.hexagenOpStart,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, ColorScheme colorScheme) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: colorScheme.onPrimary, fontSize: 11),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class _FreqEntry {
  _FreqEntry({required this.freq, required this.durationMs});

  final int freq;
  final int durationMs;
}
