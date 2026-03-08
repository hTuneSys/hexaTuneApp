// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_bindings.dart';

void main() {
  group('DspBindings FFI structs', () {
    group('HtdCycleItem', () {
      test('is a Struct subclass', () {
        expect(HtdCycleItem, isNotNull);
      });
    });

    group('HtdEngineConfig', () {
      test('is a Struct subclass', () {
        expect(HtdEngineConfig, isNotNull);
      });
    });

    group('HtdLayerConfig', () {
      test('is a Struct subclass', () {
        expect(HtdLayerConfig, isNotNull);
      });
    });

    group('HtdEventConfig', () {
      test('is a Struct subclass', () {
        expect(HtdEventConfig, isNotNull);
      });
    });

    group('HtdEngine', () {
      test('is an Opaque subclass', () {
        expect(HtdEngine, isNotNull);
      });
    });
  });
}
