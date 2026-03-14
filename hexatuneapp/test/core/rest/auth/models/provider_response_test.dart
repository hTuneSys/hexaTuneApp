// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';

void main() {
  group('ProviderResponse', () {
    test('can be created with required fields', () {
      final result = const ProviderResponse(
        providerType: 'google',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.providerType, 'google');
      expect(result.linkedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const ProviderResponse(
        providerType: 'google',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['providerType'], 'google');
      expect(json['linkedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'providerType': 'google',
        'linkedAt': '2026-01-01T00:00:00Z',
      };
      final result = ProviderResponse.fromJson(json);
      expect(result.providerType, 'google');
      expect(result.linkedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = const ProviderResponse(
        providerType: 'google',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      final b = const ProviderResponse(
        providerType: 'google',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      final c = const ProviderResponse(
        providerType: 'different',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ProviderResponse(
        providerType: 'google',
        linkedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = ProviderResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
