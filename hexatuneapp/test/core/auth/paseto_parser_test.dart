// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/auth/paseto_parser.dart';

void main() {
  group('PasetoParser', () {
    // Build a valid PASETO v4.public token with known claims.
    String buildTestToken(Map<String, dynamic> claims) {
      final messageBytes = utf8.encode(json.encode(claims));
      // Append 64 zero-bytes as a dummy signature.
      final payload = [...messageBytes, ...List<int>.filled(64, 0)];
      final encoded = base64Url.encode(payload);
      return 'v4.public.$encoded';
    }

    group('parseClaims', () {
      test('parses valid PASETO v4.public token', () {
        final claims = {
          'exp': '2026-03-03T04:54:54+00:00',
          'iat': '2026-03-03T04:39:54+00:00',
          'sub': '019cb1fb-023c-77f3-be83-d9e1bb442221',
          'role': 'owner',
          'sid': '019cb1fe-d6a8-7683-9aa1-265b865d4710',
          'tid': '019cb1fa-fbc4-71f1-82cf-94f7258e6cab',
        };
        final token = buildTestToken(claims);
        final parsed = PasetoParser.parseClaims(token);

        expect(parsed, isNotNull);
        expect(parsed!['exp'], '2026-03-03T04:54:54+00:00');
        expect(parsed['sub'], '019cb1fb-023c-77f3-be83-d9e1bb442221');
        expect(parsed['role'], 'owner');
      });

      test('returns null for non-PASETO token', () {
        expect(PasetoParser.parseClaims('not-a-paseto-token'), isNull);
        expect(PasetoParser.parseClaims('v3.public.abc'), isNull);
        expect(PasetoParser.parseClaims('Bearer xyz'), isNull);
      });

      test('returns null for truncated payload', () {
        // Payload shorter than 64 bytes (signature length).
        final shortPayload = base64Url.encode(List<int>.filled(32, 0));
        expect(PasetoParser.parseClaims('v4.public.$shortPayload'), isNull);
      });

      test('returns null for invalid base64', () {
        expect(PasetoParser.parseClaims('v4.public.!!!invalid!!!'), isNull);
      });
    });

    group('parseExpiry', () {
      test('returns DateTime for valid exp claim', () {
        final token = buildTestToken({
          'exp': '2026-03-03T04:54:54+00:00',
        });
        final expiry = PasetoParser.parseExpiry(token);

        expect(expiry, isNotNull);
        expect(expiry!.year, 2026);
        expect(expiry.month, 3);
        expect(expiry.day, 3);
      });

      test('returns null when no exp claim', () {
        final token = buildTestToken({'sub': 'test'});
        expect(PasetoParser.parseExpiry(token), isNull);
      });

      test('returns null for unparseable exp string', () {
        final token = buildTestToken({'exp': 'not-a-date'});
        expect(PasetoParser.parseExpiry(token), isNull);
      });

      test('returns null for invalid token', () {
        expect(PasetoParser.parseExpiry('invalid'), isNull);
      });
    });
  });
}
