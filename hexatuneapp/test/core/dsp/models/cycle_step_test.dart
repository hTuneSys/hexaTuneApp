// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';

void main() {
  group('CycleStep', () {
    test('can be created with required fields', () {
      const step = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      expect(step.frequencyDelta, 5.0);
      expect(step.durationSeconds, 30.0);
      expect(step.oneshot, isFalse);
    });

    test('oneshot defaults to false', () {
      const step = CycleStep(frequencyDelta: 0.0, durationSeconds: 1.0);
      expect(step.oneshot, false);
    });

    test('can be created with oneshot true', () {
      const step = CycleStep(
        frequencyDelta: 10.0,
        durationSeconds: 60.0,
        oneshot: true,
      );
      expect(step.oneshot, isTrue);
      expect(step.frequencyDelta, 10.0);
      expect(step.durationSeconds, 60.0);
    });

    test('supports negative frequency delta', () {
      const step = CycleStep(frequencyDelta: -3.5, durationSeconds: 15.0);
      expect(step.frequencyDelta, -3.5);
    });

    test('equality works correctly', () {
      const a = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      const b = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      expect(a, equals(b));
    });

    test('inequality when fields differ', () {
      const a = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      const b = CycleStep(frequencyDelta: 5.0, durationSeconds: 31.0);
      expect(a, isNot(equals(b)));
    });

    test('inequality when oneshot differs', () {
      const a = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      const b = CycleStep(
        frequencyDelta: 5.0,
        durationSeconds: 30.0,
        oneshot: true,
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith creates modified copy', () {
      const original = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      final modified = original.copyWith(frequencyDelta: 10.0);
      expect(modified.frequencyDelta, 10.0);
      expect(modified.durationSeconds, 30.0);
      expect(modified.oneshot, isFalse);
    });

    test('copyWith preserves unmodified fields', () {
      const original = CycleStep(
        frequencyDelta: 5.0,
        durationSeconds: 30.0,
        oneshot: true,
      );
      final modified = original.copyWith(durationSeconds: 60.0);
      expect(modified.frequencyDelta, 5.0);
      expect(modified.durationSeconds, 60.0);
      expect(modified.oneshot, isTrue);
    });

    test('toString produces readable output', () {
      const step = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      final str = step.toString();
      expect(str, contains('CycleStep'));
      expect(str, contains('5.0'));
      expect(str, contains('30.0'));
    });

    test('hashCode consistent with equality', () {
      const a = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      const b = CycleStep(frequencyDelta: 5.0, durationSeconds: 30.0);
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
