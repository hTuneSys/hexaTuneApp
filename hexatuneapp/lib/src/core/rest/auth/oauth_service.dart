// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Wraps native Google Sign-In and Apple Sign-In SDKs.
///
/// Returns ready-to-send request objects that [AuthService] can forward
/// directly to the backend. Platform availability is checked at runtime.
@singleton
class OAuthService {
  OAuthService(this._deviceService, this._log);

  final DeviceService _deviceService;
  final LogService _log;

  bool _googleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: Env.googleOAuthServerClientId.isNotEmpty
          ? Env.googleOAuthServerClientId
          : null,
    );
    _googleInitialized = true;
  }

  /// Whether Apple Sign-In is available on this device.
  bool get isAppleSignInAvailable => Platform.isIOS || Platform.isMacOS;

  /// Triggers the native Google Sign-In flow and returns a [GoogleAuthRequest]
  /// ready for `POST /auth/google`.
  ///
  /// Throws [OAuthCancelledException] if the user cancels.
  /// Throws [OAuthException] on SDK or token errors.
  Future<GoogleAuthRequest> signInWithGoogle() async {
    _log.devLog(
      '→ Google Sign-In: starting native flow\n'
      '  apiBaseUrl=${Env.apiBaseUrl}\n'
      '  serverClientId=${Env.googleOAuthServerClientId.isNotEmpty ? Env.googleOAuthServerClientId : "(empty)"}',
      category: LogCategory.auth,
    );

    await _ensureGoogleInitialized();

    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const OAuthException(
          'Google Sign-In succeeded but no ID token was returned. '
          'Ensure a serverClientId is configured.',
        );
      }

      _log.devLog(
        '✓ Google Sign-In: got ID token (${idToken.length} chars)',
        category: LogCategory.auth,
      );

      return GoogleAuthRequest(
        idToken: idToken,
        deviceId: _deviceService.deviceId,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const OAuthCancelledException('Google Sign-In was cancelled');
      }
      throw OAuthException('Google Sign-In failed: ${e.description}');
    }
  }

  /// Triggers the native Apple Sign-In flow and returns an [AppleAuthRequest]
  /// ready for `POST /auth/apple`.
  ///
  /// Throws [OAuthNotAvailableException] on Android/other unsupported platforms.
  /// Throws [OAuthCancelledException] if the user cancels.
  /// Throws [OAuthException] on SDK errors.
  Future<AppleAuthRequest> signInWithApple() async {
    if (!isAppleSignInAvailable) {
      throw const OAuthNotAvailableException(
        'Apple Sign-In is only available on iOS and macOS',
      );
    }

    _log.devLog(
      '→ Apple Sign-In: starting native flow\n'
      '  apiBaseUrl=${Env.apiBaseUrl}\n'
      '  serviceId=${Env.appleSignInServiceId.isNotEmpty ? Env.appleSignInServiceId : "(empty)"}\n'
      '  redirectUrl=${Env.appleSignInRedirectUrl.isNotEmpty ? Env.appleSignInRedirectUrl : "(empty)"}',
      category: LogCategory.auth,
    );

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw const OAuthException(
          'Apple Sign-In succeeded but no identity token was returned',
        );
      }

      _log.devLog(
        '✓ Apple Sign-In: got ID token (${idToken.length} chars)',
        category: LogCategory.auth,
      );

      return AppleAuthRequest(
        idToken: idToken,
        authorizationCode: credential.authorizationCode,
        deviceId: _deviceService.deviceId,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const OAuthCancelledException('Apple Sign-In was cancelled');
      }
      throw OAuthException('Apple Sign-In failed: ${e.message}');
    }
  }

  /// Signs out of Google (clears cached credentials).
  Future<void> signOutGoogle() async {
    if (!_googleInitialized) return;
    await GoogleSignIn.instance.signOut();
    _log.devLog('✓ Google Sign-In: signed out', category: LogCategory.auth);
  }
}

/// The user cancelled the OAuth flow.
class OAuthCancelledException implements Exception {
  const OAuthCancelledException(this.message);
  final String message;

  @override
  String toString() => 'OAuthCancelledException: $message';
}

/// A general OAuth SDK error.
class OAuthException implements Exception {
  const OAuthException(this.message);
  final String message;

  @override
  String toString() => 'OAuthException: $message';
}

/// The requested OAuth provider is not available on this platform.
class OAuthNotAvailableException implements Exception {
  const OAuthNotAvailableException(this.message);
  final String message;

  @override
  String toString() => 'OAuthNotAvailableException: $message';
}
