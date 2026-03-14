// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Error codes returned by the hexaGen device firmware.
///
/// Maps to AT protocol error responses (E001001–E001010).
enum HexagenDeviceError {
  invalidCommand('E001001'),
  ddsBusy('E001002'),
  invalidUtf8('E001003'),
  invalidSysEx('E001004'),
  invalidDataLength('E001005'),
  paramCount('E001006'),
  paramValue('E001007'),
  notAQuery('E001008'),
  unknownCommand('E001009'),
  operationStepsFull('E001010');

  const HexagenDeviceError(this.code);

  final String code;

  /// Resolve an error code string to a [HexagenDeviceError], or `null`.
  static HexagenDeviceError? fromCode(String? code) {
    if (code == null) return null;
    for (final error in values) {
      if (error.code == code) return error;
    }
    return null;
  }
}
