// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// API endpoint path constants derived from the OpenAPI spec.
///
/// Paths are relative to [Env.apiBaseUrl].
class ApiEndpoints {
  ApiEndpoints._();

  static const String _v1 = '/api/v1';

  // --- Authentication (12 endpoints) ---
  static const String login = '$_v1/auth/login';
  static const String register = '$_v1/auth/register';
  static const String logout = '$_v1/auth/logout';
  static const String refresh = '$_v1/auth/refresh';
  static const String reAuth = '$_v1/auth/reauth';
  static const String forgotPassword = '$_v1/auth/forgot-password';
  static const String resetPassword = '$_v1/auth/reset-password';
  static const String resendPasswordReset = '$_v1/auth/resend-password-reset';
  static const String verifyEmail = '$_v1/auth/verify-email';
  static const String resendVerification = '$_v1/auth/resend-verification';
  static const String authGoogle = '$_v1/auth/google';
  static const String authApple = '$_v1/auth/apple';

  // --- Provider Management (5 endpoints) ---
  static const String providers = '$_v1/accounts/me/providers';
  static const String linkEmailProvider = '$_v1/auth/providers/email/link';
  static const String linkGoogleProvider = '$_v1/auth/providers/google/link';
  static const String linkAppleProvider = '$_v1/auth/providers/apple/link';

  static String unlinkProvider(String providerType) {
    assert(providerType.isNotEmpty, 'providerType must not be empty');
    return '$_v1/auth/providers/$providerType';
  }

  // --- Tenants (2 endpoints) ---
  static const String tenants = '$_v1/accounts/me/tenants';
  static const String switchTenant = '$_v1/auth/switch-tenant';

  // --- Accounts (1 endpoint) ---
  static const String account = '$_v1/accounts/me';

  // --- Profile (2 endpoints) ---
  static const String profile = '$_v1/accounts/me/profile';

  // --- Sessions (3 endpoints) ---
  static const String sessions = '$_v1/accounts/me/sessions';
  static const String sessionsOthers = '$_v1/accounts/me/sessions/others';

  // --- Audit (1 endpoint) ---
  static const String auditLogs = '$_v1/audit/logs';

  // --- Devices / Push Token (4 endpoints) ---
  static const String devices = '$_v1/devices';
  static const String pushToken = '$_v1/devices/me/push-token';

  static String device(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/devices/$id';
  }

  // --- Device Approval (4 endpoints) ---
  static const String deviceApprovalRequest = '$_v1/device-approvals/request';

  static String deviceApprovalApprove(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/device-approvals/$id/approve';
  }

  static String deviceApprovalReject(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/device-approvals/$id/reject';
  }

  static String deviceApprovalStatus(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/device-approvals/$id/status';
  }

  // --- Categories (5 endpoints + labels) ---
  static const String categories = '$_v1/categories';
  static const String categoryLabels = '$_v1/categories/labels';

  static String category(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/categories/$id';
  }

  // --- Inventories (6 endpoints + labels) ---
  static const String inventories = '$_v1/inventories';
  static const String inventoryLabels = '$_v1/inventories/labels';

  static String inventory(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/inventories/$id';
  }

  static String inventoryImage(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/inventories/$id/image';
  }

  // --- Formulas (5 endpoints + labels) ---
  static const String formulas = '$_v1/formulas';
  static const String formulaLabels = '$_v1/formulas/labels';

  static String formula(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/formulas/$id';
  }

  // --- Formula Items (4 endpoints) ---
  static String formulaItems(String formulaId) {
    assert(formulaId.isNotEmpty, 'formulaId must not be empty');
    return '$_v1/formulas/$formulaId/items';
  }

  static String formulaItemsReorder(String formulaId) {
    assert(formulaId.isNotEmpty, 'formulaId must not be empty');
    return '$_v1/formulas/$formulaId/items/reorder';
  }

  static String formulaItem(String formulaId, String itemId) {
    assert(formulaId.isNotEmpty, 'formulaId must not be empty');
    assert(itemId.isNotEmpty, 'itemId must not be empty');
    return '$_v1/formulas/$formulaId/items/$itemId';
  }

  // --- Tasks (4 endpoints) ---
  static const String tasks = '$_v1/tasks';

  static String task(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/tasks/$id';
  }

  static String taskCancel(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/tasks/$id/cancel';
  }

  // --- Harmonics (1 endpoint) ---
  static const String harmonicsGenerate = '$_v1/harmonics/generate';

  // --- Packages (4 endpoints) ---
  static const String packages = '$_v1/packages';
  static const String packageLabels = '$_v1/packages/labels';

  static String package(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/packages/$id';
  }

  static String packageImage(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/packages/$id/image';
  }

  // --- Flows (4 endpoints) ---
  static const String flows = '$_v1/flows';
  static const String flowLabels = '$_v1/flows/labels';

  static String flow(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/flows/$id';
  }

  static String flowImage(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/flows/$id/image';
  }

  // --- Steps (4 endpoints) ---
  static const String steps = '$_v1/steps';
  static const String stepLabels = '$_v1/steps/labels';

  static String step(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/steps/$id';
  }

  static String stepImage(String id) {
    assert(id.isNotEmpty, 'id must not be empty');
    return '$_v1/steps/$id/image';
  }

  // --- Wallet (7 endpoints) ---
  static const String walletBalance = '$_v1/wallet/balance';
  static const String walletPackages = '$_v1/wallet/packages';
  static const String walletTransactions = '$_v1/wallet/transactions';
  static const String walletPurchaseApple = '$_v1/wallet/purchase/apple';
  static const String walletPurchaseGoogle = '$_v1/wallet/purchase/google';
  static const String walletCheckoutStripe = '$_v1/wallet/checkout/stripe';
  static const String walletWebhookApple = '$_v1/wallet/webhook/apple';
  static const String walletWebhookGoogle = '$_v1/wallet/webhook/google';
  static const String walletWebhookStripe = '$_v1/wallet/webhook/stripe';
}
