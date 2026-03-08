// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:typed_data';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/proto/hexa_tune_proto_ffi.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

/// AT response types returned by the hexaGen device.
enum ATResponseType { version, error, done, status, operation, freq }

/// Parsed AT response from the hexaGen device.
class ATResponse {
  ATResponse({required this.type, required this.id, required this.params});

  final ATResponseType type;
  final String id;
  final List<String> params;

  /// Firmware version string.
  String get version => params.isNotEmpty ? params[0] : '';

  /// Error code string (e.g. "E001001").
  String get errorCode => params.isNotEmpty ? params[0] : '';

  /// Device status parsed from a STATUS response.
  DeviceStatus get status => params.isNotEmpty && params[0] == 'AVAILABLE'
      ? DeviceStatus.available
      : DeviceStatus.generating;

  /// Operation status (PREPARE, GENERATE, GENERATING, COMPLETED).
  String get operationStatus {
    if (params.isEmpty) return '';
    if (params.length > 1 && params[1] == 'COMPLETED') return 'COMPLETED';
    return params[0];
  }

  /// Step ID during GENERATING progress.
  int? get operationStepId {
    if (params.length > 1 && params[0] == 'GENERATING') {
      return int.tryParse(params[1]);
    }
    return null;
  }

  /// Whether a FREQ command completed successfully.
  bool get freqCompleted {
    if (type == ATResponseType.freq && params.length >= 3) {
      return params[2] == 'COMPLETED';
    }
    return false;
  }

  /// Whether an OPERATION completed.
  bool get operationCompleted {
    if (type == ATResponseType.operation && params.isNotEmpty) {
      return params.contains('COMPLETED');
    }
    return false;
  }
}

/// Parse an AT response string using FFI.
ATResponse? parseATResponse(String message, ProtoService protoService) {
  final trimmed = message.trim();
  if (!trimmed.startsWith('AT+')) return null;

  try {
    final proto = protoService.proto;
    final input = Uint8List.fromList(trimmed.codeUnits);
    final result = proto.atParse(input);

    final id = result.id.toString();
    final params = result.params;

    switch (result.name) {
      case 'VERSION':
        return ATResponse(type: ATResponseType.version, id: id, params: params);
      case 'OPERATION':
        return ATResponse(
          type: ATResponseType.operation,
          id: id,
          params: params,
        );
      case 'FREQ':
        return ATResponse(type: ATResponseType.freq, id: id, params: params);
      case 'SETRGB':
      case 'RESET':
      case 'FWUPDATE':
      case 'DONE':
        return ATResponse(type: ATResponseType.done, id: id, params: params);
      case 'ERROR':
        return ATResponse(type: ATResponseType.error, id: id, params: params);
      case 'STATUS':
        return ATResponse(type: ATResponseType.status, id: id, params: params);
      default:
        return null;
    }
  } on HexaTuneProtoError {
    return null;
  } catch (_) {
    return null;
  }
}

/// Extract SysEx payload from MIDI data and parse AT response.
///
/// Handles both USB MIDI packet format (Android) and raw SysEx (iOS).
ATResponse? extractAndParseATResponse(
  Uint8List data,
  ProtoService protoService,
) {
  try {
    final proto = protoService.proto;

    // Detect USB MIDI packet format vs raw SysEx
    final isUsbMidiPackets =
        data.length >= 4 && (data[0] & 0xF0) == 0x00 && data.length % 4 == 0;

    Uint8List payload;
    if (isUsbMidiPackets) {
      // Android: USB MIDI packets → depacketize → unframe
      final sysex = proto.usbDepacketize(data);
      payload = proto.sysexUnframe(sysex);
    } else {
      // iOS: Raw SysEx bytes → unframe directly
      payload = proto.sysexUnframe(data);
    }

    final message = String.fromCharCodes(payload);
    return parseATResponse(message, protoService);
  } on HexaTuneProtoError {
    return null;
  } catch (_) {
    return null;
  }
}
