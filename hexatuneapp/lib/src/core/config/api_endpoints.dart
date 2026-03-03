// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// API endpoint path constants derived from the OpenAPI spec.
///
/// Paths are relative to [Env.apiBaseUrl].
class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = '/api/v1';

  // --- Authentication (9 endpoints) ---
  static const String login = '$_v1/auth/login';
  static const String register = '$_v1/auth/register';
  static const String logout = '$_v1/auth/logout';
  static const String refresh = '$_v1/auth/refresh';
  static const String reAuth = '$_v1/auth/reauth';
  static const String forgotPassword = '$_v1/auth/forgot-password';
  static const String resetPassword = '$_v1/auth/reset-password';
  static const String verifyEmail = '$_v1/auth/verify-email';
  static const String resendVerification = '$_v1/auth/resend-verification';

  // --- Accounts (1 endpoint) ---
  static const String account = '$_v1/accounts/me';

  // --- Profile (2 endpoints) ---
  static const String profile = '$_v1/accounts/me/profile';

  // --- Sessions (3 endpoints) ---
  static const String sessions = '$_v1/accounts/me/sessions';
  static const String sessionsOthers = '$_v1/accounts/me/sessions/others';

  // --- Audit (1 endpoint) ---
  static const String auditLogs = '$_v1/audit/logs';

  // --- Devices / Push Token (2 endpoints) ---
  static const String pushToken = '$_v1/devices/me/push-token';

  // --- Device Approval (4 endpoints) ---
  static const String deviceApprovalRequest = '$_v1/device-approvals/request';

  static String deviceApprovalApprove(String id) =>
      '$_v1/device-approvals/$id/approve';

  static String deviceApprovalReject(String id) =>
      '$_v1/device-approvals/$id/reject';

  static String deviceApprovalStatus(String id) =>
      '$_v1/device-approvals/$id/status';

  // --- Categories (5 endpoints) ---
  static const String categories = '$_v1/categories';

  static String category(String id) => '$_v1/categories/$id';

  // --- Inventories (6 endpoints) ---
  static const String inventories = '$_v1/inventories';

  static String inventory(String id) => '$_v1/inventories/$id';

  static String inventoryImage(String id) => '$_v1/inventories/$id/image';

  // --- Formulas (5 endpoints) ---
  static const String formulas = '$_v1/formulas';

  static String formula(String id) => '$_v1/formulas/$id';

  // --- Formula Items (4 endpoints) ---
  static String formulaItems(String formulaId) =>
      '$_v1/formulas/$formulaId/items';

  static String formulaItemsReorder(String formulaId) =>
      '$_v1/formulas/$formulaId/items/reorder';

  static String formulaItem(String formulaId, String itemId) =>
      '$_v1/formulas/$formulaId/items/$itemId';

  // --- Tasks (4 endpoints) ---
  static const String tasks = '$_v1/tasks';

  static String task(String id) => '$_v1/tasks/$id';

  static String taskCancel(String id) => '$_v1/tasks/$id/cancel';
}
