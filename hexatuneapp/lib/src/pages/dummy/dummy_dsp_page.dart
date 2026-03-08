// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';

/// Dummy DSP audio engine page for testing — will be replaced with
/// production UI.
class DummyDspPage extends StatefulWidget {
  const DummyDspPage({super.key});

  @override
  State<DummyDspPage> createState() => _DummyDspPageState();
}

class _DummyDspPageState extends State<DummyDspPage> {
  late final DspService _dspService;
  late final DspAssetService _assetService;

  final _carrierFreqCtrl = TextEditingController(text: '400.0');
  bool _binauralEnabled = true;
  final List<_CycleStepEntry> _cycleSteps = [
    _CycleStepEntry(
      deltaCtrl: TextEditingController(text: '5.0'),
      durationCtrl: TextEditingController(text: '30.0'),
    ),
  ];

  AudioAsset? _selectedBase;
  late final List<AudioAsset?> _selectedTextures = List.filled(
    DspConstants.maxTextureLayers,
    null,
  );
  late final List<AudioAsset?> _selectedEvents = List.filled(
    DspConstants.maxEventSlots,
    null,
  );

  bool _baseLoading = false;
  late final List<bool> _textureLoading = List.filled(
    DspConstants.maxTextureLayers,
    false,
  );
  late final List<bool> _eventLoading = List.filled(
    DspConstants.maxEventSlots,
    false,
  );

  double _baseGain = DspConstants.defaultBaseGain;
  double _textureGain = DspConstants.defaultTextureGain;
  double _eventGain = DspConstants.defaultEventGain;
  double _binauralGain = DspConstants.defaultBinauralGain;
  double _masterGain = DspConstants.defaultMasterGain;

  bool _isPlaying = false;
  bool _isStopping = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _dspService = getIt<DspService>();
    _assetService = getIt<DspAssetService>();
    _assetService.discover().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _carrierFreqCtrl.dispose();
    for (final s in _cycleSteps) {
      s.deltaCtrl.dispose();
      s.durationCtrl.dispose();
    }
    super.dispose();
  }

  bool get _anyLoading =>
      _baseLoading ||
      _textureLoading.any((l) => l) ||
      _eventLoading.any((l) => l);

  // ---------------------------------------------------------------------------
  // Layer selection handlers
  // ---------------------------------------------------------------------------

  Future<void> _onBaseSelected(AudioAsset? asset) async {
    setState(() {
      _selectedBase = asset;
      _baseLoading = asset != null;
    });

    if (asset == null) {
      final cascaded = await _dspService.clearBase();
      setState(() {
        _statusMessage = null;
        if (cascaded) {
          for (var i = 0; i < _selectedTextures.length; i++) {
            _selectedTextures[i] = null;
            _textureLoading[i] = false;
          }
          for (var i = 0; i < _selectedEvents.length; i++) {
            _selectedEvents[i] = null;
            _eventLoading[i] = false;
          }
        }
      });
      return;
    }

    setState(() {
      for (var i = 0; i < _selectedTextures.length; i++) {
        _selectedTextures[i] = null;
        _textureLoading[i] = false;
      }
      for (var i = 0; i < _selectedEvents.length; i++) {
        _selectedEvents[i] = null;
        _eventLoading[i] = false;
      }
    });

    try {
      final rc = await _dspService.loadBase(asset.assetPath);
      setState(() {
        _baseLoading = false;
        _statusMessage = rc == 0
            ? 'Base loaded: ${asset.name}'
            : 'Base load failed (rc=$rc)';
      });
    } catch (e) {
      setState(() {
        _baseLoading = false;
        _statusMessage = 'Base error: $e';
      });
    }
  }

  Future<void> _onTextureSelected(int index, AudioAsset? asset) async {
    setState(() {
      _selectedTextures[index] = asset;
      _textureLoading[index] = asset != null;
    });

    if (asset == null) {
      await _dspService.clearTexture(index);
      setState(() => _textureLoading[index] = false);
      return;
    }

    try {
      final rc = await _dspService.loadTexture(index, asset.assetPath);
      setState(() {
        _textureLoading[index] = false;
        if (rc == HtdError.baseRequired.code) {
          _statusMessage = 'Select a Base layer first';
          _selectedTextures[index] = null;
        } else {
          _statusMessage = rc == 0
              ? 'Texture ${index + 1} loaded: ${asset.name}'
              : 'Texture load failed (rc=$rc)';
        }
      });
    } catch (e) {
      setState(() {
        _textureLoading[index] = false;
        _statusMessage = 'Texture error: $e';
      });
    }
  }

  Future<void> _onEventSelected(int index, AudioAsset? asset) async {
    setState(() {
      _selectedEvents[index] = asset;
      _eventLoading[index] = asset != null;
    });

    if (asset == null) {
      await _dspService.clearEvent(index);
      setState(() => _eventLoading[index] = false);
      return;
    }

    try {
      final rc = await _dspService.loadEvent(index, asset.assetPath);
      setState(() {
        _eventLoading[index] = false;
        if (rc == HtdError.baseRequired.code) {
          _statusMessage = 'Select a Base layer first';
          _selectedEvents[index] = null;
        } else {
          _statusMessage = rc == 0
              ? 'Event ${index + 1} loaded: ${asset.name}'
              : 'Event load failed (rc=$rc)';
        }
      });
    } catch (e) {
      setState(() {
        _eventLoading[index] = false;
        _statusMessage = 'Event error: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Play / Stop
  // ---------------------------------------------------------------------------

  Future<void> _play() async {
    _dspService.updateBinauralConfig(
      carrierFrequency: double.tryParse(_carrierFreqCtrl.text) ?? 400.0,
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

    setState(() {
      _isPlaying = true;
      _statusMessage = 'Playing...';
    });
  }

  Future<void> _stop() async {
    await _dspService.stop();
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = 'Stopped';
    });
  }

  Future<void> _stopGraceful() async {
    setState(() {
      _isStopping = true;
      _statusMessage = 'Finishing cycle...';
    });
    await _dspService.stopGraceful();
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = 'Gracefully stopped';
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

    return Scaffold(
      appBar: AppBar(title: const Text('DSP Audio Engine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_statusMessage != null) _buildStatusCard(theme, colorScheme),
            const SizedBox(height: 12),

            // Sound Layers
            _buildSectionTitle(theme, 'Sound Layers'),
            _buildLayerSelector(
              theme,
              'Base',
              'base',
              _selectedBase,
              _baseLoading,
              _onBaseSelected,
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < DspConstants.maxTextureLayers; i++) ...[
              _buildLayerSelector(
                theme,
                'Texture ${i + 1}',
                'texture',
                _selectedTextures[i],
                _textureLoading[i],
                (asset) => _onTextureSelected(i, asset),
              ),
              const SizedBox(height: 8),
            ],
            for (var i = 0; i < DspConstants.maxEventSlots; i++) ...[
              _buildLayerSelector(
                theme,
                'Event ${i + 1}',
                'events',
                _selectedEvents[i],
                _eventLoading[i],
                (asset) => _onEventSelected(i, asset),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 16),

            // Gain Controls
            _buildSectionTitle(theme, 'Gain Controls'),
            _buildGainSlider(theme, 'Base', _baseGain, (v) {
              setState(() => _baseGain = v);
              _dspService.setBaseGain(v);
            }),
            _buildGainSlider(theme, 'Texture', _textureGain, (v) {
              setState(() => _textureGain = v);
              _dspService.setTextureGain(v);
            }),
            _buildGainSlider(theme, 'Event', _eventGain, (v) {
              setState(() => _eventGain = v);
              _dspService.setEventGain(v);
            }),
            _buildGainSlider(theme, 'Binaural', _binauralGain, (v) {
              setState(() => _binauralGain = v);
              _dspService.setBinauralGain(v);
            }),
            _buildGainSlider(theme, 'Master', _masterGain, (v) {
              setState(() => _masterGain = v);
              _dspService.setMasterGain(v);
            }),
            const SizedBox(height: 16),

            // Binaural Configuration
            _buildSectionTitle(theme, 'Binaural Configuration'),
            _buildNumberField(
              _carrierFreqCtrl,
              'Carrier Frequency (Hz)',
              enabled: !_isPlaying,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text('Binaural Mode', style: theme.textTheme.bodyMedium),
              subtitle: Text(
                _binauralEnabled ? 'Stereo binaural beats' : 'AM mono pulsing',
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
            _buildSectionTitle(theme, 'Frequency Cycle Steps'),
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
                        'Delta Hz',
                        enabled: !_isPlaying,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildNumberField(
                        step.durationCtrl,
                        'Duration s',
                        enabled: !_isPlaying,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Tooltip(
                        message: 'One-shot (first cycle only)',
                        child: Checkbox(
                          value: step.oneshot,
                          onChanged: _isPlaying
                              ? null
                              : (val) =>
                                    setState(() => step.oneshot = val ?? false),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
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
                label: const Text('Add Step'),
              ),
            const SizedBox(height: 24),

            // Play / Stop
            if (!_isPlaying)
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: _anyLoading ? null : _play,
                  icon: _anyLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow, size: 28),
                  label: Text(
                    _anyLoading ? 'LOADING...' : 'PLAY',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _isStopping ? null : _stop,
                        icon: const Icon(Icons.stop, size: 24),
                        label: Text('STOP', style: theme.textTheme.titleSmall),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                        ),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.timelapse, size: 24),
                        label: Text(
                          _isStopping ? 'FINISHING...' : 'GRACEFUL',
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
          width: 64,
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

  Widget _buildLayerSelector(
    ThemeData theme,
    String label,
    String layerType,
    AudioAsset? selected,
    bool isLoading,
    ValueChanged<AudioAsset?> onChanged,
  ) {
    final assets = _assetService.assetsForLayer(layerType);
    final colorScheme = theme.colorScheme;

    final usedPaths = <String>{};
    if (layerType == 'texture') {
      for (final t in _selectedTextures) {
        if (t != null && t != selected) usedPaths.add(t.assetPath);
      }
    } else if (layerType == 'events') {
      for (final e in _selectedEvents) {
        if (e != null && e != selected) usedPaths.add(e.assetPath);
      }
    }

    final available = assets
        .where((a) => !usedPaths.contains(a.assetPath))
        .toList();

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: theme.textTheme.labelMedium),
        ),
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isLoading ? colorScheme.tertiary : colorScheme.outline,
                width: isLoading ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AudioAsset?>(
                value: selected,
                isExpanded: true,
                isDense: true,
                hint: Text(
                  available.isEmpty ? 'No files' : 'Select...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                items: [
                  DropdownMenuItem<AudioAsset?>(
                    child: Text(
                      '-- None --',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  ...available.map(
                    (a) => DropdownMenuItem<AudioAsset?>(
                      value: a,
                      child: Text(a.name, style: theme.textTheme.bodySmall),
                    ),
                  ),
                ],
                onChanged: isLoading ? null : onChanged,
              ),
            ),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (selected != null && !isLoading)
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () => onChanged(null),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
