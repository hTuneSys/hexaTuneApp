// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_device_manager.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_device_error.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

/// High-level orchestrator for the hexaGen hardware device.
///
/// Exposes a reactive broadcast [Stream] of [HexagenState] changes
/// and manages command tracking, connection lifecycle, and error handling.
/// Follows the same pattern as [HeadsetService].
@singleton
class HexagenService {
  HexagenService(this._logService, this._protoService);

  final LogService _logService;
  final ProtoService _protoService;

  late final HexagenDeviceManager _deviceManager;
  bool _deviceManagerInitialized = false;
  final _stateController = StreamController<HexagenState>.broadcast();

  HexagenState _currentState = const HexagenState();

  // Command tracking
  static const int _maxId = 9999;
  int _nextId = 1;
  final Map<int, SentCommand> _sentCommands = {};
  final Map<int, Timer> _commandTimers = {};
  final Map<int, Completer<CommandStatus>> _commandCompleters = {};

  // Operation tracking
  int? _currentOperationId;
  String? _currentOperationStatus;
  int? _currentGeneratingStepId;

  // -----------------------------------------------------------------------
  // Public getters
  // -----------------------------------------------------------------------

  /// The current device state.
  HexagenState get currentState => _currentState;

  /// A broadcast stream of state changes.
  Stream<HexagenState> get state => _stateController.stream;

  /// Whether the device is connected.
  bool get isConnected => _currentState.isConnected;

  /// Current operation ID, if any.
  int? get currentOperationId => _currentOperationId;

  /// Current operation status.
  String? get currentOperationStatus => _currentOperationStatus;

  /// Current generating step ID.
  int? get currentGeneratingStepId => _currentGeneratingStepId;

  // -----------------------------------------------------------------------
  // Lifecycle
  // -----------------------------------------------------------------------

  /// Initialize the service — starts MIDI listening, scans for devices,
  /// and loads the FFI protocol library.
  ///
  /// MIDI device discovery is performed independently of the FFI library so
  /// that devices can still be detected even when the native proto library
  /// is unavailable (e.g. missing symbols on iOS).
  Future<void> init() async {
    try {
      // Step 1: Start MIDI listeners and scan for devices.
      // This must happen before ProtoService so that device discovery
      // is never blocked by an FFI failure.
      _deviceManager = HexagenDeviceManager(_logService, _protoService);
      _deviceManagerInitialized = true;
      _deviceManager.initialize(
        onDeviceChanged: _onDeviceChanged,
        onResponse: _onResponse,
      );

      await _loadDevices();

      // Step 2: Load the native protocol library (best-effort).
      // If this fails the device is still visible in the UI; only
      // command encoding/decoding will be unavailable.
      try {
        _protoService.init();
      } catch (e, st) {
        _logService.warning(
          'ProtoService initialization failed (device discovery unaffected): '
          '$e',
          category: LogCategory.hardware,
          exception: e,
          stackTrace: st,
        );
      }

      _updateState(_currentState.copyWith(isInitialized: true));

      _logService.info(
        'HexagenService initialized — '
        'connected: ${_currentState.isConnected}, '
        'device: ${_currentState.deviceName ?? "none"}, '
        'proto: ${_protoService.isLoaded}',
        category: LogCategory.hardware,
      );
    } catch (e, st) {
      _logService.warning(
        'HexagenService initialization failed: $e',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// Dispose all resources.
  @disposeMethod
  void dispose() {
    if (_deviceManagerInitialized) {
      _deviceManager.dispose();
    }
    for (final timer in _commandTimers.values.toList()) {
      timer.cancel();
    }
    _commandTimers.clear();
    _commandCompleters.clear();
    _stateController.close();
  }

  // -----------------------------------------------------------------------
  // Device discovery
  // -----------------------------------------------------------------------

  Future<void> _loadDevices() async {
    _logService.devLog(
      'Scanning for hexaGen devices',
      category: LogCategory.hardware,
    );

    final hexaDevice = await _deviceManager.findHexagenDevice();

    if (hexaDevice != null) {
      _logService.info(
        'hexaGen device found: ${hexaDevice.name}',
        category: LogCategory.hardware,
      );
      _updateState(
        _currentState.copyWith(
          deviceId: hexaDevice.id,
          deviceName: hexaDevice.name,
        ),
      );
      unawaited(_connectDevice(hexaDevice));
    } else {
      if (_currentState.isConnected) {
        _logService.info(
          'hexaGen device disconnected',
          category: LogCategory.hardware,
        );
      } else {
        _logService.devLog(
          'No hexaGen device found',
          category: LogCategory.hardware,
        );
      }
      _deviceManager.clearConnection();
      _updateState(const HexagenState(isInitialized: true));
    }
  }

  void _onDeviceChanged() {
    _logService.info(
      'MIDI device configuration changed (plug/unplug)',
      category: LogCategory.hardware,
    );
    _loadDevices();
  }

  Future<void> _connectDevice(dynamic device) async {
    _logService.info(
      'Connecting to hexaGen device: ${device.name}',
      category: LogCategory.hardware,
    );

    try {
      await _deviceManager.connectAndQueryVersion(device);
      _updateState(_currentState.copyWith(isConnected: true));
      _logService.info(
        'hexaGen device connected — '
        'firmware: ${_currentState.firmwareVersion ?? "querying..."}',
        category: LogCategory.hardware,
      );
    } catch (e, stack) {
      _logService.error(
        'hexaGen connection failed',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: stack,
      );
    }
  }

  /// Manually trigger a device rescan.
  Future<void> refresh() async {
    await _loadDevices();
  }

  // -----------------------------------------------------------------------
  // Response handling
  // -----------------------------------------------------------------------

  void _onResponse({
    String? version,
    HexagenDeviceError? error,
    DeviceStatus? status,
    int? responseId,
    String? operationStatus,
    int? operationStepId,
    required bool waiting,
  }) {
    if (version != null) {
      _logService.info(
        'hexaGen firmware version: $version',
        category: LogCategory.hardware,
      );
      _updateState(_currentState.copyWith(firmwareVersion: version));
    }

    if (error != null) {
      _logService.warning(
        'hexaGen device error: ${error.code}',
        category: LogCategory.hardware,
      );
    }

    if (operationStatus != null) {
      _logService.info(
        'hexaGen operation status: $operationStatus'
        '${operationStepId != null ? " (step $operationStepId)" : ""}',
        category: LogCategory.hardware,
      );
      _currentOperationStatus = operationStatus;
      _currentGeneratingStepId = operationStepId;
    }

    // Update command tracking
    if (responseId != null) {
      if (error != null) {
        _updateCommandStatus(
          responseId,
          CommandStatus.error,
          errorCode: error.code,
        );
      } else {
        _updateCommandStatus(responseId, CommandStatus.success);
      }
    }
  }

  // -----------------------------------------------------------------------
  // Command sending
  // -----------------------------------------------------------------------

  /// Generate the next sequential command ID (1–9999, wrapping).
  int generateId() {
    final id = _nextId;
    _nextId = _nextId % _maxId + 1;
    return id;
  }

  /// Send an AT command to the connected device.
  Future<void> sendATCommand(ATCommand command) async {
    final deviceId = _deviceManager.connectedId;
    if (deviceId == null) {
      _logService.warning(
        'Cannot send ${command.type.name}: no device connected',
        category: LogCategory.hardware,
      );
      return;
    }
    final compiled = command.compile();
    final sysex = command.buildSysEx(_protoService);
    _trackCommand(command.id, compiled);

    _logService.info(
      'Sending ${command.type.name}: $compiled',
      category: LogCategory.hardware,
    );

    _deviceManager.sendData(sysex, deviceId);
  }

  /// Send AT+FREQ and return a future that completes on response.
  ///
  /// When [stepId] is provided it is used as the command ID (useful for
  /// operation-scoped freq steps so firmware reports the same step index
  /// during GENERATE progress). Otherwise an auto-incremented ID is used.
  ///
  /// When [isOneShot] is true the device marks this step as one-shot —
  /// it will only be executed during the first repeat cycle.
  Future<CommandStatus> sendFreqCommandAndWait(
    int freq,
    int timeMs, {
    int? stepId,
    bool isOneShot = false,
  }) async {
    final deviceId = _deviceManager.connectedId;
    if (deviceId == null) {
      return CommandStatus.error;
    }
    final completer = Completer<CommandStatus>();
    final id = stepId ?? generateId();
    final command = ATCommand.freq(id, freq, timeMs, isOneShot: isOneShot);
    final compiled = command.compile();

    _commandCompleters[id] = completer;
    final timeout = Duration(milliseconds: timeMs + 5000);
    _trackCommand(id, compiled, timeout: timeout);

    _logService.info(
      'Sending FREQ and waiting: $compiled',
      category: LogCategory.hardware,
    );
    _deviceManager.sendData(command.buildSysEx(_protoService), deviceId);

    return completer.future;
  }

  /// Send AT+OPERATION=id#[repeatCount#]PREPARE and wait for response.
  ///
  /// When [repeatCount] is provided, the device will repeat the operation
  /// that many times (0 = infinite).
  Future<CommandStatus> sendOperationPrepare(
    int operationId, {
    int? repeatCount,
  }) async {
    final deviceId = _deviceManager.connectedId;
    if (deviceId == null) {
      return CommandStatus.error;
    }
    final completer = Completer<CommandStatus>();
    final command = ATCommand.operationPrepare(
      operationId,
      repeatCount: repeatCount,
    );

    _commandCompleters[operationId] = completer;
    _currentOperationId = operationId;
    _currentOperationStatus = 'PREPARE';

    _trackCommand(
      operationId,
      command.compile(),
      timeout: const Duration(seconds: 5),
    );

    _deviceManager.sendData(command.buildSysEx(_protoService), deviceId);

    return completer.future;
  }

  /// Send AT+OPERATION=id#GENERATE (polling, no wait).
  Future<void> sendOperationGenerate(int operationId) async {
    final deviceId = _deviceManager.connectedId;
    if (deviceId == null) return;
    final command = ATCommand.operationGenerate(operationId);
    _currentOperationStatus = 'GENERATE';

    _logService.info(
      'Sending OPERATION GENERATE: ${command.compile()}',
      category: LogCategory.hardware,
    );
    _deviceManager.sendData(command.buildSysEx(_protoService), deviceId);
  }

  /// Query current operation status (AT+OPERATION?).
  Future<void> queryOperationStatus() async {
    final deviceId = _deviceManager.connectedId;
    if (deviceId == null) return;
    final command = ATCommand.operationQuery();
    _deviceManager.sendData(command.buildSysEx(_protoService), deviceId);
  }

  /// Send raw data to the device.
  void sendData(Uint8List bytes, String deviceId) {
    _deviceManager.sendData(bytes, deviceId);
  }

  /// Reset operation tracking state.
  void resetOperationState() {
    _currentOperationId = null;
    _currentOperationStatus = null;
    _currentGeneratingStepId = null;
  }

  /// Graceful stop for an operation.
  ///
  /// Sends `AT+OPERATION=id#STOP#GRACEFUL`. Does **not** reset operation
  /// state — the caller should await [waitForOperationComplete] and then
  /// clean up.
  Future<void> stopOperationGraceful(int operationId) async {
    _logService.info(
      'Graceful stop for operation $operationId',
      category: LogCategory.hardware,
    );
    await sendATCommand(ATCommand.operationStopGraceful(operationId));
  }

  /// Immediate stop for an operation.
  ///
  /// Sends `AT+OPERATION=id#STOP#IMMEDIATELY`. Does **not** reset operation
  /// state — the caller should await [waitForOperationComplete] and then
  /// clean up.
  Future<void> stopOperationImmediate(int operationId) async {
    _logService.info(
      'Immediate stop for operation $operationId',
      category: LogCategory.hardware,
    );
    await sendATCommand(ATCommand.operationStopImmediate(operationId));
  }

  /// Waits for the device to report COMPLETED for the current operation.
  ///
  /// Polls [queryOperationStatus] every second. Returns `true` if COMPLETED
  /// was received within [timeout], `false` on timeout.
  Future<bool> waitForOperationComplete({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (_currentOperationStatus == 'COMPLETED') {
      resetOperationState();
      return true;
    }

    final completer = Completer<bool>();
    final deadline = DateTime.now().add(timeout);

    final pollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentOperationStatus == 'COMPLETED') {
        if (!completer.isCompleted) {
          resetOperationState();
          completer.complete(true);
        }
        return;
      }
      if (DateTime.now().isAfter(deadline)) {
        if (!completer.isCompleted) {
          resetOperationState();
          completer.complete(false);
        }
        return;
      }
      queryOperationStatus();
    });

    try {
      return await completer.future;
    } finally {
      pollTimer.cancel();
    }
  }

  // -----------------------------------------------------------------------
  // Command tracking
  // -----------------------------------------------------------------------

  void _trackCommand(int id, String command, {Duration? timeout}) {
    _sentCommands[id] = SentCommand(
      id,
      command,
      DateTime.now(),
      CommandStatus.pending,
    );
    if (timeout != null) {
      _commandTimers[id] = Timer(timeout, () {
        _updateCommandStatus(id, CommandStatus.timeout);
        _commandTimers.remove(id);
      });
    }
  }

  void _updateCommandStatus(int id, CommandStatus status, {String? errorCode}) {
    final command = _sentCommands[id];
    if (command != null) {
      command.status = status;
      command.errorCode = errorCode;
      _commandTimers[id]?.cancel();
      _commandTimers.remove(id);
    }

    final completer = _commandCompleters[id];
    if (completer != null && !completer.isCompleted) {
      completer.complete(status);
      _commandCompleters.remove(id);
    }
  }

  // -----------------------------------------------------------------------
  // State management
  // -----------------------------------------------------------------------

  void _updateState(HexagenState newState) {
    final previous = _currentState;
    _currentState = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }

    if (previous != newState) {
      _logService.info(
        'hexaGen state changed: '
        'connected ${previous.isConnected} → ${newState.isConnected}, '
        'device: ${newState.deviceName ?? "none"}, '
        'firmware: ${newState.firmwareVersion ?? "unknown"}'
        '${newState.isReady ? " ✓ READY" : ""}',
        category: LogCategory.hardware,
      );
    }
  }
}
