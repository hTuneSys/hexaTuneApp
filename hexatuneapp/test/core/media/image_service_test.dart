// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';
import 'package:hexatuneapp/src/core/media/image_utils.dart';

void main() {
  group('ImageUtils.calculateTargetDimensions', () {
    test('16:9 source remains unchanged (up to max)', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1920,
        sourceHeight: 1080,
      );
      expect(result.width, 1920);
      expect(result.height, 1080);
    });

    test('wider source (21:9) is cropped to 16:9', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 2520,
        sourceHeight: 1080,
      );
      // Fit by height: 1080 * 16/9 = 1920
      expect(result.width, 1920);
      expect(result.height, 1080);
    });

    test('taller source (4:3) is cropped to 16:9', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1200,
        sourceHeight: 900,
      );
      // Fit by width: 1200 / (16/9) = 675
      expect(result.width, 1200);
      expect(result.height, 675);
    });

    test('square source is cropped to 16:9', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1000,
        sourceHeight: 1000,
      );
      // Fit by width: 1000 / (16/9) = 562.5 → 563
      expect(result.width, 1000);
      expect(result.height, 563);
    });

    test('very tall (portrait) source is cropped to 16:9', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1080,
        sourceHeight: 1920,
      );
      // Fit by width: 1080 / (16/9) = 607.5 → 608
      expect(result.width, 1080);
      expect(result.height, 608);
    });

    test('large source is clamped to max dimensions', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 4000,
        sourceHeight: 3000,
      );
      expect(result.width, lessThanOrEqualTo(AppConstants.imageMaxWidth));
      expect(result.height, lessThanOrEqualTo(AppConstants.imageMaxHeight));
    });

    test('output aspect ratio is approximately 16:9', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 800,
        sourceHeight: 600,
      );
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });

    test('small source preserves 16:9 ratio', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 320,
        sourceHeight: 240,
      );
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });
  });
}
