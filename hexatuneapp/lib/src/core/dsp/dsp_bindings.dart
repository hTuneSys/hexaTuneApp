// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

// ---------------------------------------------------------------------------
// Native struct definitions (mirror hexatune_dsp_ffi.h)
// ---------------------------------------------------------------------------

/// A single cycle item — frequency delta + duration.
final class HtdCycleItem extends Struct {
  @Float()
  external double frequencyDelta;

  @Float()
  external double durationSeconds;

  @Bool()
  external bool oneshot;
}

/// Engine configuration passed to init and update (v0.1.2).
final class HtdEngineConfig extends Struct {
  @Float()
  external double carrierFrequency;

  @Bool()
  external bool binauralEnabled;

  external Pointer<HtdCycleItem> cycleItems;

  @Uint32()
  external int cycleCount;

  @Float()
  external double sampleRate;

  @Float()
  external double baseGain;

  @Float()
  external double textureGain;

  @Float()
  external double eventGain;

  @Float()
  external double binauralGain;

  @Float()
  external double masterGain;
}

/// Audio layer configuration (raw PCM data).
final class HtdLayerConfig extends Struct {
  external Pointer<Float> samples;

  @Uint32()
  external int numFrames;

  @Uint32()
  external int channels;
}

/// Random event configuration.
final class HtdEventConfig extends Struct {
  external Pointer<Float> samples;

  @Uint32()
  external int numFrames;

  @Uint32()
  external int channels;

  @Uint32()
  external int minIntervalMs;

  @Uint32()
  external int maxIntervalMs;

  @Float()
  external double volumeMin;

  @Float()
  external double volumeMax;

  @Float()
  external double panMin;

  @Float()
  external double panMax;
}

/// Opaque engine handle.
final class HtdEngine extends Opaque {}

// ---------------------------------------------------------------------------
// Native ↔ Dart function typedefs
// ---------------------------------------------------------------------------

// Lifecycle
typedef _InitN =
    Pointer<HtdEngine> Function(
      Pointer<HtdEngineConfig> config,
      Pointer<Int32> outError,
    );
typedef _InitD =
    Pointer<HtdEngine> Function(
      Pointer<HtdEngineConfig> config,
      Pointer<Int32> outError,
    );

typedef _DestroyN = Void Function(Pointer<HtdEngine> engine);
typedef _DestroyD = void Function(Pointer<HtdEngine> engine);

typedef _StartN = Int32 Function(Pointer<HtdEngine> engine);
typedef _StartD = int Function(Pointer<HtdEngine> engine);

typedef _StopN = Int32 Function(Pointer<HtdEngine> engine);
typedef _StopD = int Function(Pointer<HtdEngine> engine);

typedef _StopGracefulN = Int32 Function(Pointer<HtdEngine> engine);
typedef _StopGracefulD = int Function(Pointer<HtdEngine> engine);

typedef _RenderN =
    Int32 Function(
      Pointer<HtdEngine> engine,
      Pointer<Float> output,
      Uint32 numFrames,
    );
typedef _RenderD =
    int Function(
      Pointer<HtdEngine> engine,
      Pointer<Float> output,
      int numFrames,
    );

// Layer management
typedef _SetBaseN =
    Int32 Function(Pointer<HtdEngine> engine, Pointer<HtdLayerConfig> config);
typedef _SetBaseD =
    int Function(Pointer<HtdEngine> engine, Pointer<HtdLayerConfig> config);

typedef _ClearBaseN = Int32 Function(Pointer<HtdEngine> engine);
typedef _ClearBaseD = int Function(Pointer<HtdEngine> engine);

typedef _SetTextureN =
    Int32 Function(
      Pointer<HtdEngine> engine,
      Uint32 index,
      Pointer<HtdLayerConfig> config,
    );
typedef _SetTextureD =
    int Function(
      Pointer<HtdEngine> engine,
      int index,
      Pointer<HtdLayerConfig> config,
    );

typedef _ClearTextureN =
    Int32 Function(Pointer<HtdEngine> engine, Uint32 index);
typedef _ClearTextureD = int Function(Pointer<HtdEngine> engine, int index);

typedef _SetEventN =
    Int32 Function(
      Pointer<HtdEngine> engine,
      Uint32 index,
      Pointer<HtdEventConfig> config,
    );
typedef _SetEventD =
    int Function(
      Pointer<HtdEngine> engine,
      int index,
      Pointer<HtdEventConfig> config,
    );

typedef _ClearEventN = Int32 Function(Pointer<HtdEngine> engine, Uint32 index);
typedef _ClearEventD = int Function(Pointer<HtdEngine> engine, int index);

typedef _ClearAllLayersN = Int32 Function(Pointer<HtdEngine> engine);
typedef _ClearAllLayersD = int Function(Pointer<HtdEngine> engine);

// Gain setters
typedef _SetGainN = Int32 Function(Pointer<HtdEngine> engine, Float gain);
typedef _SetGainD = int Function(Pointer<HtdEngine> engine, double gain);

// Config update
typedef _UpdateConfigN =
    Int32 Function(Pointer<HtdEngine> engine, Pointer<HtdEngineConfig> config);
typedef _UpdateConfigD =
    int Function(Pointer<HtdEngine> engine, Pointer<HtdEngineConfig> config);

// Query
typedef _IsRunningN = Int32 Function(Pointer<HtdEngine> engine);
typedef _IsRunningD = int Function(Pointer<HtdEngine> engine);

typedef _SampleRateN = Float Function(Pointer<HtdEngine> engine);
typedef _SampleRateD = double Function(Pointer<HtdEngine> engine);

/// Dart FFI bindings for `libhexatune_dsp_ffi` (v0.1.2).
///
/// On Android the shared library is loaded by name from `jniLibs/`.
/// On iOS the symbols are statically linked into the app binary.
@singleton
class DspBindings {
  DspBindings(this._logService);

  final LogService _logService;
  late DynamicLibrary _lib;
  bool _loaded = false;

  /// Whether the native library has been loaded successfully.
  bool get isLoaded => _loaded;

  /// Load the native FFI library for the current platform.
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  void init() {
    if (_loaded) return;
    _load();
    _loaded = true;
  }

  // Lifecycle
  late _InitD _htdEngineInit;
  late _DestroyD _htdEngineDestroy;
  late _StartD _htdEngineStart;
  late _StopD _htdEngineStop;
  late _StopGracefulD _htdEngineStopGraceful;
  late _RenderD _htdEngineRender;

  // Layer management
  late _SetBaseD _htdEngineSetBase;
  late _ClearBaseD _htdEngineClearBase;
  late _SetTextureD _htdEngineSetTexture;
  late _ClearTextureD _htdEngineClearTexture;
  late _SetEventD _htdEngineSetEvent;
  late _ClearEventD _htdEngineClearEvent;
  late _ClearAllLayersD _htdEngineClearAllLayers;

  // Gain setters
  late _SetGainD _htdEngineSetBaseGain;
  late _SetGainD _htdEngineSetTextureGain;
  late _SetGainD _htdEngineSetEventGain;
  late _SetGainD _htdEngineSetBinauralGain;
  late _SetGainD _htdEngineSetMasterGain;

  // Config update
  late _UpdateConfigD _htdEngineUpdateConfig;

  // Query
  late _IsRunningD _htdEngineIsRunning;
  late _SampleRateD _htdEngineSampleRate;

  void _load() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libhexatune_dsp_ffi.so');
    } else if (Platform.isIOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError(
        'hexaTuneDsp FFI is not supported on ${Platform.operatingSystem}',
      );
    }

    _logService.devLog(
      'DspBindings loading (${Platform.operatingSystem})',
      category: LogCategory.dsp,
    );

    // Lifecycle
    _htdEngineInit = _lib.lookupFunction<_InitN, _InitD>('htd_engine_init');
    _htdEngineDestroy = _lib.lookupFunction<_DestroyN, _DestroyD>(
      'htd_engine_destroy',
    );
    _htdEngineStart = _lib.lookupFunction<_StartN, _StartD>('htd_engine_start');
    _htdEngineStop = _lib.lookupFunction<_StopN, _StopD>('htd_engine_stop');
    _htdEngineStopGraceful = _lib
        .lookupFunction<_StopGracefulN, _StopGracefulD>(
          'htd_engine_stop_graceful',
        );
    _htdEngineRender = _lib.lookupFunction<_RenderN, _RenderD>(
      'htd_engine_render',
    );

    // Layer management
    _htdEngineSetBase = _lib.lookupFunction<_SetBaseN, _SetBaseD>(
      'htd_engine_set_base',
    );
    _htdEngineClearBase = _lib.lookupFunction<_ClearBaseN, _ClearBaseD>(
      'htd_engine_clear_base',
    );
    _htdEngineSetTexture = _lib.lookupFunction<_SetTextureN, _SetTextureD>(
      'htd_engine_set_texture',
    );
    _htdEngineClearTexture = _lib
        .lookupFunction<_ClearTextureN, _ClearTextureD>(
          'htd_engine_clear_texture',
        );
    _htdEngineSetEvent = _lib.lookupFunction<_SetEventN, _SetEventD>(
      'htd_engine_set_event',
    );
    _htdEngineClearEvent = _lib.lookupFunction<_ClearEventN, _ClearEventD>(
      'htd_engine_clear_event',
    );
    _htdEngineClearAllLayers = _lib
        .lookupFunction<_ClearAllLayersN, _ClearAllLayersD>(
          'htd_engine_clear_all_layers',
        );

    // Gain setters
    _htdEngineSetBaseGain = _lib.lookupFunction<_SetGainN, _SetGainD>(
      'htd_engine_set_base_gain',
    );
    _htdEngineSetTextureGain = _lib.lookupFunction<_SetGainN, _SetGainD>(
      'htd_engine_set_texture_gain',
    );
    _htdEngineSetEventGain = _lib.lookupFunction<_SetGainN, _SetGainD>(
      'htd_engine_set_event_gain',
    );
    _htdEngineSetBinauralGain = _lib.lookupFunction<_SetGainN, _SetGainD>(
      'htd_engine_set_binaural_gain',
    );
    _htdEngineSetMasterGain = _lib.lookupFunction<_SetGainN, _SetGainD>(
      'htd_engine_set_master_gain',
    );

    // Config update
    _htdEngineUpdateConfig = _lib
        .lookupFunction<_UpdateConfigN, _UpdateConfigD>(
          'htd_engine_update_config',
        );

    // Query
    _htdEngineIsRunning = _lib.lookupFunction<_IsRunningN, _IsRunningD>(
      'htd_engine_is_running',
    );
    _htdEngineSampleRate = _lib.lookupFunction<_SampleRateN, _SampleRateD>(
      'htd_engine_sample_rate',
    );

    _logService.info(
      'DspBindings loaded successfully',
      category: LogCategory.dsp,
    );
  }

  // -------------------------------------------------------------------------
  // Public API (delegates to private FFI function pointers)
  // -------------------------------------------------------------------------

  Pointer<HtdEngine> htdEngineInit(
    Pointer<HtdEngineConfig> config,
    Pointer<Int32> outError,
  ) => _htdEngineInit(config, outError);

  void htdEngineDestroy(Pointer<HtdEngine> engine) => _htdEngineDestroy(engine);

  int htdEngineStart(Pointer<HtdEngine> engine) => _htdEngineStart(engine);

  int htdEngineStop(Pointer<HtdEngine> engine) => _htdEngineStop(engine);

  int htdEngineStopGraceful(Pointer<HtdEngine> engine) =>
      _htdEngineStopGraceful(engine);

  int htdEngineRender(
    Pointer<HtdEngine> engine,
    Pointer<Float> output,
    int numFrames,
  ) => _htdEngineRender(engine, output, numFrames);

  int htdEngineSetBase(
    Pointer<HtdEngine> engine,
    Pointer<HtdLayerConfig> config,
  ) => _htdEngineSetBase(engine, config);

  int htdEngineClearBase(Pointer<HtdEngine> engine) =>
      _htdEngineClearBase(engine);

  int htdEngineSetTexture(
    Pointer<HtdEngine> engine,
    int index,
    Pointer<HtdLayerConfig> config,
  ) => _htdEngineSetTexture(engine, index, config);

  int htdEngineClearTexture(Pointer<HtdEngine> engine, int index) =>
      _htdEngineClearTexture(engine, index);

  int htdEngineSetEvent(
    Pointer<HtdEngine> engine,
    int index,
    Pointer<HtdEventConfig> config,
  ) => _htdEngineSetEvent(engine, index, config);

  int htdEngineClearEvent(Pointer<HtdEngine> engine, int index) =>
      _htdEngineClearEvent(engine, index);

  int htdEngineClearAllLayers(Pointer<HtdEngine> engine) =>
      _htdEngineClearAllLayers(engine);

  int htdEngineSetBaseGain(Pointer<HtdEngine> engine, double gain) =>
      _htdEngineSetBaseGain(engine, gain);

  int htdEngineSetTextureGain(Pointer<HtdEngine> engine, double gain) =>
      _htdEngineSetTextureGain(engine, gain);

  int htdEngineSetEventGain(Pointer<HtdEngine> engine, double gain) =>
      _htdEngineSetEventGain(engine, gain);

  int htdEngineSetBinauralGain(Pointer<HtdEngine> engine, double gain) =>
      _htdEngineSetBinauralGain(engine, gain);

  int htdEngineSetMasterGain(Pointer<HtdEngine> engine, double gain) =>
      _htdEngineSetMasterGain(engine, gain);

  int htdEngineUpdateConfig(
    Pointer<HtdEngine> engine,
    Pointer<HtdEngineConfig> config,
  ) => _htdEngineUpdateConfig(engine, config);

  int htdEngineIsRunning(Pointer<HtdEngine> engine) =>
      _htdEngineIsRunning(engine);

  double htdEngineSampleRate(Pointer<HtdEngine> engine) =>
      _htdEngineSampleRate(engine);
}
