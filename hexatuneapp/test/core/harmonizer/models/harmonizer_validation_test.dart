// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_validation.dart';

void main() {
  group('HarmonizerValidation', () {
    test('has four values', () {
      expect(HarmonizerValidation.values, hasLength(4));
    });

    test('valid is first', () {
      expect(HarmonizerValidation.values.first, HarmonizerValidation.valid);
    });

    test('all values are distinct', () {
      final names = HarmonizerValidation.values.map((v) => v.name).toSet();
      expect(names.length, HarmonizerValidation.values.length);
    });
  });
}
