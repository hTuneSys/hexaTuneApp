// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';

void main() {
  group('AppBootstrap', () {
    test('initialize function is callable', () {
      expect(AppBootstrap.initialize, isA<Function>());
    });
  });
}
