// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_device_error.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_response.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

/// Callback signature for device responses.
typedef DeviceResponseCallback =
    void Function({
      String? version,
      HexagenDeviceError? error,
      DeviceStatus? status,
      int? responseId,
      String? operationStatus,
      int? operationStepId,
      required bool waiting,
    });

/// Low-level MIDI communication manager for the hexaGen device.
///
/// Handles device discovery, connection, SysEx message buffering,
/// and AT response parsing. Delegates higher-level orchestration to
/// [HexagenService].
class HexagenDeviceManager {
  HexagenDeviceManager(this._logService, this._protoService);

  final LogService _logService;
  final ProtoService _protoService;
  final MidiCommand _midi = MidiCommand();
  final RegExp _hexaPattern = RegExp(r'hexa', caseSensitive: false);

  StreamSubscription<dynamic>? _setupSub;
  StreamSubscription<dynamic>? _dataSub;

  bool _connecting = false;
  String? _connectedId;
  bool _waitingForResponse = false;
  Timer? _responseTimeout;
  final List<int> _sysexBuffer = [];

  DeviceResponseCallback? _responseCallback;

  /// Initialize the device manager with event callbacks.
  void initialize({
    required void Function() onDeviceChanged,
    required DeviceResponseCallback onResponse,
  }) {
    _responseCallback = onResponse;

    _setupSub = _midi.onMidiSetupChanged?.listen((_) {
      onDeviceChanged();
    });

    _dataSub = _midi.onMidiDataReceived?.listen((packet) {
      _handleATResponse(packet.data);
    });
  }

  /// Release all subscriptions and timers.
  void dispose() {
    _setupSub?.cancel();
    _dataSub?.cancel();
    _responseTimeout?.cancel();
  }

  /// List all available MIDI devices.
  Future<List<MidiDevice>> getDevices() async {
    return await _midi.devices ?? <MidiDevice>[];
  }

  /// Find the first MIDI device whose name contains "hexa".
  Future<MidiDevice?> findHexagenDevice() async {
    final all = await getDevices();
    for (final d in all) {
      if (_matchesHexagen(d)) return d;
    }
    return null;
  }

  bool _matchesHexagen(MidiDevice d) {
    final name = d.name;
    return name.toLowerCase().contains(_hexaPattern.pattern);
  }

  /// The currently connected device ID, or `null`.
  String? get connectedId => _connectedId;

  /// Clear the stored connection.
  void clearConnection() {
    _connectedId = null;
  }

  /// Whether a specific device is connected.
  Future<bool> isDeviceConnected(String id) async {
    final list = await getDevices();
    return list.any((x) => x.id == id && x.connected == true);
  }

  /// Connect to [device] and query its firmware version.
  Future<void> connectAndQueryVersion(MidiDevice device) async {
    final deviceId = device.id;
    if (_connecting) return;

    if (await isDeviceConnected(deviceId)) {
      _connectedId = deviceId;
      _sendATVersion(deviceId);
      return;
    }

    _connecting = true;
    _notifyResponse(version: null, error: null, waiting: true);

    try {
      // Disconnect other devices first
      final current = await getDevices();
      for (final dev in current) {
        if (dev.connected == true && dev.id != device.id) {
          try {
            _midi.disconnectDevice(dev);
          } catch (_) {}
        }
      }

      await Future.delayed(const Duration(milliseconds: 200));
      _midi.connectToDevice(device);

      // Wait for connection
      for (int i = 0; i < 20; i++) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (await isDeviceConnected(deviceId)) {
          _connectedId = deviceId;
          break;
        }
      }

      if (_connectedId == deviceId) {
        // Firmware needs ~1-2 s to be ready after USB enumeration
        await Future.delayed(const Duration(milliseconds: 1500));
        _sendATVersion(deviceId);
      }
    } finally {
      _connecting = false;
    }
  }

  /// Send raw data to the given device.
  void sendData(Uint8List bytes, String deviceId) {
    _midi.sendData(bytes, deviceId: deviceId);
  }

  // -----------------------------------------------------------------------
  // AT+VERSION? helper
  // -----------------------------------------------------------------------

  void _sendATVersion(String deviceId) {
    final command = ATCommand.version();
    final bytes = command.buildSysEx(_protoService);
    _waitingForResponse = true;
    _sysexBuffer.clear();
    _notifyResponse(waiting: true);

    _logService.devLog(
      'Sending AT+VERSION? (${bytes.length} bytes)',
      category: LogCategory.hardware,
    );

    _midi.sendData(bytes, deviceId: deviceId);

    _responseTimeout?.cancel();
    _responseTimeout = Timer(const Duration(seconds: 10), () {
      if (_waitingForResponse) {
        _logService.warning(
          'AT+VERSION? response timeout',
          category: LogCategory.hardware,
        );
        _waitingForResponse = false;
        _sysexBuffer.clear();
        _notifyResponse(version: 'No response', waiting: false);
      }
    });
  }

  // -----------------------------------------------------------------------
  // Incoming data handling
  // -----------------------------------------------------------------------

  void _handleATResponse(Uint8List bytes) {
    _logService.devLog(
      'Received MIDI data: ${bytes.length} bytes',
      category: LogCategory.hardware,
    );

    _sysexBuffer.addAll(bytes);

    if (!_sysexBuffer.contains(0xF7)) return;

    _responseTimeout?.cancel();

    try {
      final bufferedData = Uint8List.fromList(_sysexBuffer);
      _sysexBuffer.clear();

      final response = extractAndParseATResponse(bufferedData, _protoService);

      if (response == null) {
        _logService.warning(
          'Failed to parse AT response from SysEx data',
          category: LogCategory.hardware,
        );
        _waitingForResponse = false;
        return;
      }

      _logService.devLog(
        'Decoded AT response: type=${response.type}, id=${response.id}',
        category: LogCategory.hardware,
      );
      _waitingForResponse = false;

      switch (response.type) {
        case ATResponseType.error:
          final error = HexagenDeviceError.fromCode(response.errorCode);
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(error: error, responseId: id, waiting: false);

        case ATResponseType.version:
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(
            version: response.version,
            responseId: id,
            waiting: false,
          );

        case ATResponseType.operation:
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(
            responseId: id,
            operationStatus: response.operationStatus,
            operationStepId: response.operationStepId,
            waiting: false,
          );

        case ATResponseType.freq:
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(responseId: id, waiting: false);

        case ATResponseType.done:
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(responseId: id, waiting: false);

        case ATResponseType.status:
          final id = int.tryParse(response.id) ?? 0;
          _notifyResponse(
            status: response.status,
            responseId: id,
            waiting: false,
          );
      }
    } catch (e, stack) {
      _logService.error(
        'Error parsing AT response',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: stack,
      );
      _sysexBuffer.clear();
      _waitingForResponse = false;
    }
  }

  // -----------------------------------------------------------------------
  // Response callback
  // -----------------------------------------------------------------------

  void _notifyResponse({
    String? version,
    HexagenDeviceError? error,
    DeviceStatus? status,
    int? responseId,
    String? operationStatus,
    int? operationStepId,
    required bool waiting,
  }) {
    _responseCallback?.call(
      version: version,
      error: error,
      status: status,
      responseId: responseId,
      operationStatus: operationStatus,
      operationStepId: operationStepId,
      waiting: waiting,
    );
  }
}
