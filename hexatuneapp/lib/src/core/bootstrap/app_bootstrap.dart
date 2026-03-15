// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/interceptors/auth_interceptor.dart';
import 'package:hexatuneapp/src/core/notification/local_notification_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';

/// Orchestrates sequential initialization of all core services
/// during application startup.
///
/// Step indices used with [onProgress]:
///   0 – Device Service
///   1 – Headset Service
///   2 – HexaGen Service
///   3 – Token Manager
///   4 – API Client
///   5 – Local Notifications
///   6 – Push Notifications
///   7 – Authentication
class AppBootstrap {
  AppBootstrap._();

  /// Labels for each bootstrap step (order must match step indices).
  static const stepLabels = <String>[
    'Device Service',
    'Headset Service',
    'HexaGen Service',
    'Token Manager',
    'API Client',
    'Local Notifications',
    'Push Notifications',
    'Authentication',
  ];

  static StreamSubscription<AuthEvent>? _authEventSub;

  /// Run the full bootstrap sequence.
  ///
  /// When [onProgress] is provided, it is called at the start and end of
  /// each step so the UI can display live progress.
  static Future<void> initialize({
    BootstrapProgressCallback? onProgress,
  }) async {
    final log = getIt<LogService>();
    log.info('Bootstrap started', category: LogCategory.bootstrap);

    try {
      // Storage services (PostConstruct already ran for sync inits).
      // PreferencesService uses preResolve so it's ready.
      log.info('SecureStorageService ready', category: LogCategory.bootstrap);
      log.info('PreferencesService ready', category: LogCategory.bootstrap);

      // Step 0: Device identification.
      onProgress?.call(0, BootstrapStepStatus.running);
      try {
        final deviceService = getIt<DeviceService>();
        await deviceService.init();
        log.info('DeviceService ready', category: LogCategory.bootstrap);
        log.devLog(
          'Device ID: ${deviceService.deviceId}',
          category: LogCategory.bootstrap,
        );
        onProgress?.call(0, BootstrapStepStatus.done);
      } catch (e, st) {
        log.warning(
          'DeviceService init failed (non-critical)',
          category: LogCategory.bootstrap,
          exception: e,
          stackTrace: st,
        );
        onProgress?.call(0, BootstrapStepStatus.error, e.toString());
      }

      // Step 1: Headset connection monitoring.
      onProgress?.call(1, BootstrapStepStatus.running);
      try {
        final headsetService = getIt<HeadsetService>();
        await headsetService.init();
        log.info('HeadsetService ready', category: LogCategory.bootstrap);
        onProgress?.call(1, BootstrapStepStatus.done);
      } catch (e) {
        onProgress?.call(1, BootstrapStepStatus.error, e.toString());
        rethrow;
      }

      // Step 2: hexaGen hardware device.
      onProgress?.call(2, BootstrapStepStatus.running);
      try {
        final hexagenService = getIt<HexagenService>();
        await hexagenService.init();
        log.info('HexagenService ready', category: LogCategory.bootstrap);
        onProgress?.call(2, BootstrapStepStatus.done);
      } catch (e) {
        onProgress?.call(2, BootstrapStepStatus.error, e.toString());
        rethrow;
      }

      // Step 3: Load stored tokens.
      onProgress?.call(3, BootstrapStepStatus.running);
      try {
        final tokenManager = getIt<TokenManager>();
        await tokenManager.loadTokens();
        log.info('TokenManager ready', category: LogCategory.bootstrap);
        log.devLog(
          'Token state — hasToken: ${tokenManager.hasToken}, '
          'session: ${tokenManager.sessionId}, '
          'accessExp: ${tokenManager.accessExpiresAt}, '
          'refreshExp: ${tokenManager.refreshExpiresAt}',
          category: LogCategory.bootstrap,
        );

        // Proactive token refresh during bootstrap.
        if (tokenManager.hasToken && tokenManager.isAccessTokenExpired) {
          await _refreshTokensAtBoot(tokenManager, log);
        }
        onProgress?.call(3, BootstrapStepStatus.done);
      } catch (e) {
        onProgress?.call(3, BootstrapStepStatus.error, e.toString());
        rethrow;
      }

      // Step 4: API client (PostConstruct already ran).
      onProgress?.call(4, BootstrapStepStatus.running);
      log.info('ApiClient ready', category: LogCategory.bootstrap);
      onProgress?.call(4, BootstrapStepStatus.done);

      // Step 5: Local notifications.
      onProgress?.call(5, BootstrapStepStatus.running);
      try {
        final localNotification = getIt<LocalNotificationService>();
        await localNotification.init();
        log.info(
          'LocalNotificationService ready',
          category: LogCategory.bootstrap,
        );
        onProgress?.call(5, BootstrapStepStatus.done);
      } catch (e) {
        onProgress?.call(5, BootstrapStepStatus.error, e.toString());
        rethrow;
      }

      // Step 6: FCM notifications (requires Firebase to be initialized).
      onProgress?.call(6, BootstrapStepStatus.running);
      String? fcmToken;
      try {
        final notificationService = getIt<NotificationService>();
        await notificationService.init();
        fcmToken = notificationService.fcmToken;
        log.info('NotificationService ready', category: LogCategory.bootstrap);
        log.devLog('FCM token: $fcmToken', category: LogCategory.bootstrap);
        onProgress?.call(6, BootstrapStepStatus.done);
      } catch (e) {
        log.warning(
          'NotificationService init failed '
          '(Firebase may not be configured)',
          category: LogCategory.bootstrap,
          exception: e,
        );
        onProgress?.call(6, BootstrapStepStatus.error, e.toString());
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
                appId: Env.appBundleId,
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

      // Step 7: Check auth state and emit initial routing decision.
      onProgress?.call(7, BootstrapStepStatus.running);
      try {
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
                appId: Env.appBundleId,
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

        // Listen to auth events from the interceptor.
        await _authEventSub?.cancel();
        _authEventSub = authService.authEvents.listen((event) {
          if (event == AuthEvent.forceLogout) {
            log.warning(
              'Force logout triggered by interceptor',
              category: LogCategory.auth,
            );
            authService.forceLogout();
          }
        });

        onProgress?.call(7, BootstrapStepStatus.done);
      } catch (e) {
        onProgress?.call(7, BootstrapStepStatus.error, e.toString());
        rethrow;
      }

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

  /// Attempt to refresh tokens using a plain [Dio] instance
  /// (no interceptors) to avoid recursion with the auth interceptor.
  static Future<void> _refreshTokensAtBoot(
    TokenManager tokenManager,
    LogService log,
  ) async {
    if (tokenManager.isRefreshTokenExpired) {
      log.warning(
        'Refresh token also expired — clearing tokens',
        category: LogCategory.bootstrap,
      );
      await tokenManager.clearTokens();
      return;
    }

    log.info(
      'Access token expired — refreshing during bootstrap',
      category: LogCategory.bootstrap,
    );

    try {
      // Use a fresh Dio to bypass the auth interceptor chain.
      final dio = Dio(
        BaseOptions(
          baseUrl: Env.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      try {
        final refreshData = {'refreshToken': tokenManager.refreshToken};

        final fullUrl = '${Env.apiBaseUrl}${ApiEndpoints.refresh}';
        final headers = {
          'Authorization': 'Bearer ${tokenManager.accessToken}',
          'Content-Type': 'application/json',
        };

        log.devLog(
          '→ [BOOTSTRAP REFRESH] POST $fullUrl\n'
          '  Headers: {\n'
          '    Authorization: Bearer ${LogService.maskToken(tokenManager.accessToken)}\n'
          '    Content-Type: application/json\n'
          '  }\n'
          '  Body: {refreshToken: ${LogService.maskToken(tokenManager.refreshToken)}}',
          category: LogCategory.bootstrap,
        );

        final response = await dio.post(
          ApiEndpoints.refresh,
          data: refreshData,
          options: Options(headers: headers),
        );

        log.devLog(
          '← [BOOTSTRAP REFRESH] Status: ${response.statusCode}\n'
          '  Headers: ${response.headers.map}\n'
          '  Body: ${response.data}',
          category: LogCategory.bootstrap,
        );

        if (response.statusCode == 200 && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          final newAccessToken = data['accessToken'] as String?;
          final newRefreshToken = data['refreshToken'] as String?;
          final sessionId = data['sessionId'] as String?;
          final expiresAt = data['expiresAt'] as String?;

          if (newAccessToken != null && newRefreshToken != null) {
            await tokenManager.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              sessionId: sessionId,
              expiresAt: expiresAt,
            );
            log.info(
              'Access token refreshed during bootstrap',
              category: LogCategory.bootstrap,
            );
            log.devLog(
              '✓ Bootstrap refresh succeeded — '
              'newAccessExp: ${tokenManager.accessExpiresAt}, '
              'newRefreshExp: ${tokenManager.refreshExpiresAt}',
              category: LogCategory.bootstrap,
            );
            return;
          }
        }

        // Unexpected response — clear tokens.
        log.warning(
          'Bootstrap refresh returned unexpected response — clearing tokens',
          category: LogCategory.bootstrap,
        );
        await tokenManager.clearTokens();
      } finally {
        dio.close();
      }
    } catch (e) {
      if (Env.isDev && e is DioException) {
        log.devLog(
          '✗ [BOOTSTRAP REFRESH] FAILED — Status: ${e.response?.statusCode}\n'
          '  Error: ${e.message}\n'
          '  Response body: ${e.response?.data}\n'
          '  Response headers: ${e.response?.headers.map}',
          category: LogCategory.bootstrap,
        );
      }
      log.warning(
        'Bootstrap refresh failed — clearing tokens',
        category: LogCategory.bootstrap,
        exception: e,
      );
      await tokenManager.clearTokens();
    }
  }
}
