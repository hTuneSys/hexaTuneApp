// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Named route paths used throughout the application.
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String reAuth = '/re-auth';
  static const String deviceApproval = '/device-approval';

  // Dummy test pages — will be removed after production UI is built.
  static const String authExtras = '/dev/auth-extras';
  static const String account = '/dev/account';
  static const String sessions = '/dev/sessions';
  static const String devices = '/dev/devices';
  static const String providers = '/dev/providers';
  static const String tenants = '/dev/tenants';
  static const String categories = '/dev/categories';
  static const String inventories = '/dev/inventories';
  static const String formulas = '/dev/formulas';
  static const String formulaItems = '/dev/formulas/:formulaId/items';
  static const String tasks = '/dev/tasks';
  static const String audit = '/dev/audit';
  static const String harmonics = '/dev/harmonics';
  static const String dsp = '/dev/dsp';
  static const String ambience = '/dev/ambience';
  static const String hexagen = '/dev/hexagen';
  static const String harmonizer = '/dev/harmonizer';
}
