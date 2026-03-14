// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';

void main() {
  group('AuditLogQueryParams', () {
    test('can be created with all fields', () {
      const params = AuditLogQueryParams(
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        from: '2026-01-01T00:00:00Z',
        to: '2026-12-31T23:59:59Z',
      );
      expect(params.actorType, 'user');
      expect(params.action, 'login');
      expect(params.resourceType, 'session');
      expect(params.outcome, 'success');
      expect(params.severity, 'info');
      expect(params.from, '2026-01-01T00:00:00Z');
      expect(params.to, '2026-12-31T23:59:59Z');
    });

    test('can be created with no fields', () {
      const params = AuditLogQueryParams();
      expect(params.actorType, isNull);
      expect(params.action, isNull);
    });

    test('toQueryParameters includes only non-null values', () {
      const params = AuditLogQueryParams(actorType: 'user', action: 'login');
      final map = params.toQueryParameters();
      expect(map, {'actorType': 'user', 'action': 'login'});
      expect(map.containsKey('resourceType'), isFalse);
    });

    test('toQueryParameters returns empty map when all null', () {
      const params = AuditLogQueryParams();
      expect(params.toQueryParameters(), isEmpty);
    });

    test('toQueryParameters includes all non-null values', () {
      const params = AuditLogQueryParams(
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        from: '2026-01-01T00:00:00Z',
        to: '2026-12-31T23:59:59Z',
      );
      final map = params.toQueryParameters();
      expect(map.length, 7);
      expect(map['actorType'], 'user');
      expect(map['from'], '2026-01-01T00:00:00Z');
    });
  });
}
