// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';

void main() {
  group('LogCategory', () {
    test('has all expected values', () {
      expect(LogCategory.values, hasLength(14));
    });

    test('contains all required categories', () {
      final names = LogCategory.values.map((c) => c.name).toSet();
      expect(names, contains('app'));
      expect(names, contains('network'));
      expect(names, contains('auth'));
      expect(names, contains('storage'));
      expect(names, contains('notification'));
      expect(names, contains('media'));
      expect(names, contains('device'));
      expect(names, contains('permission'));
      expect(names, contains('router'));
      expect(names, contains('bootstrap'));
      expect(names, contains('ui'));
      expect(names, contains('hardware'));
      expect(names, contains('dsp'));
      expect(names, contains('payment'));
    });

    test('each value has unique name', () {
      final names = LogCategory.values.map((c) => c.name).toList();
      expect(names.toSet().length, names.length);
    });

    test('values can be accessed by name', () {
      expect(LogCategory.app.name, 'app');
      expect(LogCategory.network.name, 'network');
      expect(LogCategory.hardware.name, 'hardware');
    });
  });
}
