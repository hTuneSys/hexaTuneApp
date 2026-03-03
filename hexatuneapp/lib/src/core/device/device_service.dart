// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';

/// Local device metadata (not an API model).
class DeviceMetadata {
  const DeviceMetadata({
    required this.deviceId,
    this.deviceName,
    this.platform,
    this.osVersion,
  });

  final String deviceId;
  final String? deviceName;
  final String? platform;
  final String? osVersion;
}

/// Provides a persistent device identifier and device metadata.
@singleton
class DeviceService {
  DeviceService(this._secureStorage, this._logService);

  final SecureStorageService _secureStorage;
  final LogService _logService;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static const _uuid = Uuid();

  String? _deviceId;
  DeviceMetadata? _deviceMetadata;

  String get deviceId {
    assert(_deviceId != null, 'Call init() before accessing deviceId');
    return _deviceId!;
  }

  DeviceMetadata get deviceMetadata {
    assert(
      _deviceMetadata != null,
      'Call init() before accessing deviceMetadata',
    );
    return _deviceMetadata!;
  }

  /// The platform string for push token registration.
  String get platformName => _deviceMetadata?.platform ?? 'unknown';

  /// Load or generate the persistent device ID and gather metadata.
  Future<void> init() async {
    _deviceId = await _secureStorage.getDeviceId();
    if (_deviceId == null) {
      _deviceId = _uuid.v4();
      await _secureStorage.saveDeviceId(_deviceId!);
      _logService.info(
        'Generated new device ID: $_deviceId',
        category: LogCategory.device,
      );
    }

    _deviceMetadata = await _buildDeviceMetadata();
    _logService.info(
      'DeviceService initialized — '
      'id: $_deviceId, '
      'platform: ${_deviceMetadata!.platform}',
      category: LogCategory.device,
    );
  }

  Future<DeviceMetadata> _buildDeviceMetadata() async {
    String? deviceName;
    String? platformName;
    String? osVersion;

    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      deviceName = '${info.manufacturer} ${info.model}';
      platformName = 'android';
      osVersion = 'Android ${info.version.release}';
    } else if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;
      deviceName = info.utsname.machine;
      platformName = 'ios';
      osVersion = '${info.systemName} ${info.systemVersion}';
    } else if (Platform.isLinux) {
      final info = await _deviceInfoPlugin.linuxInfo;
      deviceName = info.prettyName;
      platformName = 'linux';
      osVersion = info.versionId;
    } else if (Platform.isMacOS) {
      final info = await _deviceInfoPlugin.macOsInfo;
      deviceName = info.computerName;
      platformName = 'macos';
      osVersion =
          '${info.majorVersion}.${info.minorVersion}';
    } else if (Platform.isWindows) {
      final info = await _deviceInfoPlugin.windowsInfo;
      deviceName = info.computerName;
      platformName = 'windows';
      osVersion =
          '${info.majorVersion}.${info.minorVersion}'
          '.${info.buildNumber}';
    }

    return DeviceMetadata(
      deviceId: _deviceId!,
      deviceName: deviceName,
      platform: platformName,
      osVersion: osVersion,
    );
  }
}
