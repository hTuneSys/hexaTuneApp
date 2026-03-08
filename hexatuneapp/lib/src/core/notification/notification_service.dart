// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Manages Firebase Cloud Messaging: token retrieval, foreground/background
/// handling, and topic subscription.
@singleton
class NotificationService {
  NotificationService(this._logService);

  final LogService _logService;

  /// Whether Firebase is initialized and FCM is available.
  bool _firebaseAvailable = false;

  FirebaseMessaging? _messaging;

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  /// Whether FCM is available on this device.
  bool get isAvailable => _firebaseAvailable;

  /// Callback invoked when the FCM token refreshes.
  void Function(String newToken)? _onTokenRefreshCallback;

  /// Set a callback to be invoked when the FCM token refreshes.
  set onTokenRefresh(void Function(String newToken) callback) {
    _onTokenRefreshCallback = callback;
  }

  /// Request permission and retrieve the FCM device token.
  ///
  /// Safe to call even when Firebase is not configured — logs a warning
  /// and returns early.
  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      _firebaseAvailable = false;
      _logService.warning(
        'Firebase not initialized — FCM unavailable. '
        'Run `flutterfire configure` to set up Firebase.',
        category: LogCategory.notification,
      );
      return;
    }

    _firebaseAvailable = true;
    _messaging = FirebaseMessaging.instance;

    final settings = await _messaging!.requestPermission();
    _logService.info(
      'Notification permission: ${settings.authorizationStatus}',
      category: LogCategory.notification,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      _fcmToken = await _messaging!.getToken();
      _logService.info(
        'FCM token obtained',
        category: LogCategory.notification,
      );
      _logService.devLog(
        'FCM token: $_fcmToken',
        category: LogCategory.notification,
      );
    }

    // Listen for token refreshes.
    _messaging!.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _logService.info(
        'FCM token refreshed',
        category: LogCategory.notification,
      );
      _logService.devLog(
        'New FCM token: $newToken',
        category: LogCategory.notification,
      );
      _onTokenRefreshCallback?.call(newToken);
    });

    // Foreground message handler.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated tap handler.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _logService.debug(
      'Foreground message: ${message.notification?.title}',
      category: LogCategory.notification,
    );
    _logService.devLog(
      'Foreground message details — '
      'title: ${message.notification?.title}, '
      'body: ${message.notification?.body}, '
      'data: ${message.data}',
      category: LogCategory.notification,
    );
    // TODO: show local notification via LocalNotificationService
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _logService.debug(
      'Message opened app: ${message.data}',
      category: LogCategory.notification,
    );
    _logService.devLog(
      'Message opened app details — '
      'title: ${message.notification?.title}, '
      'body: ${message.notification?.body}, '
      'data: ${message.data}',
      category: LogCategory.notification,
    );
    // TODO: deep-link navigation based on message data
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!_firebaseAvailable || _messaging == null) return;
    await _messaging!.subscribeToTopic(topic);
    _logService.debug(
      'Subscribed to topic: $topic',
      category: LogCategory.notification,
    );
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_firebaseAvailable || _messaging == null) return;
    await _messaging!.unsubscribeFromTopic(topic);
    _logService.debug(
      'Unsubscribed from topic: $topic',
      category: LogCategory.notification,
    );
  }
}
