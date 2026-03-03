// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/device/device_repository.dart';
import 'package:hexatuneapp/src/core/device/device_service.dart';
import 'package:hexatuneapp/src/core/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';

/// Orchestrates sequential initialization of all core services
/// during application startup.
class AppBootstrap {
  AppBootstrap._();

  /// Run the full bootstrap sequence.
  ///
  /// Services that are registered with `@PostConstruct` are already
  /// initialized by get_it.  This method handles the remaining
  /// asynchronous init steps that depend on runtime context.
  static Future<void> initialize() async {
    final log = getIt<LogService>();
    log.info('Bootstrap started', category: LogCategory.bootstrap);

    try {
      // Storage services (PostConstruct already ran for sync inits).
      // PreferencesService uses preResolve so it's ready.
      log.info('SecureStorageService ready', category: LogCategory.bootstrap);
      log.info('PreferencesService ready', category: LogCategory.bootstrap);

      // Device identification.
      final deviceService = getIt<DeviceService>();
      await deviceService.init();
      log.info('DeviceService ready', category: LogCategory.bootstrap);
      if (Env.isDev) {
        log.devLog(
          'Device ID: ${deviceService.deviceId}',
          category: LogCategory.bootstrap,
        );
      }

      // Load stored tokens.
      final tokenManager = getIt<TokenManager>();
      await tokenManager.loadTokens();
      log.info('TokenManager ready', category: LogCategory.bootstrap);
      if (Env.isDev) {
        log.devLog(
          'Token state — hasToken: ${tokenManager.hasToken}, '
          'session: ${tokenManager.sessionId}, '
          'expiresAt: ${tokenManager.expiresAt}',
          category: LogCategory.bootstrap,
        );
      }

      // API client (PostConstruct already ran).
      log.info('ApiClient ready', category: LogCategory.bootstrap);

      // Local notifications.
      final localNotification = getIt<LocalNotificationService>();
      await localNotification.init();
      log.info(
        'LocalNotificationService ready',
        category: LogCategory.bootstrap,
      );

      // FCM notifications (requires Firebase to be initialized first).
      String? fcmToken;
      try {
        final notificationService = getIt<NotificationService>();
        await notificationService.init();
        fcmToken = notificationService.fcmToken;
        log.info('NotificationService ready', category: LogCategory.bootstrap);
        if (Env.isDev) {
          log.devLog(
            'FCM token: $fcmToken',
            category: LogCategory.bootstrap,
          );
        }
      } catch (e) {
        log.warning(
          'NotificationService init failed '
          '(Firebase may not be configured)',
          category: LogCategory.bootstrap,
          exception: e,
        );
      }

      // Wire FCM token refresh → backend push token re-registration.
      try {
        final notificationService = getIt<NotificationService>();
        final deviceRepo = getIt<DeviceRepository>();
        notificationService.onTokenRefresh = (newToken) async {
          try {
            await deviceRepo.registerPushToken(
              RegisterPushTokenRequest(
                token: newToken,
                platform: Platform.isIOS ? 'ios' : 'android',
              ),
            );
            log.info(
              'Push token re-registered after refresh',
              category: LogCategory.notification,
            );
          } catch (e) {
            log.warning(
              'Push token re-registration failed (non-critical)',
              category: LogCategory.notification,
              exception: e,
            );
          }
        };
      } catch (_) {
        // NotificationService may not be available
      }

      // Check auth state and emit initial routing decision.
      final authService = getIt<AuthService>();
      await authService.checkAuthStatus();
      log.info(
        'AuthService ready — state: ${authService.currentState.name}',
        category: LogCategory.bootstrap,
      );

      // Register push token with backend if authenticated.
      if (authService.currentState == AuthState.authenticated &&
          fcmToken != null) {
        try {
          final deviceRepo = getIt<DeviceRepository>();
          await deviceRepo.registerPushToken(
            RegisterPushTokenRequest(
              token: fcmToken,
              platform: Platform.isIOS ? 'ios' : 'android',
            ),
          );
          log.info('Push token registered', category: LogCategory.bootstrap);
        } catch (e) {
          log.warning(
            'Push token registration failed (non-critical)',
            category: LogCategory.bootstrap,
            exception: e,
          );
        }
      }

      // Listen to auth events from the interceptor (force logout, re-auth).
      authService.authEvents.listen((event) {
        if (event == AuthEvent.forceLogout) {
          log.warning(
            'Force logout triggered by interceptor',
            category: LogCategory.auth,
          );
          authService.forceLogout();
        }
      });

      log.info('Bootstrap complete', category: LogCategory.bootstrap);
    } catch (e, stackTrace) {
      log.critical(
        'Bootstrap failed',
        category: LogCategory.bootstrap,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
