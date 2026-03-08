// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/tenant_membership_response.dart';

void main() {
  group('TenantMembershipResponse', () {
    test('can be created with required fields', () {
      final result = const TenantMembershipResponse(
        id: 'membership-001',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      expect(result.id, 'membership-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.role, 'admin');
      expect(result.status, 'active');
      expect(result.isOwner, true);
    });

    test('serializes to JSON correctly', () {
      final result = const TenantMembershipResponse(
        id: 'membership-001',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      final json = result.toJson();
      expect(json['id'], 'membership-001');
      expect(json['tenantId'], 'tenant-001');
      expect(json['role'], 'admin');
      expect(json['status'], 'active');
      expect(json['isOwner'], true);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'membership-001',
        'tenantId': 'tenant-001',
        'role': 'admin',
        'status': 'active',
        'isOwner': true,
      };
      final result = TenantMembershipResponse.fromJson(json);
      expect(result.id, 'membership-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.role, 'admin');
      expect(result.status, 'active');
      expect(result.isOwner, true);
    });

    test('equality works correctly', () {
      final a = const TenantMembershipResponse(
        id: 'membership-001',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      final b = const TenantMembershipResponse(
        id: 'membership-001',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      final c = const TenantMembershipResponse(
        id: 'different',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const TenantMembershipResponse(
        id: 'membership-001',
        tenantId: 'tenant-001',
        role: 'admin',
        status: 'active',
        isOwner: true,
      );
      final roundTripped = TenantMembershipResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
