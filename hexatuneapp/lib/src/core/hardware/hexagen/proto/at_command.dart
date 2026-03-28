// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:typed_data';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/proto/hexa_tune_proto_ffi.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

/// Builder for AT commands sent to the hexaGen device.
///
/// Encoding is performed via FFI to the Rust hexaTuneProto library.
class ATCommand {
  ATCommand(this.id, this.type, this.params, {this.isQuery = false});

  final int id;
  final ATCommandType type;
  final List<String> params;
  final bool isQuery;

  /// Compile the command to a human-readable string (for logging).
  String compile() {
    final name = type.name.toUpperCase();

    if (isQuery) {
      return 'AT+$name?';
    } else if (params.isEmpty) {
      return 'AT+$name=$id';
    } else {
      final paramStr = [id.toString(), ...params].join('#');
      return 'AT+$name=$paramStr';
    }
  }

  /// Build as SysEx bytes via FFI (F0…F7).
  Uint8List buildSysEx(ProtoService protoService) {
    final proto = protoService.proto;
    final name = type.name.toUpperCase();
    final atBytes = proto.atEncode(
      name,
      id: id,
      op: isQuery ? AtOp.query : AtOp.set,
      params: params,
    );
    return proto.sysexFrame(atBytes);
  }

  /// Build as USB MIDI packets via FFI (full pipeline).
  Uint8List buildPackets(ProtoService protoService) {
    final proto = protoService.proto;
    final name = type.name.toUpperCase();
    return proto.encodeToPackets(
      name,
      id: id,
      op: isQuery ? AtOp.query : AtOp.set,
      params: params,
    );
  }

  // -----------------------------------------------------------------------
  // Factory constructors
  // -----------------------------------------------------------------------

  /// Query firmware version (AT+VERSION?).
  factory ATCommand.version() {
    return ATCommand(0, ATCommandType.version, [], isQuery: true);
  }

  /// Query operation status (AT+OPERATION?).
  factory ATCommand.operationQuery() {
    return ATCommand(0, ATCommandType.operation, [], isQuery: true);
  }

  /// Prepare operation.
  ///
  /// Without [repeatCount]: `AT+OPERATION=id#PREPARE`.
  /// With [repeatCount]: `AT+OPERATION=id#repeatCount#PREPARE` (0 = infinite).
  factory ATCommand.operationPrepare(int id, {int? repeatCount}) {
    return ATCommand(id, ATCommandType.operation, [
      if (repeatCount != null) repeatCount.toString(),
      'PREPARE',
    ]);
  }

  /// Start generation (AT+OPERATION=id#GENERATE).
  factory ATCommand.operationGenerate(int id) {
    return ATCommand(id, ATCommandType.operation, ['GENERATE']);
  }

  /// Set frequency output (AT+FREQ=id#freq#timeMs#isOneShot).
  factory ATCommand.freq(
    int id,
    int freq,
    int timeMs, {
    bool isOneShot = false,
  }) {
    return ATCommand(id, ATCommandType.freq, [
      freq.toString(),
      timeMs.toString(),
      isOneShot ? '1' : '0',
    ]);
  }

  /// Set RGB LED color (AT+SETRGB=id#r#g#b).
  factory ATCommand.setRgb(int id, int r, int g, int b) {
    return ATCommand(id, ATCommandType.setRgb, [
      r.toString(),
      g.toString(),
      b.toString(),
    ]);
  }

  /// Graceful stop (AT+OPERATION=id#STOP#GRACEFUL).
  factory ATCommand.operationStopGraceful(int id) {
    return ATCommand(id, ATCommandType.operation, ['STOP', 'GRACEFUL']);
  }

  /// Immediate stop (AT+OPERATION=id#STOP#IMMEDIATELY).
  factory ATCommand.operationStopImmediate(int id) {
    return ATCommand(id, ATCommandType.operation, ['STOP', 'IMMEDIATELY']);
  }

  /// Reset device (AT+RESET=id).
  factory ATCommand.reset(int id) {
    return ATCommand(id, ATCommandType.reset, []);
  }

  /// Firmware update mode (AT+FWUPDATE=id).
  factory ATCommand.fwUpdate(int id) {
    return ATCommand(id, ATCommandType.fwUpdate, []);
  }
}
