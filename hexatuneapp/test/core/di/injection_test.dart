// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';

void main() {
  group('DI injection', () {
    test('getIt is a valid GetIt instance', () {
      expect(getIt, isNotNull);
    });

    test('configureDependencies function is callable', () {
      expect(configureDependencies, isA<Function>());
    });
  });
}
