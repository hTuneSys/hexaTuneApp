// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';

void main() {
  group('AuditLogDto', () {
    test('fromJson with all fields', () {
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
      expect(dto.resourceId, 'sess-001');
      expect(dto.outcome, 'success');
      expect(dto.severity, 'info');
      expect(dto.traceId, 'trace-001');
      expect(dto.containsPii, false);
      expect(dto.occurredAt, '2025-01-01T00:00:00Z');
      expect(dto.createdAt, '2025-01-01T00:00:01Z');
    });

    test('fromJson with optional fields absent', () {
      final json = {
        'id': 'log-002',
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

    test('toJson produces correct keys', () {
      const dto = AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        actorId: 'user-001',
        action: 'login',
        resourceType: 'session',
        resourceId: 'sess-001',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2025-01-01T00:00:00Z',
        createdAt: '2025-01-01T00:00:01Z',
      );
      final json = dto.toJson();
      expect(json['id'], 'log-001');
      expect(json['tenantId'], 'tenant-001');
      expect(json['actorType'], 'user');
      expect(json['actorId'], 'user-001');
      expect(json['action'], 'login');
      expect(json['resourceType'], 'session');
      expect(json['resourceId'], 'sess-001');
      expect(json['outcome'], 'success');
      expect(json['severity'], 'info');
      expect(json['traceId'], 'trace-001');
      expect(json['containsPii'], false);
      expect(json['occurredAt'], '2025-01-01T00:00:00Z');
      expect(json['createdAt'], '2025-01-01T00:00:01Z');
    });

    test('round-trip preserves values', () {
      const original = AuditLogDto(
        id: 'i',
        tenantId: 't',
        actorType: 'at',
        action: 'a',
        resourceType: 'rt',
        outcome: 'o',
        severity: 's',
        traceId: 'tr',
        containsPii: true,
        occurredAt: 'oa',
        createdAt: 'ca',
      );
      final restored = AuditLogDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('AuditLogQueryParams', () {
    test('toQueryParameters includes only non-null values', () {
      const params = AuditLogQueryParams(actorType: 'user', action: 'login');
      final query = params.toQueryParameters();
      expect(query['actorType'], 'user');
      expect(query['action'], 'login');
      expect(query.containsKey('resourceType'), false);
      expect(query.containsKey('outcome'), false);
      expect(query.containsKey('severity'), false);
      expect(query.containsKey('from'), false);
      expect(query.containsKey('to'), false);
    });

    test('toQueryParameters with all values', () {
      const params = AuditLogQueryParams(
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        from: '2025-01-01T00:00:00Z',
        to: '2025-12-31T23:59:59Z',
      );
      final query = params.toQueryParameters();
      expect(query.length, 7);
      expect(query['actorType'], 'user');
      expect(query['action'], 'login');
      expect(query['resourceType'], 'session');
      expect(query['outcome'], 'success');
      expect(query['severity'], 'info');
      expect(query['from'], '2025-01-01T00:00:00Z');
      expect(query['to'], '2025-12-31T23:59:59Z');
    });

    test('toQueryParameters with no values returns empty map', () {
      const params = AuditLogQueryParams();
      final query = params.toQueryParameters();
      expect(query, isEmpty);
    });
  });
}
