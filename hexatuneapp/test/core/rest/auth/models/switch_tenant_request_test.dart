// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_request.dart';

void main() {
  group('SwitchTenantRequest', () {
    test('can be created with required fields', () {
      final result = const SwitchTenantRequest(tenantId: 'tenant-002');
      expect(result.tenantId, 'tenant-002');
    });

    test('serializes to JSON correctly', () {
      final result = const SwitchTenantRequest(tenantId: 'tenant-002');
      final json = result.toJson();
      expect(json['tenantId'], 'tenant-002');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'tenantId': 'tenant-002'};
      final result = SwitchTenantRequest.fromJson(json);
      expect(result.tenantId, 'tenant-002');
    });

    test('equality works correctly', () {
      final a = const SwitchTenantRequest(tenantId: 'tenant-002');
      final b = const SwitchTenantRequest(tenantId: 'tenant-002');
      final c = const SwitchTenantRequest(tenantId: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const SwitchTenantRequest(tenantId: 'tenant-002');
      final roundTripped = SwitchTenantRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
