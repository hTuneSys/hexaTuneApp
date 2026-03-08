// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';

void main() {
  group('ImageUrlResponse', () {
    test('can be created with required fields', () {
      final result = const ImageUrlResponse(
        url: 'https://example.com/image.png',
      );
      expect(result.url, 'https://example.com/image.png');
    });

    test('serializes to JSON correctly', () {
      final result = const ImageUrlResponse(
        url: 'https://example.com/image.png',
      );
      final json = result.toJson();
      expect(json['url'], 'https://example.com/image.png');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'url': 'https://example.com/image.png'};
      final result = ImageUrlResponse.fromJson(json);
      expect(result.url, 'https://example.com/image.png');
    });

    test('equality works correctly', () {
      final a = const ImageUrlResponse(url: 'https://example.com/image.png');
      final b = const ImageUrlResponse(url: 'https://example.com/image.png');
      final c = const ImageUrlResponse(url: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ImageUrlResponse(
        url: 'https://example.com/image.png',
      );
      final roundTripped = ImageUrlResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
