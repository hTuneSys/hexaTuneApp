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
  static const String providers = '/dev/providers';
  static const String tenants = '/dev/tenants';
  static const String categoryList = '/categories';
  static const String categoryCreate = '/categories/create';
  static const String categoryEdit = '/categories/:categoryId/edit';
  static const String categoryView = '/categories/:categoryId';

  static String categoryEditFor(String id) => '/categories/$id/edit';
  static String categoryViewFor(String id) => '/categories/$id';
  static const String inventoryList = '/inventories';
  static const String inventoryCreate = '/inventories/create';
  static const String inventoryEdit = '/inventories/:inventoryId/edit';
  static const String inventoryView = '/inventories/:inventoryId';

  static String inventoryEditFor(String id) => '/inventories/$id/edit';
  static String inventoryViewFor(String id) => '/inventories/$id';
  static const String formulaList = '/formulas';
  static const String formulaCreate = '/formulas/create';
  static const String formulaEdit = '/formulas/:formulaId/edit';
  static const String formulaView = '/formulas/:formulaId';

  static String formulaEditFor(String id) => '/formulas/$id/edit';
  static String formulaViewFor(String id) => '/formulas/$id';
  static const String ambienceList = '/ambiences';
  static const String ambienceCreate = '/ambiences/create';
  static const String ambienceEdit = '/ambiences/:ambienceId/edit';
  static const String ambienceView = '/ambiences/:ambienceId';

  static String ambienceEditFor(String id) => '/ambiences/$id/edit';
  static String ambienceViewFor(String id) => '/ambiences/$id';
  static const String tasks = '/dev/tasks';
  static const String audit = '/dev/audit';
  static const String harmonics = '/dev/harmonics';
  static const String dsp = '/dev/dsp';
  static const String hexagen = '/dev/hexagen';
  static const String harmonizer = '/dev/harmonizer';
  static const String packages = '/dev/packages';
  static const String flows = '/dev/flows';
  static const String steps = '/dev/steps';
  static const String otp = '/dev/otp';
  static const String logMonitor = '/dev/log-monitor';
  static const String workspace = '/workspace';
  static const String settings = '/settings';
  static const String providerManagement = '/settings/providers';
  static const String settingsProfile = '/settings/profile';
  static const String settingsWallet = '/settings/wallet';
  static const String settingsSessions = '/settings/sessions';
  static const String settingsDevices = '/settings/devices';
}
