// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';

void main() {
  group('AuditLogDto', () {
    test('can be created with required fields', () {
      final result = const AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'log-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.actorType, 'user');
      expect(result.action, 'login');
      expect(result.resourceType, 'session');
      expect(result.outcome, 'success');
      expect(result.severity, 'info');
      expect(result.traceId, 'trace-001');
      expect(result.containsPii, false);
      expect(result.occurredAt, '2026-01-01T00:00:00Z');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'log-001');
      expect(json['tenantId'], 'tenant-001');
      expect(json['actorType'], 'user');
      expect(json['action'], 'login');
      expect(json['resourceType'], 'session');
      expect(json['outcome'], 'success');
      expect(json['severity'], 'info');
      expect(json['traceId'], 'trace-001');
      expect(json['containsPii'], false);
      expect(json['occurredAt'], '2026-01-01T00:00:00Z');
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'log-001',
        'tenantId': 'tenant-001',
        'actorType': 'user',
        'action': 'login',
        'resourceType': 'session',
        'outcome': 'success',
        'severity': 'info',
        'traceId': 'trace-001',
        'containsPii': false,
        'occurredAt': '2026-01-01T00:00:00Z',
        'createdAt': '2026-01-01T00:00:00Z',
      };
      final result = AuditLogDto.fromJson(json);
      expect(result.id, 'log-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.actorType, 'user');
      expect(result.action, 'login');
      expect(result.resourceType, 'session');
      expect(result.outcome, 'success');
      expect(result.severity, 'info');
      expect(result.traceId, 'trace-001');
      expect(result.containsPii, false);
      expect(result.occurredAt, '2026-01-01T00:00:00Z');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = const AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      final b = const AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      final c = const AuditLogDto(
        id: 'different',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const AuditLogDto(
        id: 'log-001',
        tenantId: 'tenant-001',
        actorType: 'user',
        action: 'login',
        resourceType: 'session',
        outcome: 'success',
        severity: 'info',
        traceId: 'trace-001',
        containsPii: false,
        occurredAt: '2026-01-01T00:00:00Z',
        createdAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = AuditLogDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
