// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';

void main() {
  group('GenerationType', () {
    group('isActive', () {
      test('monaural is active', () {
        expect(GenerationType.monaural.isActive, isTrue);
      });

      test('binaural is active', () {
        expect(GenerationType.binaural.isActive, isTrue);
      });

      test('magnetic is active', () {
        expect(GenerationType.magnetic.isActive, isTrue);
      });

      test('photonic is not active', () {
        expect(GenerationType.photonic.isActive, isFalse);
      });

      test('quantal is not active', () {
        expect(GenerationType.quantal.isActive, isFalse);
      });
    });

    group('requiresHeadset', () {
      test('only binaural requires headset', () {
        for (final type in GenerationType.values) {
          expect(
            type.requiresHeadset,
            type == GenerationType.binaural,
            reason: '${type.name}.requiresHeadset',
          );
        }
      });
    });

    group('requiresHexagen', () {
      test('only magnetic requires hexagen', () {
        for (final type in GenerationType.values) {
          expect(
            type.requiresHexagen,
            type == GenerationType.magnetic,
            reason: '${type.name}.requiresHexagen',
          );
        }
      });
    });

    group('supportsDspAmbience', () {
      test('monaural supports DSP ambience', () {
        expect(GenerationType.monaural.supportsDspAmbience, isTrue);
      });

      test('binaural supports DSP ambience', () {
        expect(GenerationType.binaural.supportsDspAmbience, isTrue);
      });

      test('magnetic does not support DSP ambience', () {
        expect(GenerationType.magnetic.supportsDspAmbience, isFalse);
      });

      test('photonic does not support DSP ambience', () {
        expect(GenerationType.photonic.supportsDspAmbience, isFalse);
      });

      test('quantal does not support DSP ambience', () {
        expect(GenerationType.quantal.supportsDspAmbience, isFalse);
      });
    });

    group('usesDsp', () {
      test('monaural uses DSP', () {
        expect(GenerationType.monaural.usesDsp, isTrue);
      });

      test('binaural uses DSP', () {
        expect(GenerationType.binaural.usesDsp, isTrue);
      });

      test('magnetic does not use DSP', () {
        expect(GenerationType.magnetic.usesDsp, isFalse);
      });

      test('photonic does not use DSP', () {
        expect(GenerationType.photonic.usesDsp, isFalse);
      });

      test('quantal does not use DSP', () {
        expect(GenerationType.quantal.usesDsp, isFalse);
      });
    });

    group('apiValue', () {
      test('monaural API value is Monaural', () {
        expect(GenerationType.monaural.apiValue, 'Monaural');
      });

      test('binaural API value is Binaural', () {
        expect(GenerationType.binaural.apiValue, 'Binaural');
      });

      test('magnetic API value is Magnetic', () {
        expect(GenerationType.magnetic.apiValue, 'Magnetic');
      });

      test('photonic API value is Photonic', () {
        expect(GenerationType.photonic.apiValue, 'Photonic');
      });

      test('quantal API value is Quantal', () {
        expect(GenerationType.quantal.apiValue, 'Quantal');
      });
    });
  });
}
