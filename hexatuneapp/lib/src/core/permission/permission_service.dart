// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Centralized permission management for camera, photos, and notifications.
@singleton
class PermissionService {
  PermissionService(this._logService);

  final LogService _logService;

  /// Request camera permission. Returns the resulting status.
  Future<PermissionStatus> requestCamera() async {
    final status = await Permission.camera.request();
    _logService.info(
      'Camera permission: ${status.name}',
      category: LogCategory.permission,
    );
    return status;
  }

  /// Request photo gallery / media library permission.
  Future<PermissionStatus> requestPhotos() async {
    final status = await Permission.photos.request();
    _logService.info(
      'Photos permission: ${status.name}',
      category: LogCategory.permission,
    );
    return status;
  }

  /// Request push notification permission.
  Future<PermissionStatus> requestNotification() async {
    final status = await Permission.notification.request();
    _logService.info(
      'Notification permission: ${status.name}',
      category: LogCategory.permission,
    );
    return status;
  }

  /// Check current status of a permission without requesting.
  Future<PermissionStatus> checkStatus(Permission permission) async {
    return permission.status;
  }

  /// Open the app's system settings page (for permanently denied permissions).
  Future<bool> openSettings() async {
    return openAppSettings();
  }
}
