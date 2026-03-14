// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('network timeouts', () {
      test('connectTimeout is 15 seconds', () {
        expect(AppConstants.connectTimeout, const Duration(seconds: 15));
      });

      test('receiveTimeout is 30 seconds', () {
        expect(AppConstants.receiveTimeout, const Duration(seconds: 30));
      });

      test('sendTimeout is 30 seconds', () {
        expect(AppConstants.sendTimeout, const Duration(seconds: 30));
      });

      test('uploadTimeout is 60 seconds', () {
        expect(AppConstants.uploadTimeout, const Duration(seconds: 60));
      });
    });

    group('image processing', () {
      test('imageAspectRatio is 16:9', () {
        expect(AppConstants.imageAspectRatio, 16.0 / 9.0);
      });

      test('imageQuality is 85', () {
        expect(AppConstants.imageQuality, 85);
      });

      test('imageMaxWidth is 1920', () {
        expect(AppConstants.imageMaxWidth, 1920);
      });

      test('imageMaxHeight is 1080', () {
        expect(AppConstants.imageMaxHeight, 1080);
      });
    });

    group('logging', () {
      test('maxLogHistoryItems is 1000', () {
        expect(AppConstants.maxLogHistoryItems, 1000);
      });
    });
  });
}
