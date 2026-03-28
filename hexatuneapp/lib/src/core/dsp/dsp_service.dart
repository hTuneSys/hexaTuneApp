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

/// Manages the DSP engine lifecycle and multi-layer audio rendering.
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
  final double _carrierFreq = DspConstants.carrierFrequency;
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

  bool _isRendering = false;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _baseLoaded = false;

  // --- Reactive state ---
  final _stateController = StreamController<DspState>.broadcast();
  DspState _currentState = const DspState();

  /// Current state snapshot.
  DspState get currentState => _currentState;

  /// State changes as a broadcast stream.
  Stream<DspState> get state => _stateController.stream;

  bool get isRendering => _isRendering;
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
      isRendering: _isRendering,
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
      if (!_stateController.isClosed) {
        _stateController.add(newState);
      }
    }
  }

  /// Update binaural config without reinitializing the engine.
  ///
  /// The carrier frequency is fixed at [DspConstants.carrierFrequency] (220 Hz)
  /// and cannot be changed.
  ///
  /// Returns `true` if the engine config was updated, `false` if only local
  /// state was updated (engine not yet initialized).
  bool updateBinauralConfig({
    bool? binauralEnabled,
    List<CycleStep>? cycleSteps,
  }) {
    if (binauralEnabled != null) _binaural = binauralEnabled;
    if (cycleSteps != null) _steps = List.from(cycleSteps);

    if (_isInitialized && _engine != null && _engine != nullptr) {
      final config = calloc<HtdEngineConfig>();
      config.ref.carrierFrequency = _carrierFreq;
      config.ref.binauralEnabled = _binaural;
      // Pass current values for all fields so the engine state stays
      // consistent even if the Rust side applies them (the docs say gain
      // fields are ignored by update_config, but passing real values is
      // safer than sentinel -1 which could be mis-applied as zero gain).
      config.ref.sampleRate = DspConstants.sampleRate;
      config.ref.baseGain = _baseGain;
      config.ref.textureGain = _textureGain;
      config.ref.eventGain = _eventGain;
      config.ref.binauralGain = _binauralGain;
      config.ref.masterGain = _masterGain;

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

      final rc = _bindings.htdEngineUpdateConfig(_engine!, config);
      if (items != null) calloc.free(items);
      calloc.free(config);

      _logService.devLog(
        'Config updated (rc=$rc): carrier=$_carrierFreq Hz, '
        'binaural=$_binaural, steps=${_steps.length}, '
        'binGain=$_binauralGain, masterGain=$_masterGain'
        '${_steps.isNotEmpty ? ", step0: delta=${_steps[0].frequencyDelta}Hz dur=${_steps[0].durationSeconds}s" : ""}',
        category: LogCategory.dsp,
      );
    }
    _emitState();
    return _isInitialized && _engine != null && _engine != nullptr;
  }

  /// Ensure the DSP engine is initialized (lazy init).
  ///
  /// Returns `null` on success, or an error string on failure.
  Future<String?> ensureInitialized() async {
    if (_isInitialized && _engine != null && _engine != nullptr) {
      return null;
    }

    if (_isInitializing) {
      _logService.devLog(
        'ensureInitialized() already in progress, waiting',
        category: LogCategory.dsp,
      );
      while (_isInitializing) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      return _isInitialized ? null : 'Initialization failed concurrently';
    }

    _isInitializing = true;
    try {
      return await _doInitialize();
    } finally {
      _isInitializing = false;
    }
  }

  Future<String?> _doInitialize() async {
    _logService.info(
      'Initializing DSP engine: carrier=$_carrierFreq Hz, '
      'binaural=$_binaural, steps=${_steps.length}, '
      'gains=[base=$_baseGain tex=$_textureGain evt=$_eventGain '
      'bin=$_binauralGain master=$_masterGain]',
      category: LogCategory.dsp,
    );

    _bindings.init();
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
      // Free allocated memory on init failure
      if (_config != null) {
        calloc.free(_config!);
        _config = null;
      }
      if (_cycleItems != null) {
        calloc.free(_cycleItems!);
        _cycleItems = null;
      }
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
    if (assetPath.isEmpty) return HtdError.invalidConfig.code;
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog('Loading base: $assetPath', category: LogCategory.dsp);
    try {
      final rc = await _channel.invokeMethod<int>('loadBase', {
        'assetPath': assetPath,
        'enginePtr': _engine!.address,
      });
      _logService.devLog('loadBase -> $rc', category: LogCategory.dsp);
      if (rc == 0) _baseLoaded = true;
      _emitState();
      return rc ?? HtdError.loadFailed.code;
    } on PlatformException catch (e) {
      _logService.error(
        'loadBase platform error: ${e.message}',
        category: LogCategory.dsp,
      );
      return HtdError.loadFailed.code;
    }
  }

  /// Load a texture layer at [index] (0–2). Requires base loaded.
  Future<int> loadTexture(int index, String assetPath) async {
    if (assetPath.isEmpty) return HtdError.invalidConfig.code;
    if (!_baseLoaded) return HtdError.baseRequired.code;
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog(
      'Loading texture[$index]: $assetPath',
      category: LogCategory.dsp,
    );
    try {
      final rc = await _channel.invokeMethod<int>('loadTexture', {
        'assetPath': assetPath,
        'enginePtr': _engine!.address,
        'index': index,
      });
      _logService.devLog(
        'loadTexture[$index] -> $rc',
        category: LogCategory.dsp,
      );
      return rc ?? HtdError.loadFailed.code;
    } on PlatformException catch (e) {
      _logService.error(
        'loadTexture[$index] platform error: ${e.message}',
        category: LogCategory.dsp,
      );
      return HtdError.loadFailed.code;
    }
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
    if (assetPath.isEmpty) return HtdError.invalidConfig.code;
    if (!_baseLoaded) return HtdError.baseRequired.code;
    final initErr = await ensureInitialized();
    if (initErr != null) return HtdError.initFailed.code;

    _logService.devLog(
      'Loading event[$index]: $assetPath',
      category: LogCategory.dsp,
    );
    try {
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
    } on PlatformException catch (e) {
      _logService.error(
        'loadEvent[$index] platform error: ${e.message}',
        category: LogCategory.dsp,
      );
      return HtdError.loadFailed.code;
    }
  }

  // ---------------------------------------------------------------------------
  // Layer clearing
  // ---------------------------------------------------------------------------

  /// Clear the base layer. DSP engine cascades to clear all textures/events.
  /// Also frees the decode cache since all layers become invalid.
  Future<bool> clearBase() async {
    final hadBase = _baseLoaded;
    if (!_isInitialized || _engine == null || _engine == nullptr) return false;
    _baseLoaded = false;
    try {
      await _channel.invokeMethod('clearBase', {'enginePtr': _engine!.address});
    } on PlatformException catch (e) {
      _logService.error(
        'clearBase platform error: ${e.message}',
        category: LogCategory.dsp,
      );
    }
    await clearDecodeCache();
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
    try {
      await _channel.invokeMethod('clearTexture', {
        'enginePtr': _engine!.address,
        'index': index,
      });
    } on PlatformException catch (e) {
      _logService.error(
        'clearTexture[$index] platform error: ${e.message}',
        category: LogCategory.dsp,
      );
    }
    _logService.devLog('Texture[$index] cleared', category: LogCategory.dsp);
  }

  /// Clear an event at [index].
  Future<void> clearEvent(int index) async {
    if (!_isInitialized || _engine == null || _engine == nullptr) return;
    try {
      await _channel.invokeMethod('clearEvent', {
        'enginePtr': _engine!.address,
        'index': index,
      });
    } on PlatformException catch (e) {
      _logService.error(
        'clearEvent[$index] platform error: ${e.message}',
        category: LogCategory.dsp,
      );
    }
    _logService.devLog('Event[$index] cleared', category: LogCategory.dsp);
  }

  /// Clear all layers (binaural unaffected). Also frees the decode cache.
  Future<void> clearAllLayers() async {
    if (!_isInitialized || _engine == null || _engine == nullptr) return;
    try {
      await _channel.invokeMethod('clearAllLayers', {
        'enginePtr': _engine!.address,
      });
    } on PlatformException catch (e) {
      _logService.error(
        'clearAllLayers platform error: ${e.message}',
        category: LogCategory.dsp,
      );
    }
    _baseLoaded = false;
    await clearDecodeCache();
    _logService.devLog('All layers cleared', category: LogCategory.dsp);
  }

  /// Clear the native decode cache to free memory.
  Future<int> clearDecodeCache() async {
    try {
      final count = await _channel.invokeMethod<int>('clearDecodeCache');
      _logService.devLog(
        'Decode cache cleared ($count entries)',
        category: LogCategory.dsp,
      );
      return count ?? 0;
    } on PlatformException catch (e) {
      _logService.error(
        'clearDecodeCache platform error: ${e.message}',
        category: LogCategory.dsp,
      );
      return 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Start / Stop
  // ---------------------------------------------------------------------------

  // --- Concurrency guard for stop ---
  bool _stopping = false;

  /// Start audio rendering. Engine must be initialized and layers pre-loaded.
  Future<String?> start() async {
    final initErr = await ensureInitialized();
    if (initErr != null) return initErr;

    _logService.info(
      'Starting DSP engine: binaural=$_binaural, '
      'steps=${_steps.length}, binGain=$_binauralGain, '
      'baseLoaded=$_baseLoaded',
      category: LogCategory.dsp,
    );
    final result = _bindings.htdEngineStart(_engine!);
    if (result != 0) {
      final error = HtdError.fromCode(result);
      return 'Engine start failed: ${error.description} (code: $result)';
    }

    // Verify the engine is running
    final running = _bindings.htdEngineIsRunning(_engine!);
    _logService.devLog(
      'htdEngineStart returned 0, isRunning=$running',
      category: LogCategory.dsp,
    );

    try {
      await _channel.invokeMethod('startAudio', {
        'sampleRate': DspConstants.sampleRate.toInt(),
        'enginePtr': _engine!.address,
      });
    } on PlatformException catch (e) {
      // Rollback: native engine started but platform layer failed
      if (_engine != null && _engine != nullptr) {
        _bindings.htdEngineStop(_engine!);
      }
      _logService.error(
        'startAudio platform error: ${e.message}',
        category: LogCategory.dsp,
      );
      return 'startAudio platform error: ${e.message}';
    }

    _isRendering = true;
    _startTime = DateTime.now();
    _startLogTimer();
    _logService.info('DSP engine rendering', category: LogCategory.dsp);
    _emitState();
    return null;
  }

  /// Stop audio rendering immediately.
  Future<void> stop() async {
    if (!_isRendering || _stopping) return;
    _stopping = true;
    try {
      _logTimer?.cancel();
      _logTimer = null;

      final elapsed = _startTime != null
          ? DateTime.now().difference(_startTime!).inMilliseconds / 1000.0
          : 0.0;
      _logService.info(
        'Stopping DSP (harmonized ${elapsed.toStringAsFixed(1)}s)',
        category: LogCategory.dsp,
      );

      try {
        await _channel.invokeMethod('stopAudio');
      } on PlatformException catch (e) {
        _logService.error(
          'stopAudio platform error: ${e.message}',
          category: LogCategory.dsp,
        );
      }
      if (_engine != null && _engine != nullptr) {
        _bindings.htdEngineStop(_engine!);
      }

      _isRendering = false;
      _startTime = null;
      _emitState();
    } finally {
      _stopping = false;
    }
  }

  /// Graceful stop: finish current cycle iteration, then stop automatically.
  Future<void> stopGraceful() async {
    if (!_isRendering || _stopping) return;
    if (_engine == null || _engine == nullptr) return;
    _stopping = true;
    try {
      _logService.info('Graceful stop requested', category: LogCategory.dsp);
      _bindings.htdEngineStopGraceful(_engine!);

      const maxAttempts = 300; // 30 seconds max
      var attempts = 0;
      while (_bindings.htdEngineIsRunning(_engine!) == 1 &&
          attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
      if (attempts >= maxAttempts) {
        _logService.warning(
          'Graceful stop timed out after 30s, forcing stop',
          category: LogCategory.dsp,
        );
        _bindings.htdEngineStop(_engine!);
      }

      _logTimer?.cancel();
      _logTimer = null;

      final elapsed = _startTime != null
          ? DateTime.now().difference(_startTime!).inMilliseconds / 1000.0
          : 0.0;
      _logService.info(
        'Graceful stop complete (harmonized ${elapsed.toStringAsFixed(1)}s)',
        category: LogCategory.dsp,
      );

      try {
        await _channel.invokeMethod('stopAudio');
      } on PlatformException catch (e) {
        _logService.error(
          'stopAudio platform error: ${e.message}',
          category: LogCategory.dsp,
        );
      }

      _isRendering = false;
      _startTime = null;
      _emitState();
    } finally {
      _stopping = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Gain setters (thread-safe, via Dart FFI directly)
  // ---------------------------------------------------------------------------

  void setBaseGain(double gain) {
    final clamped = gain.clamp(0.0, 1.0);
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetBaseGain(_engine!, clamped);
    }
    _baseGain = clamped;
    _emitState();
  }

  void setTextureGain(double gain) {
    final clamped = gain.clamp(0.0, 1.0);
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetTextureGain(_engine!, clamped);
    }
    _textureGain = clamped;
    _emitState();
  }

  void setEventGain(double gain) {
    final clamped = gain.clamp(0.0, 1.0);
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetEventGain(_engine!, clamped);
    }
    _eventGain = clamped;
    _emitState();
  }

  void setBinauralGain(double gain) {
    final clamped = gain.clamp(0.0, 1.0);
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetBinauralGain(_engine!, clamped);
    }
    _binauralGain = clamped;
    _emitState();
  }

  void setMasterGain(double gain) {
    final clamped = gain.clamp(0.0, 1.0);
    if (_isInitialized && _engine != null && _engine != nullptr) {
      _bindings.htdEngineSetMasterGain(_engine!, clamped);
    }
    _masterGain = clamped;
    _emitState();
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  void _disposeEngine() {
    _logTimer?.cancel();
    _logTimer = null;
    _isRendering = false;
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
    // Fire-and-forget: clear decode cache to free Java-side memory.
    // Cannot await in synchronous dispose, but the platform channel
    // will still process the call.
    clearDecodeCache();
    _stateController.close();
    _logService.devLog('DspService disposed', category: LogCategory.dsp);
  }

  // ---------------------------------------------------------------------------
  // Status logging
  // ---------------------------------------------------------------------------

  void _startLogTimer() {
    _logTimer?.cancel();
    _logTimer = Timer.periodic(DspConstants.logInterval, (_) {
      if (!_isRendering || _startTime == null) return;
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
    if (_steps.isEmpty) return (-1, 0.0, 0.0);

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
