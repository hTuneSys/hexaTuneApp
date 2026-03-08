// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';

void main() {
  group('ApiEndpoints', () {
    group('static constants', () {
      test('auth endpoints have correct paths', () {
        expect(ApiEndpoints.login, '/api/v1/auth/login');
        expect(ApiEndpoints.register, '/api/v1/auth/register');
        expect(ApiEndpoints.logout, '/api/v1/auth/logout');
        expect(ApiEndpoints.refresh, '/api/v1/auth/refresh');
        expect(ApiEndpoints.reAuth, '/api/v1/auth/reauth');
        expect(ApiEndpoints.forgotPassword, '/api/v1/auth/forgot-password');
        expect(ApiEndpoints.resetPassword, '/api/v1/auth/reset-password');
        expect(
          ApiEndpoints.resendPasswordReset,
          '/api/v1/auth/resend-password-reset',
        );
        expect(ApiEndpoints.verifyEmail, '/api/v1/auth/verify-email');
        expect(
          ApiEndpoints.resendVerification,
          '/api/v1/auth/resend-verification',
        );
        expect(ApiEndpoints.authGoogle, '/api/v1/auth/google');
        expect(ApiEndpoints.authApple, '/api/v1/auth/apple');
      });

      test('provider endpoints have correct paths', () {
        expect(ApiEndpoints.providers, '/api/v1/accounts/me/providers');
        expect(
          ApiEndpoints.linkEmailProvider,
          '/api/v1/auth/providers/email/link',
        );
        expect(
          ApiEndpoints.linkGoogleProvider,
          '/api/v1/auth/providers/google/link',
        );
        expect(
          ApiEndpoints.linkAppleProvider,
          '/api/v1/auth/providers/apple/link',
        );
      });

      test('tenant endpoints have correct paths', () {
        expect(ApiEndpoints.tenants, '/api/v1/accounts/me/tenants');
        expect(ApiEndpoints.switchTenant, '/api/v1/auth/switch-tenant');
      });

      test('account and profile endpoints have correct paths', () {
        expect(ApiEndpoints.account, '/api/v1/accounts/me');
        expect(ApiEndpoints.profile, '/api/v1/accounts/me/profile');
      });

      test('session endpoints have correct paths', () {
        expect(ApiEndpoints.sessions, '/api/v1/accounts/me/sessions');
        expect(
          ApiEndpoints.sessionsOthers,
          '/api/v1/accounts/me/sessions/others',
        );
      });

      test('audit endpoint has correct path', () {
        expect(ApiEndpoints.auditLogs, '/api/v1/audit/logs');
      });

      test('device endpoints have correct paths', () {
        expect(ApiEndpoints.pushToken, '/api/v1/devices/me/push-token');
        expect(
          ApiEndpoints.deviceApprovalRequest,
          '/api/v1/device-approvals/request',
        );
      });

      test('resource collection endpoints have correct paths', () {
        expect(ApiEndpoints.categories, '/api/v1/categories');
        expect(ApiEndpoints.inventories, '/api/v1/inventories');
        expect(ApiEndpoints.formulas, '/api/v1/formulas');
        expect(ApiEndpoints.tasks, '/api/v1/tasks');
      });
    });

    group('dynamic endpoint methods', () {
      test('unlinkProvider builds correct path', () {
        expect(
          ApiEndpoints.unlinkProvider('google'),
          '/api/v1/auth/providers/google',
        );
      });

      test('deviceApproval methods build correct paths', () {
        expect(
          ApiEndpoints.deviceApprovalApprove('req-001'),
          '/api/v1/device-approvals/req-001/approve',
        );
        expect(
          ApiEndpoints.deviceApprovalReject('req-001'),
          '/api/v1/device-approvals/req-001/reject',
        );
        expect(
          ApiEndpoints.deviceApprovalStatus('req-001'),
          '/api/v1/device-approvals/req-001/status',
        );
      });

      test('category builds correct path', () {
        expect(ApiEndpoints.category('cat-001'), '/api/v1/categories/cat-001');
      });

      test('inventory methods build correct paths', () {
        expect(
          ApiEndpoints.inventory('inv-001'),
          '/api/v1/inventories/inv-001',
        );
        expect(
          ApiEndpoints.inventoryImage('inv-001'),
          '/api/v1/inventories/inv-001/image',
        );
      });

      test('formula methods build correct paths', () {
        expect(ApiEndpoints.formula('frm-001'), '/api/v1/formulas/frm-001');
        expect(
          ApiEndpoints.formulaItems('frm-001'),
          '/api/v1/formulas/frm-001/items',
        );
        expect(
          ApiEndpoints.formulaItemsReorder('frm-001'),
          '/api/v1/formulas/frm-001/items/reorder',
        );
        expect(
          ApiEndpoints.formulaItem('frm-001', 'item-001'),
          '/api/v1/formulas/frm-001/items/item-001',
        );
      });

      test('task methods build correct paths', () {
        expect(ApiEndpoints.task('task-001'), '/api/v1/tasks/task-001');
        expect(
          ApiEndpoints.taskCancel('task-001'),
          '/api/v1/tasks/task-001/cancel',
        );
      });
    });
  });
}
