// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';

/// Top-level handler for background/terminated FCM messages.
///
/// Must be a top-level function (not a class method) because it runs in
/// a separate isolate on Android.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Background messages with a `notification` payload are automatically
  // displayed by the system tray. Data-only messages are silently received
  // here for processing (e.g. cache updates, silent syncs).
}

/// Manages Firebase Cloud Messaging: token retrieval, foreground/background
/// handling, and topic subscription.
@singleton
class NotificationService {
  NotificationService(this._logService, this._localNotificationService);

  final LogService _logService;
  final LocalNotificationService _localNotificationService;

  /// Whether Firebase is initialized and FCM is available.
  bool _firebaseAvailable = false;

  FirebaseMessaging? _messaging;

  String? _fcmToken;

  /// Counter for generating unique local notification IDs.
  int _notificationIdCounter = 0;

  // Stream subscriptions for cleanup.
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _messageOpenedSub;

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

    // Register background handler before requesting permission.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
        'FCM token: ${LogService.maskToken(_fcmToken)}',
        category: LogCategory.notification,
      );
    }

    // Listen for token refreshes.
    _tokenRefreshSub = _messaging!.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _logService.info(
        'FCM token refreshed',
        category: LogCategory.notification,
      );
      _logService.devLog(
        'New FCM token: ${LogService.maskToken(newToken)}',
        category: LogCategory.notification,
      );
      _onTokenRefreshCallback?.call(newToken);
    });

    // Foreground message handler.
    _foregroundSub = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    // Background/terminated tap handler.
    _messageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageOpenedApp,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;

    _logService.debug(
      'Foreground message: $title',
      category: LogCategory.notification,
    );
    _logService.devLog(
      'Foreground message details — '
      'title: $title, body: $body, data: ${message.data}',
      category: LogCategory.notification,
    );

    if (title != null) {
      _localNotificationService.show(
        id: _notificationIdCounter++,
        title: title,
        body: body,
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      );
    }
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
    // Deep-link navigation will be implemented when the navigation
    // architecture supports payload-based routing.
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

  /// Cancel all stream subscriptions.
  @disposeMethod
  void dispose() {
    _tokenRefreshSub?.cancel();
    _foregroundSub?.cancel();
    _messageOpenedSub?.cancel();
  }
}
