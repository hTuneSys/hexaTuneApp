// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';
import 'package:hexatuneapp/src/core/media/image_utils.dart';

void main() {
  group('ImageUtils.calculateTargetDimensions', () {
    test('throws ArgumentError for zero width', () {
      expect(
        () => ImageUtils.calculateTargetDimensions(
          sourceWidth: 0,
          sourceHeight: 100,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for zero height', () {
      expect(
        () => ImageUtils.calculateTargetDimensions(
          sourceWidth: 100,
          sourceHeight: 0,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for negative dimensions', () {
      expect(
        () => ImageUtils.calculateTargetDimensions(
          sourceWidth: -1,
          sourceHeight: 100,
        ),
        throwsArgumentError,
      );
      expect(
        () => ImageUtils.calculateTargetDimensions(
          sourceWidth: 100,
          sourceHeight: -5,
        ),
        throwsArgumentError,
      );
    });

    test('16:9 source at max size remains unchanged', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1920,
        sourceHeight: 1080,
      );
      expect(result.width, 1920);
      expect(result.height, 1080);
    });

    test('wider-than-16:9 source fits by height', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 2520,
        sourceHeight: 1080,
      );
      // Fit by height: 1080 * (16/9) = 1920
      expect(result.width, 1920);
      expect(result.height, 1080);
    });

    test('taller-than-16:9 source fits by width', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1200,
        sourceHeight: 900,
      );
      // Fit by width: 1200 / (16/9) = 675
      expect(result.width, 1200);
      expect(result.height, 675);
    });

    test('square source produces 16:9 output', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1000,
        sourceHeight: 1000,
      );
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });

    test('portrait source produces 16:9 output', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 1080,
        sourceHeight: 1920,
      );
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });

    test('oversized source is clamped to max dimensions', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 4000,
        sourceHeight: 3000,
      );
      expect(result.width, lessThanOrEqualTo(AppConstants.imageMaxWidth));
      expect(result.height, lessThanOrEqualTo(AppConstants.imageMaxHeight));
    });

    test('oversized source maintains approximately 16:9 ratio', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 5000,
        sourceHeight: 5000,
      );
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });

    test('small source preserves 16:9 without exceeding source width', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 320,
        sourceHeight: 240,
      );
      expect(result.width, lessThanOrEqualTo(320));
      final ratio = result.width / result.height;
      expect(ratio, closeTo(16.0 / 9.0, 0.02));
    });

    test('exact 16:9 small source stays unchanged', () {
      final result = ImageUtils.calculateTargetDimensions(
        sourceWidth: 160,
        sourceHeight: 90,
      );
      expect(result.width, 160);
      expect(result.height, 90);
    });
  });
}
