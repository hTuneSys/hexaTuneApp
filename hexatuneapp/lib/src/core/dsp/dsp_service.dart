// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_bindings.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';
import 'package:hexatuneapp/src/core/dsp/models/dsp_state.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Manages the DSP engine lifecycle and multi-layer audio playback.
///
/// Supports pre-loading: the engine is initialized lazily on the first layer
/// selection; layers are loaded in the background. [start] simply starts the
/// already-loaded engine.
@singleton
class DspService {
  DspService(this._bindings, this._logService);

  final DspBindings _bindings;
  final LogService _logService;

  static const _channel = MethodChannel(DspConstants.methodChannelName);

  // --- Native pointers ---
  Pointer<HtdEngine>? _engine;
  Pointer<HtdEngineConfig>? _config;
  Pointer<HtdCycleItem>? _cycleItems;

  // --- Internal state ---
  Timer? _logTimer;
  DateTime? _startTime;

  // Current configuration state
  double _carrierFreq = DspConstants.defaultCarrierFrequency;
  bool _binaural = true;
  List<CycleStep> _steps = [
    const CycleStep(
      frequencyDelta: DspConstants.defaultFrequencyDelta,
      durationSeconds: DspConstants.defaultCycleDuration,
    ),
  ];
  double _baseGain = DspConstants.defaultBaseGain;
  double _textureGain = DspConstants.defaultTextureGain;
  double _eventGain = DspConstants.defaultEventGain;
  double _binauralGain = DspConstants.defaultBinauralGain;
  double _masterGain = DspConstants.defaultMasterGain;

  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _baseLoaded = false;

  // --- Reactive state ---
  final _stateController = StreamController<DspState>.broadcast();
  DspState _currentState = const DspState();

  /// Current state snapshot.
  DspState get currentState => _currentState;

  /// State changes as a broadcast stream.
  Stream<DspState> get state => _stateController.stream;

  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;
  bool get isBaseLoaded => _baseLoaded;
  int get engineAddress => _engine?.address ?? 0;
  double get baseGain => _baseGain;
  double get textureGain => _textureGain;
  double get eventGain => _eventGain;
  double get binauralGain => _binauralGain;
  double get masterGain => _masterGain;

  void _emitState() {
    final newState = DspState(
      isInitialized: _isInitialized,
      isPlaying: _isPlaying,
      isBaseLoaded: _baseLoaded,
      carrierFrequency: _carrierFreq,
      binauralEnabled: _binaural,
      baseGain: _baseGain,
      textureGain: _textureGain,
      eventGain: _eventGain,
      binauralGain: _binauralGain,
      masterGain: _masterGain,
    );
    if (_currentState != newState) {
      _currentState = newState;
      _stateController.add(newState);
    }
  }

  /// Update binaural config without reinitializing the engine.
  void updateBinauralConfig({
    double? carrierFrequency,
    bool? binauralEnabled,
    List<CycleStep>? cycleSteps,
  }) {
    if (carrierFrequency != null) _carrierFreq = carrierFrequency;
    if (binauralEnabled != null) _binaural = binauralEnabled;
    if (cycleSteps != null) _steps = List.from(cycleSteps);

    if (_isInitialized && _engine != null && _engine != nullptr) {
      final config = calloc<HtdEngineConfig>();
      config.ref.carrierFrequency = _carrierFreq;
      config.ref.binauralEnabled = _binaural;
      config.ref.sampleRate = 0;
      config.ref.baseGain = -1;
      config.ref.textureGain = -1;
      config.ref.eventGain = -1;
      config.ref.binauralGain = -1;
      config.ref.masterGain = -1;

      Pointer<HtdCycleItem>? items;
      if (_steps.isNotEmpty) {
        items = calloc<HtdCycleItem>(_steps.length);
        for (var i = 0; i < _steps.length; i++) {
          items[i].frequencyDelta = _steps[i].frequencyDelta;
          items[i].durationSeconds = _steps[i].durationSeconds;
          items[i].oneshot = _steps[i].oneshot;
        }
        config.ref.cycleItems = items;
        config.ref.cycleCount = _steps.length;
      } else {
        config.ref.cycleItems = nullptr;
        config.ref.cycleCount = 0;
      }

      _bindings.htdEngineUpdateConfig(_engine!, config);
      if (items != null) calloc.free(items);
      calloc.free(config);

      _logService.devLog(
        'Config updated: carrier=$_carrierFreq Hz, '
        'binaural=$_binaural, steps=${_steps.length}',
        category: LogCategory.dsp,
      );
    }
    _emitState();
  }

  /// Ensure the DSP engine is initialized (lazy init).
  ///
  /// Returns `null` on success, or an error string on failure.
  Future<String?> ensureInitialized() async {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      return null;
    }

    _logService.info(
      'Initializing DSP engine: carrier=$_carrierFreq Hz, '
      'binaural=$_binaural, steps=${_steps.length}',
      category: LogCategory.dsp,
    );

    _disposeEngine();

    final cycleCount = _steps.length;
    _cycleItems = calloc<HtdCycleItem>(cycleCount == 0 ? 1 : cycleCount);
    for (var i = 0; i < cycleCount; i++) {
      _cycleItems![i].frequencyDelta = _steps[i].frequencyDelta;
      _cycleItems![i].durationSeconds = _steps[i].durationSeconds;
      _cycleItems![i].oneshot = _steps[i].oneshot;
    }

    _config = calloc<HtdEngineConfig>();
    _config!.ref.carrierFrequency = _carrierFreq;
    _config!.ref.binauralEnabled = _binaural;
    _config!.ref.cycleItems = cycleCount > 0 ? _cycleItems! : nullptr;
    _config!.ref.cycleCount = cycleCount;
    _config!.ref.sampleRate = DspConstants.sampleRate;
    _config!.ref.baseGain = _baseGain;
    _config!.ref.textureGain = _textureGain;
    _config!.ref.eventGain = _eventGain;
    _config!.ref.binauralGain = _binauralGain;
    _config!.ref.masterGain = _masterGain;

    final errorPtr = calloc<Int32>();
    _engine = _bindings.htdEngineInit(_config!, errorPtr);
    final errorCode = errorPtr.value;
    calloc.free(errorPtr);

    if (_engine == null || _engine == nullptr) {
      final error = HtdError.fromCode(errorCode);
      _logService.error(
        'Engine init failed: ${error.description} (code: $errorCode)',
        category: LogCategory.dsp,
      );
      _emitState();
      return 'Engine init failed: ${error.description} (code: $errorCode)';
    }

    _isInitialized = true;
    _logService.info(
      'Engine initialized at 0x${_engine!.address.toRadixString(16)}',
      category: LogCategory.dsp,
    );
    _emitState();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Layer loading
  // ---------------------------------------------------------------------------

  /// Load a base layer from an asset path. Initializes engine if needed.
  Future<int> loadBase(String assetPath) async {
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog('Loading base: $assetPath', category: LogCategory.dsp);
    final rc = await _channel.invokeMethod<int>('loadBase', {
      'assetPath': assetPath,
      'enginePtr': _engine!.address,
    });
    _logService.devLog('loadBase -> $rc', category: LogCategory.dsp);
    if (rc == 0) _baseLoaded = true;
    _emitState();
    return rc ?? HtdError.loadFailed.code;
  }

  /// Load a texture layer at [index] (0–2). Requires base loaded.
  Future<int> loadTexture(int index, String assetPath) async {
    if (!_baseLoaded) return HtdError.baseRequired.code;
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog(
      'Loading texture[$index]: $assetPath',
      category: LogCategory.dsp,
    );
    final rc = await _channel.invokeMethod<int>('loadTexture', {
      'assetPath': assetPath,
      'enginePtr': _engine!.address,
      'index': index,
    });
    _logService.devLog('loadTexture[$index] -> $rc', category: LogCategory.dsp);
    return rc ?? HtdError.loadFailed.code;
  }

  /// Load an event at [index] (0–4). Requires base loaded.
  Future<int> loadEvent(
    int index,
    String assetPath, {
    int minIntervalMs = DspConstants.defaultEventMinIntervalMs,
    int maxIntervalMs = DspConstants.defaultEventMaxIntervalMs,
    double volumeMin = DspConstants.defaultEventVolumeMin,
    double volumeMax = DspConstants.defaultEventVolumeMax,
    double panMin = DspConstants.defaultEventPanMin,
    double panMax = DspConstants.defaultEventPanMax,
  }) async {
    if (!_baseLoaded) return HtdError.baseRequired.code;
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog(
      'Loading event[$index]: $assetPath',
      category: LogCategory.dsp,
    );
    final rc = await _channel.invokeMethod<int>('loadEvent', {
      'assetPath': assetPath,
      'enginePtr': _engine!.address,
      'index': index,
      'minIntervalMs': minIntervalMs,
      'maxIntervalMs': maxIntervalMs,
      'volumeMin': volumeMin,
      'volumeMax': volumeMax,
      'panMin': panMin,
      'panMax': panMax,
    });
    _logService.devLog('loadEvent[$index] -> $rc', category: LogCategory.dsp);
    return rc ?? HtdError.loadFailed.code;
  }

  // ---------------------------------------------------------------------------
  // Layer clearing
  // ---------------------------------------------------------------------------

  /// Clear the base layer. DSP engine cascades to clear all textures/events.
  Future<bool> clearBase() async {
    final hadBase = _baseLoaded;
    _baseLoaded = false;
    if (!_isInitialized || _engine == null || _engine == nullptr) return false;
    await _channel.invokeMethod('clearBase', {'enginePtr': _engine!.address});
    _logService.devLog(
      'Base cleared${hadBase ? ' (cascade: textures+events)' : ''}',
      category: LogCategory.dsp,
    );
    _emitState();
    return hadBase;
  }

  /// Clear a texture layer at [index].
  Future<void> clearTexture(int index) async {
    if (!_isInitialized || _engine == null || _engine == nullptr) return;
    await _channel.invokeMethod('clearTexture', {
      'enginePtr': _engine!.address,
      'index': index,
    });
    _logService.devLog('Texture[$index] cleared', category: LogCategory.dsp);
  }

  /// Clear an event at [index].
  Future<void> clearEvent(int index) async {
    if (!_isInitialized || _engine == null || _engine == nullptr) return;
    await _channel.invokeMethod('clearEvent', {
      'enginePtr': _engine!.address,
      'index': index,
    });
    _logService.devLog('Event[$index] cleared', category: LogCategory.dsp);
  }

  /// Clear all layers (binaural unaffected).
  Future<void> clearAllLayers() async {
    if (!_isInitialized || _engine == null || _engine == nullptr) return;
    await _channel.invokeMethod('clearAllLayers', {
      'enginePtr': _engine!.address,
    });
    _logService.devLog('All layers cleared', category: LogCategory.dsp);
  }

  /// Clear the native decode cache to free memory.
  Future<int> clearDecodeCache() async {
    final count = await _channel.invokeMethod<int>('clearDecodeCache');
    _logService.devLog(
      'Decode cache cleared ($count entries)',
      category: LogCategory.dsp,
    );
    return count ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Start / Stop
  // ---------------------------------------------------------------------------

  /// Start audio playback. Engine must be initialized and layers pre-loaded.
  Future<String?> start() async {
    final initErr = await ensureInitialized();
    if (initErr != null) return initErr;

    _logService.info('Starting DSP engine', category: LogCategory.dsp);
    final result = _bindings.htdEngineStart(_engine!);
    if (result != 0) {
      final error = HtdError.fromCode(result);
      return 'Engine start failed: ${error.description} (code: $result)';
    }

    await _channel.invokeMethod('startAudio', {
      'sampleRate': DspConstants.sampleRate.toInt(),
      'enginePtr': _engine!.address,
    });

    _isPlaying = true;
    _startTime = DateTime.now();
    _startLogTimer();
    _logService.info('DSP engine playing', category: LogCategory.dsp);
    _emitState();
    return null;
  }

  /// Stop audio playback immediately.
  Future<void> stop() async {
    if (!_isPlaying) return;

    _logTimer?.cancel();
    _logTimer = null;

    final elapsed = _startTime != null
        ? DateTime.now().difference(_startTime!).inMilliseconds / 1000.0
        : 0.0;
    _logService.info(
      'Stopping DSP (played ${elapsed.toStringAsFixed(1)}s)',
      category: LogCategory.dsp,
    );

    await _channel.invokeMethod('stopAudio');
    if (_engine != null && _engine != nullptr) {
      _bindings.htdEngineStop(_engine!);
    }

    _isPlaying = false;
    _startTime = null;
    _emitState();
  }

  /// Graceful stop: finish current cycle iteration, then stop automatically.
  Future<void> stopGraceful() async {
    if (!_isPlaying) return;
    if (_engine == null || _engine == nullptr) return;

    _logService.info('Graceful stop requested', category: LogCategory.dsp);
    _bindings.htdEngineStopGraceful(_engine!);

    while (_bindings.htdEngineIsRunning(_engine!) == 1) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _logTimer?.cancel();
    _logTimer = null;

    final elapsed = _startTime != null
        ? DateTime.now().difference(_startTime!).inMilliseconds / 1000.0
        : 0.0;
    _logService.info(
      'Graceful stop complete (played ${elapsed.toStringAsFixed(1)}s)',
      category: LogCategory.dsp,
    );

    await _channel.invokeMethod('stopAudio');

    _isPlaying = false;
    _startTime = null;
    _emitState();
  }

  // ---------------------------------------------------------------------------
  // Gain setters (thread-safe, via Dart FFI directly)
  // ---------------------------------------------------------------------------

  void setBaseGain(double gain) {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetBaseGain(_engine!, gain);
    }
    _baseGain = gain;
    _emitState();
  }

  void setTextureGain(double gain) {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetTextureGain(_engine!, gain);
    }
    _textureGain = gain;
    _emitState();
  }

  void setEventGain(double gain) {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetEventGain(_engine!, gain);
    }
    _eventGain = gain;
    _emitState();
  }

  void setBinauralGain(double gain) {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetBinauralGain(_engine!, gain);
    }
    _binauralGain = gain;
    _emitState();
  }

  void setMasterGain(double gain) {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetMasterGain(_engine!, gain);
    }
    _masterGain = gain;
    _emitState();
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  void _disposeEngine() {
    _logTimer?.cancel();
    _logTimer = null;
    _isPlaying = false;
    _isInitialized = false;
    _baseLoaded = false;
    _startTime = null;

    if (_engine != null && _engine != nullptr) {
      _logService.devLog('Destroying engine', category: LogCategory.dsp);
      _bindings.htdEngineStop(_engine!);
      _bindings.htdEngineDestroy(_engine!);
      _engine = null;
    }
    if (_config != null) {
      calloc.free(_config!);
      _config = null;
    }
    if (_cycleItems != null) {
      calloc.free(_cycleItems!);
      _cycleItems = null;
    }
  }

  @disposeMethod
  void dispose() {
    _disposeEngine();
    _stateController.close();
    _logService.devLog('DspService disposed', category: LogCategory.dsp);
  }

  // ---------------------------------------------------------------------------
  // Status logging
  // ---------------------------------------------------------------------------

  void _startLogTimer() {
    _logTimer?.cancel();
    _logTimer = Timer.periodic(DspConstants.logInterval, (_) {
      if (!_isPlaying || _startTime == null) return;
      final elapsed =
          DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
      final cycleInfo = _computeCycleState(elapsed);

      _logService.devLog(
        'State [${elapsed.toStringAsFixed(1)}s] '
        'mode=${_binaural ? "BINAURAL" : "AM"} '
        'carrier=$_carrierFreq Hz '
        'cycle=[${cycleInfo.$1}/${_steps.length}] '
        'delta=${cycleInfo.$2.toStringAsFixed(2)} Hz '
        '(${cycleInfo.$3.toStringAsFixed(1)}s left) '
        'gains: base=$_baseGain tex=$_textureGain evt=$_eventGain '
        'bin=$_binauralGain master=$_masterGain',
        category: LogCategory.dsp,
      );
    });
  }

  /// Returns `(stepIndex, delta, remainingSeconds)` for the current cycle.
  (int, double, double) _computeCycleState(double elapsedSec) {
    if (_steps.isEmpty) return (0, 0.0, 0.0);

    var totalCycleDur = 0.0;
    for (final s in _steps) {
      totalCycleDur += s.durationSeconds;
    }
    final pos = elapsedSec % totalCycleDur;
    var cumulative = 0.0;
    for (var i = 0; i < _steps.length; i++) {
      cumulative += _steps[i].durationSeconds;
      if (pos < cumulative) {
        return (i, _steps[i].frequencyDelta, cumulative - pos);
      }
    }
    return (_steps.length - 1, _steps.last.frequencyDelta, 0.0);
  }
}
