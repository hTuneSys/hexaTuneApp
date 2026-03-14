// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// AT command types supported by the hexaGen device.
enum ATCommandType { version, freq, setRgb, reset, fwUpdate, operation }

/// Tracking status for sent commands.
enum CommandStatus { pending, success, error, timeout }

/// Device operational status from periodic STATUS messages.
enum DeviceStatus { available, generating }

/// A sent command with tracking metadata.
class SentCommand {
  SentCommand(
    this.id,
    this.command,
    this.sentAt,
    this.status, {
    this.errorCode,
  });

  final int id;
  final String command;
  final DateTime sentAt;
  CommandStatus status;
  String? errorCode;
}
