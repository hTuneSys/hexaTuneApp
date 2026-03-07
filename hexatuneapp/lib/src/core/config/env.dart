// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Compile-time environment configuration.
///
/// Values are injected via `--dart-define-from-file` at build time.
/// When no definitions are provided (e.g. plain `flutter run`),
/// the defaults point to the local dev server.
class Env {
  Env._();

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  // Google Sign-In: server (web) client ID used to request an ID token.
  static const String googleOAuthServerClientId = String.fromEnvironment(
    'GOOGLE_OAUTH_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  // Apple Sign-In: Service ID for web/Android redirect flow.
  static const String appleSignInServiceId = String.fromEnvironment(
    'APPLE_SIGNIN_SERVICE_ID',
    defaultValue: '',
  );

  // Apple Sign-In: Redirect URL for web/Android flow.
  static const String appleSignInRedirectUrl = String.fromEnvironment(
    'APPLE_SIGNIN_REDIRECT_URL',
    defaultValue: '',
  );

  static bool get isDev => environment == 'dev';
  static bool get isTest => environment == 'test';
  static bool get isStage => environment == 'stage';
  static bool get isProd => environment == 'prod';
}
