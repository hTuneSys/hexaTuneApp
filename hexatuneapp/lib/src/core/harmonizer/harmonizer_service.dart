// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_validation.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

/// Orchestration service that manages frequency generation across multiple
/// hardware/software backends (DSP engine for Monaural/Binaural, hexaGen
/// device for Magnetic).
///
/// Exposes a [state] stream that the UI binds to for real-time updates.
@singleton
class HarmonizerService {
  HarmonizerService(
    this._dspService,
    this._hexagenService,
    this._headsetService,
    this._ambienceService,
    this._assetService,
    this._logService,
  );

  final DspService _dspService;
  final HexagenService _hexagenService;
  final HeadsetService _headsetService;
  final AmbienceService _ambienceService;
  final DspAssetService _assetService;
  final LogService _logService;

  final _stateController = StreamController<HarmonizerState>.broadcast();
  HarmonizerState _currentState = const HarmonizerState();

  Timer? _timeTracker;
  DateTime? _playStartTime;
  int? _magneticOperationId;
  bool _magneticLooping = false;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Broadcast stream of harmonizer state changes.
  Stream<HarmonizerState> get state => _stateController.stream;

  /// Current state snapshot.
  HarmonizerState get currentState => _currentState;

  /// Whether the harmonizer is actively playing.
  bool get isPlaying => _currentState.status == HarmonizerStatus.playing;

  /// Validates hardware prerequisites for the given [type].
  HarmonizerValidation validatePrerequisites(GenerationType type) {
    if (!type.isActive) return HarmonizerValidation.notSupported;
    if (type.requiresHeadset && !_headsetService.isConnected) {
      return HarmonizerValidation.headsetRequired;
    }
    if (type.requiresHexagen && !_hexagenService.isConnected) {
      return HarmonizerValidation.hexagenRequired;
    }
    return HarmonizerValidation.valid;
  }

  /// Starts playback with the given [config].
  ///
  /// Returns `null` on success, or an error message string on failure.
  Future<String?> play(HarmonizerConfig config) async {
    if (_currentState.status == HarmonizerStatus.playing ||
        _currentState.status == HarmonizerStatus.preparing) {
      return 'Harmonizer is already active';
    }

    final validation = validatePrerequisites(config.type);
    if (validation != HarmonizerValidation.valid) {
      return _validationMessage(validation);
    }

    if (config.steps.isEmpty) {
      return 'No harmonic packets provided';
    }

    _logService.info(
      'Harmonizer play: type=${config.type.name}, '
      'steps=${config.steps.length}, ambience=${config.ambienceId ?? "none"}',
      category: LogCategory.dsp,
    );

    _updateState(
      _currentState.copyWith(
        activeType: config.type,
        status: HarmonizerStatus.preparing,
        sequence: config.steps,
        ambienceId: config.ambienceId,
        currentCycle: 0,
        currentStepIndex: 0,
        errorMessage: null,
        gracefulStopRequested: false,
      ),
    );

    // Compute cycle durations.
    final firstDur = _computeCycleDuration(config.steps, includeOneShots: true);
    final loopDur = _computeCycleDuration(config.steps, includeOneShots: false);

    _updateState(
      _currentState.copyWith(
        totalCycleDuration: loopDur,
        firstCycleDuration: firstDur,
        remainingInCycle: firstDur,
        isFirstCycle: true,
      ),
    );

    try {
      if (config.type.usesDsp) {
        await _startDspPlayback(config);
      } else if (config.type == GenerationType.magnetic) {
        await _startMagneticPlayback(config);
      }

      _playStartTime = DateTime.now();
      _startTimeTracker();

      _updateState(_currentState.copyWith(status: HarmonizerStatus.playing));

      return null;
    } catch (e, st) {
      _logService.error(
        'Harmonizer play failed: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
      _updateState(
        _currentState.copyWith(
          status: HarmonizerStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return e.toString();
    }
  }

  /// Requests a graceful stop — the current cycle completes before stopping.
  Future<void> stopGraceful() async {
    if (_currentState.status != HarmonizerStatus.playing) return;

    _logService.info(
      'Harmonizer graceful stop requested',
      category: LogCategory.dsp,
    );

    _updateState(
      _currentState.copyWith(
        status: HarmonizerStatus.stopping,
        gracefulStopRequested: true,
      ),
    );

    try {
      final type = _currentState.activeType;
      if (type != null && type.usesDsp) {
        await _dspService.stopGraceful();
      } else if (type == GenerationType.magnetic) {
        await _stopMagnetic();
      }
    } finally {
      _cleanup();
    }
  }

  /// Immediately stops all playback without waiting for cycle completion.
  Future<void> stopImmediate() async {
    if (_currentState.status != HarmonizerStatus.playing &&
        _currentState.status != HarmonizerStatus.stopping) {
      return;
    }

    _logService.info('Harmonizer immediate stop', category: LogCategory.dsp);

    try {
      final type = _currentState.activeType;
      if (type != null && type.usesDsp) {
        await _dspService.stop();
      } else if (type == GenerationType.magnetic) {
        await _stopMagnetic();
      }
    } finally {
      _cleanup();
    }
  }

  /// Cleans up resources.
  @disposeMethod
  void dispose() {
    _timeTracker?.cancel();
    _magneticLooping = false;
    _stateController.close();
    _logService.devLog('HarmonizerService disposed', category: LogCategory.dsp);
  }

  // ---------------------------------------------------------------------------
  // DSP Playback
  // ---------------------------------------------------------------------------

  Future<void> _startDspPlayback(HarmonizerConfig config) async {
    // Load ambience if specified.
    if (config.ambienceId != null) {
      await _loadAmbience(config.ambienceId!);
    }

    // Configure binaural mode: carrier fixed at 220 Hz.
    final isBinaural = config.type == GenerationType.binaural;
    final cycleSteps = config.steps.map(_packetToCycleStep).toList();

    _dspService.updateBinauralConfig(
      carrierFrequency: DspConstants.harmonizerCarrierFrequency,
      binauralEnabled: isBinaural,
      cycleSteps: cycleSteps,
    );

    final error = await _dspService.start();
    if (error != null) {
      throw StateError('DSP start failed: $error');
    }
  }

  /// Converts a [HarmonicPacketDto] to a [CycleStep] for the DSP engine.
  ///
  /// `value` → frequency delta (Hz offset from 220 Hz carrier).
  /// `durationMs` → duration in seconds.
  /// `isOneShot` → maps directly to [CycleStep.oneshot].
  CycleStep _packetToCycleStep(HarmonicPacketDto packet) {
    return CycleStep(
      frequencyDelta: packet.value.toDouble(),
      durationSeconds: packet.durationMs / 1000.0,
      oneshot: packet.isOneShot,
    );
  }

  Future<void> _loadAmbience(String ambienceId) async {
    final config = _ambienceService.findById(ambienceId);
    if (config == null) {
      _logService.warning(
        'Ambience $ambienceId not found, skipping',
        category: LogCategory.dsp,
      );
      return;
    }

    // Clear previous layers.
    await _dspService.clearBase();

    // Apply gains.
    _dspService.setBaseGain(config.baseGain);
    _dspService.setTextureGain(config.textureGain);
    _dspService.setEventGain(config.eventGain);
    _dspService.setMasterGain(config.masterGain);

    // Load base layer.
    if (config.baseAssetId != null) {
      final asset = _findAsset(config.baseAssetId!);
      if (asset != null) {
        final rc = await _dspService.loadBase(asset.assetPath);
        if (rc != 0) {
          _logService.warning('Base load rc=$rc', category: LogCategory.dsp);
        }
      }
    }

    // Load texture layers.
    for (var i = 0; i < config.textureAssetIds.length; i++) {
      final asset = _findAsset(config.textureAssetIds[i]);
      if (asset != null) {
        await _dspService.loadTexture(i, asset.assetPath);
      }
    }

    // Load event layers.
    for (var i = 0; i < config.eventAssetIds.length; i++) {
      final asset = _findAsset(config.eventAssetIds[i]);
      if (asset != null) {
        await _dspService.loadEvent(i, asset.assetPath);
      }
    }

    _logService.devLog(
      'Ambience "$ambienceId" loaded for harmonizer',
      category: LogCategory.dsp,
    );
  }

  dynamic _findAsset(String id) {
    for (final a in _assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Magnetic Playback
  // ---------------------------------------------------------------------------

  Future<void> _startMagneticPlayback(HarmonizerConfig config) async {
    final opId = _hexagenService.generateId();
    _magneticOperationId = opId;
    _magneticLooping = true;

    // PREPARE
    final prepareStatus = await _hexagenService.sendOperationPrepare(opId);
    if (prepareStatus != CommandStatus.success) {
      throw StateError('HexaGen PREPARE failed: ${prepareStatus.name}');
    }

    // Send FREQ commands.
    for (final packet in config.steps) {
      if (!_magneticLooping) return;
      final status = await _hexagenService.sendFreqCommandAndWait(
        packet.value,
        packet.durationMs,
      );
      if (status != CommandStatus.success) {
        _logService.warning(
          'FREQ ${packet.value} Hz failed: ${status.name}',
          category: LogCategory.hardware,
        );
      }
    }

    // GENERATE (starts the execution on the device).
    await _hexagenService.sendOperationGenerate(opId);

    _logService.info(
      'Magnetic operation $opId started with ${config.steps.length} steps',
      category: LogCategory.hardware,
    );
  }

  Future<void> _stopMagnetic() async {
    _magneticLooping = false;
    final opId = _magneticOperationId;
    if (opId != null) {
      // Temporary: both graceful and immediate send RESET.
      await _hexagenService.sendATCommand(ATCommand.reset(opId));
      _hexagenService.resetOperationState();
      _magneticOperationId = null;
    }
  }

  // ---------------------------------------------------------------------------
  // Time Tracking
  // ---------------------------------------------------------------------------

  void _startTimeTracker() {
    _timeTracker?.cancel();
    _timeTracker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentState.status != HarmonizerStatus.playing) {
        _timeTracker?.cancel();
        return;
      }

      final elapsed = _playStartTime != null
          ? DateTime.now().difference(_playStartTime!)
          : Duration.zero;

      final cycleDur = _currentState.isFirstCycle
          ? _currentState.firstCycleDuration
          : _currentState.totalCycleDuration;

      if (cycleDur == Duration.zero) return;

      final cycleMs = cycleDur.inMilliseconds;
      final elapsedMs = elapsed.inMilliseconds;

      final currentCycle = cycleMs > 0 ? elapsedMs ~/ cycleMs : 0;
      final positionInCycle = cycleMs > 0 ? elapsedMs % cycleMs : 0;
      final remaining = Duration(milliseconds: cycleMs - positionInCycle);

      // Determine current step index.
      var stepIndex = 0;
      var accumulated = 0;
      final steps = _currentState.sequence;
      for (var i = 0; i < steps.length; i++) {
        final stepMs = steps[i].durationMs;
        if (accumulated + stepMs > positionInCycle) {
          stepIndex = i;
          break;
        }
        accumulated += stepMs;
        if (i == steps.length - 1) stepIndex = i;
      }

      final isFirst = currentCycle == 0;

      _updateState(
        _currentState.copyWith(
          currentCycle: currentCycle,
          currentStepIndex: stepIndex,
          remainingInCycle: remaining,
          isFirstCycle: isFirst,
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Duration _computeCycleDuration(
    List<HarmonicPacketDto> steps, {
    required bool includeOneShots,
  }) {
    var totalMs = 0;
    for (final s in steps) {
      if (!includeOneShots && s.isOneShot) continue;
      totalMs += s.durationMs;
    }
    return Duration(milliseconds: totalMs);
  }

  void _cleanup() {
    _timeTracker?.cancel();
    _timeTracker = null;
    _playStartTime = null;
    _magneticLooping = false;

    _updateState(const HarmonizerState());

    _logService.info('Harmonizer stopped', category: LogCategory.dsp);
  }

  String _validationMessage(HarmonizerValidation validation) {
    return switch (validation) {
      HarmonizerValidation.valid => '',
      HarmonizerValidation.headsetRequired =>
        'Headphones are required for binaural mode',
      HarmonizerValidation.hexagenRequired =>
        'A hexaGen device must be connected for magnetic mode',
      HarmonizerValidation.notSupported =>
        'This generation type is not yet supported',
    };
  }

  void _updateState(HarmonizerState newState) {
    _currentState = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }
}
