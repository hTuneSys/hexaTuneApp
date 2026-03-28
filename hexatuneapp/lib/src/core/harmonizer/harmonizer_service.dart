// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
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
class HarmonizerService with WidgetsBindingObserver {
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
  DateTime? _harmonizeStartTime;
  int? _magneticOperationId;
  bool _magneticLooping = false;
  bool _backendStopped = false;
  DateTime? _stopCountdownTarget;

  /// Whether the last harmonize session completed successfully (`null` = none).
  bool? _lastCompletionSuccess;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Whether the last harmonize session completed successfully (`null` = none).
  ///
  /// Read by the global snackbar listener after the idle transition, then
  /// cleared via [clearCompletionResult].
  bool? get lastCompletionSuccess => _lastCompletionSuccess;

  /// Clears the completion flag so the snackbar is only shown once.
  void clearCompletionResult() => _lastCompletionSuccess = null;

  /// Registers as an app lifecycle observer.
  ///
  /// Call once from DI setup (e.g. `app_root.dart`) after
  /// `WidgetsFlutterBinding.ensureInitialized()`.
  void initLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onForegroundResume();
    }
  }

  /// Broadcast stream of harmonizer state changes.
  Stream<HarmonizerState> get state => _stateController.stream;

  /// Current state snapshot.
  HarmonizerState get currentState => _currentState;

  /// Whether the harmonizer is actively harmonizing.
  bool get isHarmonizing =>
      _currentState.status == HarmonizerStatus.harmonizing;

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

  /// Starts harmonizing with the given [config].
  ///
  /// Returns `null` on success, or an error message string on failure.
  Future<String?> harmonize(HarmonizerConfig config) async {
    if (_currentState.status == HarmonizerStatus.harmonizing ||
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
      'Harmonizer harmonize: type=${config.type.name}, '
      'steps=${config.steps.length}, ambience=${config.ambienceId ?? "none"}, '
      'repeat=${config.repeatCount ?? "infinite"}',
      category: LogCategory.dsp,
    );

    _updateState(
      _currentState.copyWith(
        activeType: config.type,
        status: HarmonizerStatus.preparing,
        sequence: config.steps,
        ambienceId: config.ambienceId,
        formulaId: config.formulaId,
        currentCycle: 0,
        currentStepIndex: 0,
        errorMessage: null,
        gracefulStopRequested: false,
        repeatCount: config.repeatCount,
      ),
    );

    // Compute cycle durations.
    final firstDur = _computeCycleDuration(config.steps, includeOneShots: true);
    final loopDur = _computeCycleDuration(config.steps, includeOneShots: false);

    // Compute total duration across all repeat cycles (null for infinite).
    final Duration? totalRepeat;
    if (config.repeatCount != null) {
      final repeatMs =
          firstDur.inMilliseconds +
          (loopDur.inMilliseconds * (config.repeatCount! - 1));
      totalRepeat = Duration(milliseconds: repeatMs);
    } else {
      totalRepeat = null;
    }

    _updateState(
      _currentState.copyWith(
        totalCycleDuration: loopDur,
        firstCycleDuration: firstDur,
        remainingInCycle: firstDur,
        isFirstCycle: true,
        totalRepeatDuration: totalRepeat,
        totalRemaining: totalRepeat,
      ),
    );

    try {
      if (config.type.usesDsp) {
        await _startDspHarmonizing(config);
      } else if (config.type == GenerationType.magnetic) {
        await _startMagneticHarmonizing(config);
      }

      _harmonizeStartTime = DateTime.now();
      _startTimeTracker();

      _updateState(
        _currentState.copyWith(status: HarmonizerStatus.harmonizing),
      );

      return null;
    } catch (e, st) {
      _logService.error(
        'Harmonizer start failed: $e',
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

  /// Requests a graceful stop.
  ///
  /// For DSP modes (monaural / binaural) the remaining countdown continues to
  /// zero before the harmonizer transitions to idle.
  /// For magnetic mode the timer stops immediately, the button enters loading
  /// state, and a STOP GRACEFUL command is sent to the device.
  Future<void> stopGraceful() async {
    if (_currentState.status != HarmonizerStatus.harmonizing) return;

    _logService.info(
      'Harmonizer graceful stop requested',
      category: LogCategory.dsp,
    );

    final isMagnetic = _currentState.activeType == GenerationType.magnetic;

    if (isMagnetic) {
      _timeTracker?.cancel();
      _timeTracker = null;
      _backendStopped = false;

      _updateState(
        _currentState.copyWith(
          status: HarmonizerStatus.stopping,
          gracefulStopRequested: true,
          remainingInCycle: Duration.zero,
          totalRemaining: Duration.zero,
        ),
      );

      unawaited(_performBackendStop());
      return;
    }

    // DSP modes: let the countdown continue to zero.
    final remaining = _currentState.remainingInCycle;
    _stopCountdownTarget = DateTime.now().add(remaining);
    _backendStopped = false;

    _updateState(
      _currentState.copyWith(
        status: HarmonizerStatus.stopping,
        gracefulStopRequested: true,
      ),
    );

    // Fire back-end stop without blocking the timer.
    unawaited(_performBackendStop());
  }

  /// Stops the back-end (DSP / HexaGen) asynchronously.
  ///
  /// Sets [_backendStopped] to `true` once done so the time-tracker knows
  /// it is safe to finalize cleanup.
  Future<void> _performBackendStop() async {
    try {
      final type = _currentState.activeType;
      if (type != null && type.usesDsp) {
        await _dspService.stopGraceful();
      } else if (type == GenerationType.magnetic) {
        await _stopMagnetic();
      }
    } catch (e, st) {
      _logService.error(
        'Backend stop error: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
    }
    _backendStopped = true;

    // If the timer already reached zero while we were stopping, clean up now.
    if (_currentState.status == HarmonizerStatus.stopping &&
        _currentState.remainingInCycle <= Duration.zero) {
      _cleanup();
    }
  }

  /// Immediately stops all rendering without waiting for cycle completion.
  Future<void> stopImmediate() async {
    if (_currentState.status != HarmonizerStatus.harmonizing &&
        _currentState.status != HarmonizerStatus.stopping) {
      return;
    }

    _logService.info('Harmonizer immediate stop', category: LogCategory.dsp);

    try {
      final type = _currentState.activeType;
      if (type != null && type.usesDsp) {
        await _dspService.stop();
      } else if (type == GenerationType.magnetic) {
        await _stopMagnetic(immediate: true);
      }
    } finally {
      _cleanup();
    }
  }

  /// Cleans up resources.
  @disposeMethod
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeTracker?.cancel();
    _magneticLooping = false;
    _backendStopped = false;
    _stopCountdownTarget = null;
    _stateController.close();
    _logService.devLog('HarmonizerService disposed', category: LogCategory.dsp);
  }

  // ---------------------------------------------------------------------------
  // DSP Harmonizing
  // ---------------------------------------------------------------------------

  Future<void> _startDspHarmonizing(HarmonizerConfig config) async {
    // Load or clear ambience.
    if (config.ambienceId != null) {
      await _loadAmbience(config.ambienceId!);
    } else {
      await _clearAllAmbienceLayers();
    }

    // Configure binaural mode: carrier fixed at 220 Hz via DspConstants.
    final isBinaural = config.type == GenerationType.binaural;
    final cycleSteps = config.steps.map(_packetToCycleStep).toList();

    _dspService.updateBinauralConfig(
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
    // Ensure the audio asset catalog is available for lookups.
    if (_assetService.allAssets.isEmpty) {
      await _assetService.discover();
    }

    final config = _ambienceService.findById(ambienceId);
    if (config == null) {
      _logService.warning(
        'Ambience $ambienceId not found, skipping',
        category: LogCategory.dsp,
      );
      return;
    }

    // Clear ALL previous layers.
    await _clearAllAmbienceLayers();

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

  /// Clears all ambience layers from DSP memory.
  Future<void> _clearAllAmbienceLayers() async {
    await _dspService.clearBase();
    for (var i = 0; i < 4; i++) {
      await _dspService.clearTexture(i);
      await _dspService.clearEvent(i);
    }
  }

  /// Changes ambience while harmonizing. Pass `null` to remove ambience.
  ///
  /// If the harmonizer is not in a DSP-rendering state (monaural/binaural),
  /// or is not currently harmonizing, this method does nothing.
  Future<void> changeAmbience(String? ambienceId) async {
    final status = _currentState.status;
    if (status != HarmonizerStatus.harmonizing &&
        status != HarmonizerStatus.preparing) {
      return;
    }

    final type = _currentState.activeType;
    if (type == null || !type.supportsDspAmbience) return;

    // Update the state so UI can restore the selection on re-navigation.
    _updateState(_currentState.copyWith(ambienceId: ambienceId));

    if (ambienceId == null) {
      await _clearAllAmbienceLayers();
      _logService.info(
        'Ambience cleared during harmonizing',
        category: LogCategory.dsp,
      );
    } else {
      await _loadAmbience(ambienceId);
    }
  }

  // ---------------------------------------------------------------------------
  // Magnetic Harmonizing
  // ---------------------------------------------------------------------------

  Future<void> _startMagneticHarmonizing(HarmonizerConfig config) async {
    final opId = _hexagenService.generateId();
    _magneticOperationId = opId;
    _magneticLooping = true;

    // Device repeat count: null (infinite in app) → 0 (infinite on device).
    final deviceRepeatCount = config.repeatCount ?? 0;

    // PREPARE with repeat count.
    final prepareStatus = await _hexagenService.sendOperationPrepare(
      opId,
      repeatCount: deviceRepeatCount,
    );
    if (prepareStatus != CommandStatus.success) {
      throw StateError('HexaGen PREPARE failed: ${prepareStatus.name}');
    }

    // Send FREQ commands with isOneShot flag.
    for (final packet in config.steps) {
      if (!_magneticLooping) return;
      final status = await _hexagenService.sendFreqCommandAndWait(
        packet.value,
        packet.durationMs,
        isOneShot: packet.isOneShot,
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
      'Magnetic operation $opId started with ${config.steps.length} steps, '
      'repeat=$deviceRepeatCount',
      category: LogCategory.hardware,
    );
  }

  Future<void> _stopMagnetic({bool immediate = false}) async {
    _magneticLooping = false;
    final opId = _magneticOperationId;
    if (opId != null) {
      if (immediate) {
        await _hexagenService.stopOperationImmediate(opId);
      } else {
        await _hexagenService.stopOperationGraceful(opId);
      }

      final completed = await _hexagenService.waitForOperationComplete(
        timeout: Duration(seconds: immediate ? 5 : 60),
      );

      if (!completed) {
        _logService.warning(
          'Device did not report COMPLETED after stop, sending RESET',
          category: LogCategory.hardware,
        );
        await _hexagenService.sendATCommand(ATCommand.reset(opId));
        _hexagenService.resetOperationState();
        _lastCompletionSuccess = false;
      } else {
        _lastCompletionSuccess = true;
      }
      _magneticOperationId = null;
    }
  }

  // ---------------------------------------------------------------------------
  // Time Tracking
  // ---------------------------------------------------------------------------

  void _startTimeTracker() {
    _backendStopped = false;
    _stopCountdownTarget = null;
    _timeTracker?.cancel();
    _timeTracker = Timer.periodic(const Duration(seconds: 1), (_) {
      final status = _currentState.status;

      // Only run while harmonizing or stopping (countdown to zero).
      if (status != HarmonizerStatus.harmonizing &&
          status != HarmonizerStatus.stopping) {
        _timeTracker?.cancel();
        return;
      }

      // --- Stopping: dedicated countdown to zero ---
      if (status == HarmonizerStatus.stopping) {
        _handleStoppingTick();
        return;
      }

      // --- Harmonizing ---
      final elapsed = _harmonizeStartTime != null
          ? DateTime.now().difference(_harmonizeStartTime!)
          : Duration.zero;

      final cycleDur = _currentState.isFirstCycle
          ? _currentState.firstCycleDuration
          : _currentState.totalCycleDuration;

      if (cycleDur == Duration.zero) return;

      final cycleMs = cycleDur.inMilliseconds;
      final elapsedMs = elapsed.inMilliseconds;

      final isMagnetic = _currentState.activeType == GenerationType.magnetic;

      // Magnetic mode: multi-cycle with optional repeat limit (like DSP).
      if (isMagnetic) {
        final currentCycle = cycleMs > 0 ? elapsedMs ~/ cycleMs : 0;
        final positionInCycle = cycleMs > 0 ? elapsedMs % cycleMs : 0;
        final remaining = Duration(milliseconds: cycleMs - positionInCycle);
        final stepIndex = _computeStepIndex(positionInCycle);
        final isFirst = currentCycle == 0;

        // Auto-stop after completing all repeat cycles.
        final repeat = _currentState.repeatCount;
        if (repeat != null && currentCycle >= repeat) {
          _updateState(
            _currentState.copyWith(
              currentCycle: repeat - 1,
              currentStepIndex: _currentState.sequence.length - 1,
              remainingInCycle: Duration.zero,
              totalRemaining: Duration.zero,
              isFirstCycle: false,
            ),
          );
          _timeTracker?.cancel();
          _timeTracker = null;
          unawaited(_autoStopMagnetic());
          return;
        }

        // Compute total remaining across all cycles.
        final totalRepeat = _currentState.totalRepeatDuration;
        final Duration? totalRem;
        if (totalRepeat != null) {
          final totalRemMs = (totalRepeat.inMilliseconds - elapsedMs).clamp(
            0,
            totalRepeat.inMilliseconds,
          );
          totalRem = Duration(milliseconds: totalRemMs);
        } else {
          totalRem = null;
        }

        _updateState(
          _currentState.copyWith(
            currentCycle: currentCycle,
            currentStepIndex: stepIndex,
            remainingInCycle: remaining,
            totalRemaining: totalRem,
            isFirstCycle: isFirst,
          ),
        );
        return;
      }

      // DSP modes: loop with optional repeat limit.
      final currentCycle = cycleMs > 0 ? elapsedMs ~/ cycleMs : 0;
      final positionInCycle = cycleMs > 0 ? elapsedMs % cycleMs : 0;
      final remaining = Duration(milliseconds: cycleMs - positionInCycle);
      final stepIndex = _computeStepIndex(positionInCycle);
      final isFirst = currentCycle == 0;

      // Auto-stop after completing all repeat cycles.
      final repeat = _currentState.repeatCount;
      if (repeat != null && currentCycle >= repeat) {
        _updateState(
          _currentState.copyWith(
            currentCycle: repeat - 1,
            currentStepIndex: _currentState.sequence.length - 1,
            remainingInCycle: Duration.zero,
            totalRemaining: Duration.zero,
            isFirstCycle: false,
          ),
        );
        _timeTracker?.cancel();
        _timeTracker = null;
        unawaited(_autoStopDsp());
        return;
      }

      // Compute total remaining across all cycles.
      final totalRepeat = _currentState.totalRepeatDuration;
      final Duration? totalRem;
      if (totalRepeat != null) {
        final totalRemMs = (totalRepeat.inMilliseconds - elapsedMs).clamp(
          0,
          totalRepeat.inMilliseconds,
        );
        totalRem = Duration(milliseconds: totalRemMs);
      } else {
        totalRem = null;
      }

      _updateState(
        _currentState.copyWith(
          currentCycle: currentCycle,
          currentStepIndex: stepIndex,
          remainingInCycle: remaining,
          totalRemaining: totalRem,
          isFirstCycle: isFirst,
        ),
      );
    });
  }

  /// Handles a single timer tick while the status is [HarmonizerStatus.stopping].
  ///
  /// Counts down from the captured [_stopCountdownTarget] to zero.
  void _handleStoppingTick() {
    if (_stopCountdownTarget == null) {
      // No target — clean up immediately when the backend is done.
      if (_backendStopped) _cleanup();
      return;
    }

    final remaining = _stopCountdownTarget!.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _updateState(_currentState.copyWith(remainingInCycle: Duration.zero));
      if (_backendStopped) {
        _cleanup();
      }
      // If backend hasn't stopped yet, keep the timer alive;
      // _performBackendStop will call _cleanup when it finishes.
      return;
    }

    _updateState(_currentState.copyWith(remainingInCycle: remaining));
  }

  /// Auto-stop for DSP modes after completing all repeat cycles.
  ///
  /// Transitions to [HarmonizerStatus.stopping], performs backend cleanup,
  /// then returns to idle.
  Future<void> _autoStopDsp() async {
    _logService.info(
      'DSP repeat cycles complete, auto-stopping',
      category: LogCategory.dsp,
    );

    _updateState(
      _currentState.copyWith(
        status: HarmonizerStatus.stopping,
        gracefulStopRequested: true,
        remainingInCycle: Duration.zero,
      ),
    );

    try {
      await _dspService.stop();
    } catch (e, st) {
      _logService.error(
        'DSP auto-stop error: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
    }
    _lastCompletionSuccess = true;
    _cleanup();
  }

  /// Auto-stop for magnetic mode after all repeat cycles complete.
  ///
  /// Transitions to [HarmonizerStatus.stopping], waits for the device to
  /// report COMPLETED (polling every second for up to 60 s), then cleans up.
  /// If the device does not respond in time a fallback RESET is sent.
  Future<void> _autoStopMagnetic() async {
    _logService.info(
      'Magnetic cycles complete, waiting for device COMPLETED',
      category: LogCategory.hardware,
    );

    _updateState(
      _currentState.copyWith(
        status: HarmonizerStatus.stopping,
        gracefulStopRequested: true,
        remainingInCycle: Duration.zero,
        totalRemaining: Duration.zero,
      ),
    );

    try {
      final completed = await _hexagenService.waitForOperationComplete(
        timeout: const Duration(seconds: 60),
      );

      if (!completed) {
        _logService.warning(
          'Device did not report COMPLETED within timeout, sending RESET',
          category: LogCategory.hardware,
        );
        final opId = _magneticOperationId;
        if (opId != null) {
          await _hexagenService.sendATCommand(ATCommand.reset(opId));
          _hexagenService.resetOperationState();
        }
        _lastCompletionSuccess = false;
      } else {
        _lastCompletionSuccess = true;
      }
    } catch (e, st) {
      _logService.error(
        'Magnetic auto-stop error: $e',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: st,
      );
      _lastCompletionSuccess = false;
    }

    _magneticOperationId = null;
    _cleanup();
  }

  int _computeStepIndex(int positionMs) {
    var stepIndex = 0;
    var accumulated = 0;
    final steps = _currentState.sequence;
    for (var i = 0; i < steps.length; i++) {
      final stepMs = steps[i].durationMs;
      if (accumulated + stepMs > positionMs) {
        stepIndex = i;
        break;
      }
      accumulated += stepMs;
      if (i == steps.length - 1) stepIndex = i;
    }
    return stepIndex;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void _onForegroundResume() {
    if (_currentState.activeType != GenerationType.magnetic) return;
    if (_currentState.status != HarmonizerStatus.harmonizing &&
        _currentState.status != HarmonizerStatus.stopping) {
      return;
    }

    // If the timer has expired while the app was in the background, trigger
    // the device completion check now.
    final totalRem = _currentState.totalRemaining;
    if (totalRem != null && totalRem <= Duration.zero) {
      _logService.info(
        'Foreground resume: magnetic timer expired, querying device',
        category: LogCategory.hardware,
      );
      _timeTracker?.cancel();
      _timeTracker = null;
      unawaited(_autoStopMagnetic());
    }
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
    _harmonizeStartTime = null;
    _magneticLooping = false;
    _backendStopped = false;
    _stopCountdownTarget = null;

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
