// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';

void main() {
  group('AuditLogDto', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'log-001',
        'tenantId': 'tenant-001',
        'actorType': 'user',
        'actorId': 'user-001',
        'action': 'login',
        'resourceType': 'session',
        'resourceId': 'sess-001',
        'outcome': 'success',
        'severity': 'info',
        'traceId': 'trace-001',
        'containsPii': false,
        'occurredAt': '2025-01-01T00:00:00Z',
        'createdAt': '2025-01-01T00:00:01Z',
      };
      final dto = AuditLogDto.fromJson(json);
      expect(dto.id, 'log-001');
      expect(dto.tenantId, 'tenant-001');
      expect(dto.actorType, 'user');
      expect(dto.actorId, 'user-001');
      expect(dto.action, 'login');
      expect(dto.resourceType, 'session');
      expect(dto.outcome, 'success');
      expect(dto.severity, 'info');
      expect(dto.containsPii, false);
    });

    test('toJson produces correct keys', () {
      const dto = AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: true,
        occurredAt: '2025-01-01T00:00:00Z',
        createdAt: '2025-01-01T00:00:01Z',
      );
      final json = dto.toJson();
      expect(json['id'], 'log-001');
      expect(json['tenantId'], 'tenant-001');
      expect(json['containsPii'], true);
    });

    test('optional fields default to null', () {
      final json = {
        'id': 'log-001',
        'tenantId': 'tenant-001',
        'actorType': 'system',
        'action': 'cleanup',
        'resourceType': 'task',
        'outcome': 'success',
        'severity': 'low',
        'traceId': 'trace-002',
        'containsPii': false,
        'occurredAt': '2025-01-01T00:00:00Z',
        'createdAt': '2025-01-01T00:00:01Z',
      };
      final dto = AuditLogDto.fromJson(json);
      expect(dto.actorId, isNull);
      expect(dto.resourceId, isNull);
    });
  });

  group('AuditLogQueryParams', () {
    test('toQueryParameters includes only non-null values', () {
      const params = AuditLogQueryParams(actorType: 'user', action: 'login');
      final queryMap = params.toQueryParameters();
      expect(queryMap, {'actorType': 'user', 'action': 'login'});
      expect(queryMap.containsKey('resourceType'), false);
      expect(queryMap.containsKey('outcome'), false);
    });

    test('toQueryParameters returns empty map when all null', () {
      const params = AuditLogQueryParams();
      final queryMap = params.toQueryParameters();
      expect(queryMap, isEmpty);
    });

    test('toQueryParameters includes all fields when set', () {
      const params = AuditLogQueryParams(
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        from: '2025-01-01',
        to: '2025-01-31',
      );
      final queryMap = params.toQueryParameters();
      expect(queryMap, hasLength(7));
      expect(queryMap['from'], '2025-01-01');
      expect(queryMap['to'], '2025-01-31');
    });
  });
}
