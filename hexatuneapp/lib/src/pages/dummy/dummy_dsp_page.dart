// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';

/// Dummy DSP audio engine page for testing — will be replaced with
/// production UI.
///
/// Sound layer selection has been moved to the Ambience Presets page.
/// This page loads a saved ambience and handles playback, gain, and
/// binaural configuration.
class DummyDspPage extends StatefulWidget {
  const DummyDspPage({super.key});

  @override
  State<DummyDspPage> createState() => _DummyDspPageState();
}

class _DummyDspPageState extends State<DummyDspPage> {
  late final DspService _dspService;
  late final DspAssetService _assetService;
  late final AmbienceService _ambienceService;

  bool _binauralEnabled = true;
  final List<_CycleStepEntry> _cycleSteps = [
    _CycleStepEntry(
      deltaCtrl: TextEditingController(text: '5.0'),
      durationCtrl: TextEditingController(text: '30.0'),
    ),
  ];

  AmbienceConfig? _selectedAmbience;
  bool _ambienceLoading = false;

  double _binauralGain = DspConstants.defaultBinauralGain;

  bool _isPlaying = false;
  bool _isStopping = false;
  String? _statusMessage;
  bool _servicesReady = false;

  @override
  void initState() {
    super.initState();
    _dspService = getIt<DspService>();
    _assetService = getIt<DspAssetService>();
    _ambienceService = getIt<AmbienceService>();
    _initServices();
  }

  Future<void> _initServices() async {
    await _assetService.discover();
    await _ambienceService.load();
    if (mounted) setState(() => _servicesReady = true);
  }

  @override
  void dispose() {
    for (final s in _cycleSteps) {
      s.deltaCtrl.dispose();
      s.durationCtrl.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Ambience loading
  // ---------------------------------------------------------------------------

  Future<void> _loadAmbience(AmbienceConfig config) async {
    if (_ambienceLoading || _isPlaying) return;

    setState(() {
      _selectedAmbience = config;
      _ambienceLoading = true;
      _statusMessage = null;
    });

    try {
      // Clear previous layers (also frees decode cache)
      await _dspService.clearBase();

      // Apply gains from the ambience config
      _dspService.setBaseGain(config.baseGain);
      _dspService.setTextureGain(config.textureGain);
      _dspService.setEventGain(config.eventGain);
      _dspService.setMasterGain(config.masterGain);

      // Load base
      if (config.baseAssetId != null) {
        final baseAsset = _findAssetById(config.baseAssetId!);
        if (baseAsset != null) {
          final rc = await _dspService.loadBase(baseAsset.assetPath);
          if (rc != 0) {
            _setStatus('Base load failed (rc=$rc)');
            return;
          }
        }
      }

      // Load textures
      for (var i = 0; i < config.textureAssetIds.length; i++) {
        final asset = _findAssetById(config.textureAssetIds[i]);
        if (asset != null) {
          final rc = await _dspService.loadTexture(i, asset.assetPath);
          if (rc != 0) {
            _setStatus('Texture $i load failed (rc=$rc)');
            return;
          }
        }
      }

      // Load events
      for (var i = 0; i < config.eventAssetIds.length; i++) {
        final asset = _findAssetById(config.eventAssetIds[i]);
        if (asset != null) {
          final rc = await _dspService.loadEvent(i, asset.assetPath);
          if (rc != 0) {
            _setStatus('Event $i load failed (rc=$rc)');
            return;
          }
        }
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _ambienceLoading = false;
        _statusMessage = l10n.dspAmbienceLoaded(config.name);
      });
    } catch (e) {
      _setStatus('Load error: $e');
    }
  }

  void _setStatus(String msg) {
    if (mounted) {
      setState(() {
        _ambienceLoading = false;
        _statusMessage = msg;
      });
    }
  }

  dynamic _findAssetById(String id) {
    for (final a in _assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Play / Stop
  // ---------------------------------------------------------------------------

  Future<void> _play() async {
    // If no ambience is selected, ensure previous layers are cleared so only
    // binaural/monaural tones play.
    if (_selectedAmbience == null && _dspService.isBaseLoaded) {
      await _dspService.clearBase();
    }

    _dspService.updateBinauralConfig(
      binauralEnabled: _binauralEnabled,
      cycleSteps: _cycleSteps
          .map(
            (s) => CycleStep(
              frequencyDelta: double.tryParse(s.deltaCtrl.text) ?? 5.0,
              durationSeconds: double.tryParse(s.durationCtrl.text) ?? 30.0,
              oneshot: s.oneshot,
            ),
          )
          .toList(),
    );

    final error = await _dspService.start();
    if (error != null) {
      setState(() => _statusMessage = error);
      return;
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isPlaying = true;
      _statusMessage = l10n.dspPlaying;
    });
  }

  Future<void> _stop() async {
    await _dspService.stop();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = l10n.dspStopped;
    });
  }

  Future<void> _stopGraceful() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isStopping = true;
      _statusMessage = l10n.dspFinishingCycle;
    });
    await _dspService.stopGraceful();
    if (!mounted) return;
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = l10n.dspGracefullyStopped;
    });
  }

  void _addCycleStep() {
    setState(() {
      _cycleSteps.add(
        _CycleStepEntry(
          deltaCtrl: TextEditingController(text: '5.0'),
          durationCtrl: TextEditingController(text: '30.0'),
        ),
      );
    });
  }

  void _removeCycleStep(int index) {
    setState(() {
      _cycleSteps[index].deltaCtrl.dispose();
      _cycleSteps[index].durationCtrl.dispose();
      _cycleSteps.removeAt(index);
    });
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
      appBar: AppBar(title: Text(l10n.dspPageTitle)),
      body: !_servicesReady
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_statusMessage != null)
                    _buildStatusCard(theme, colorScheme),
                  const SizedBox(height: 12),

                  // Ambience selector
                  _buildAmbienceSelector(theme, colorScheme, l10n),
                  const SizedBox(height: 16),

                  // Binaural gain (the only gain not in ambience)
                  _buildSectionTitle(theme, l10n.dspGainControls),
                  _buildGainSlider(theme, l10n.dspBinauralMode, _binauralGain, (
                    v,
                  ) {
                    setState(() => _binauralGain = v);
                    _dspService.setBinauralGain(v);
                  }),
                  const SizedBox(height: 16),

                  // Binaural Configuration
                  _buildSectionTitle(theme, l10n.dspBinauralConfig),
                  SwitchListTile(
                    title: Text(
                      l10n.dspBinauralMode,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      _binauralEnabled
                          ? l10n.dspBinauralStereo
                          : l10n.dspBinauralMono,
                      style: theme.textTheme.bodySmall,
                    ),
                    value: _binauralEnabled,
                    onChanged: _isPlaying
                        ? null
                        : (val) => setState(() => _binauralEnabled = val),
                    dense: true,
                  ),
                  const SizedBox(height: 8),

                  // Cycle Steps
                  _buildSectionTitle(theme, l10n.dspCycleSteps),
                  ..._cycleSteps.asMap().entries.map((entry) {
                    final i = entry.key;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              step.deltaCtrl,
                              l10n.dspDeltaHz,
                              enabled: !_isPlaying,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildNumberField(
                              step.durationCtrl,
                              l10n.dspDurationS,
                              enabled: !_isPlaying,
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Checkbox(
                              value: step.oneshot,
                              onChanged: _isPlaying
                                  ? null
                                  : (val) => setState(
                                      () => step.oneshot = val ?? false,
                                    ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          if (!_isPlaying && _cycleSteps.length > 1)
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: colorScheme.error,
                              ),
                              onPressed: () => _removeCycleStep(i),
                              iconSize: 20,
                            ),
                        ],
                      ),
                    );
                  }),
                  if (!_isPlaying)
                    TextButton.icon(
                      onPressed: _addCycleStep,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.dspAddStep),
                    ),
                  const SizedBox(height: 24),

                  // Play / Stop
                  _buildPlayStopButtons(theme, colorScheme, l10n),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // Ambience selector section
  // ---------------------------------------------------------------------------

  Widget _buildAmbienceSelector(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final configs = _ambienceService.configs;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dspAmbienceSelectAmbience,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await context.push(RouteNames.ambienceList);
                    // Reload ambiences when returning
                    await _ambienceService.load();
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.settings, size: 16),
                  label: Text(l10n.dspAmbienceManage),
                ),
                if (_selectedAmbience != null && !_isPlaying)
                  IconButton(
                    onPressed: () async {
                      await _dspService.clearBase();
                      setState(() {
                        _selectedAmbience = null;
                        _statusMessage = null;
                      });
                    },
                    icon: Icon(Icons.clear, size: 18, color: colorScheme.error),
                    tooltip: 'Clear ambience',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (configs.isEmpty)
              Text(
                l10n.dspAmbienceNoneSelected,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...configs.map((config) {
                final isSelected = _selectedAmbience?.id == config.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: _ambienceLoading || _isPlaying
                          ? null
                          : () => _loadAmbience(config),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              size: 20,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    config.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _buildAmbienceSummary(config, l10n),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_ambienceLoading && isSelected)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _buildAmbienceSummary(AmbienceConfig config, AppLocalizations l10n) {
    final parts = <String>[];
    if (config.baseAssetId != null) {
      parts.add('${l10n.dspSectionBase}: 1');
    }
    if (config.textureAssetIds.isNotEmpty) {
      parts.add('${l10n.dspSectionTexture}: ${config.textureAssetIds.length}');
    }
    if (config.eventAssetIds.isNotEmpty) {
      parts.add('${l10n.dspSectionEvents}: ${config.eventAssetIds.length}');
    }
    return parts.isEmpty ? l10n.dspAmbienceNoBase : parts.join(' · ');
  }

  // ---------------------------------------------------------------------------
  // Widget helpers
  // ---------------------------------------------------------------------------

  Widget _buildStatusCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: _isPlaying
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          _statusMessage!,
          style: theme.textTheme.titleSmall?.copyWith(
            color: _isPlaying
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(text, style: theme.textTheme.titleSmall),
    );
  }

  Widget _buildNumberField(
    TextEditingController ctrl,
    String hint, {
    bool enabled = true,
  }) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildGainSlider(
    ThemeData theme,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: Slider(value: value, divisions: 20, onChanged: onChanged),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.toStringAsFixed(2),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayStopButtons(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    if (!_isPlaying) {
      return SizedBox(
        height: 56,
        child: FilledButton.icon(
          onPressed: _ambienceLoading ? null : _play,
          icon: _ambienceLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_arrow, size: 28),
          label: Text(
            _ambienceLoading ? l10n.dspLoading : l10n.dspPlay,
            style: theme.textTheme.titleMedium,
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _isStopping ? null : _stop,
              icon: const Icon(Icons.stop, size: 24),
              label: Text(l10n.dspStop, style: theme.textTheme.titleSmall),
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.tonalIcon(
              onPressed: _isStopping ? null : _stopGraceful,
              icon: _isStopping
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.timelapse, size: 24),
              label: Text(
                _isStopping ? l10n.dspFinishing : l10n.dspGraceful,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CycleStepEntry {
  _CycleStepEntry({required this.deltaCtrl, required this.durationCtrl});

  final TextEditingController deltaCtrl;
  final TextEditingController durationCtrl;
  bool oneshot = false;
}
