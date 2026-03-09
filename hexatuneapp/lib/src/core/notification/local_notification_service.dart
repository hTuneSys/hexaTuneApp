// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Manages local (on-device) notifications for foreground push display
/// and other in-app alerts.
@singleton
class LocalNotificationService {
  LocalNotificationService(this._logService);

  final LogService _logService;
  static const String _channelId = 'hexatune_default';
  static const String _channelName = 'Default';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the local notification plugin with platform-specific settings.
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }

    _logService.info(
      'LocalNotificationService initialized',
      category: LogCategory.notification,
    );
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Default notification channel',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Display a simple notification.
  Future<void> show({
    required int id,
    required String title,
    String? body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }

  void _onNotificationTapped(NotificationResponse response) {
    _logService.debug(
      'Local notification tapped: ${response.payload}',
      category: LogCategory.notification,
    );
    // TODO: deep-link navigation based on payload
  }
}
