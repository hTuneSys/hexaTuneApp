// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';

void main() {
  group('BootstrapStepStatus', () {
    test('has exactly four values', () {
      expect(BootstrapStepStatus.values, hasLength(4));
    });

    test('contains pending', () {
      expect(BootstrapStepStatus.values, contains(BootstrapStepStatus.pending));
    });

    test('contains running', () {
      expect(BootstrapStepStatus.values, contains(BootstrapStepStatus.running));
    });

    test('contains done', () {
      expect(BootstrapStepStatus.values, contains(BootstrapStepStatus.done));
    });

    test('contains error', () {
      expect(BootstrapStepStatus.values, contains(BootstrapStepStatus.error));
    });

    test('values are in expected order', () {
      expect(BootstrapStepStatus.values, [
        BootstrapStepStatus.pending,
        BootstrapStepStatus.running,
        BootstrapStepStatus.done,
        BootstrapStepStatus.error,
      ]);
    });
  });

  group('BootstrapStep', () {
    test('can be created with label only', () {
      const step = BootstrapStep(label: 'Initialize DI');
      expect(step.label, 'Initialize DI');
      expect(step.status, BootstrapStepStatus.pending);
      expect(step.error, isNull);
    });

    test('can be created with all fields', () {
      const step = BootstrapStep(
        label: 'Load config',
        status: BootstrapStepStatus.error,
        error: 'Config file not found',
      );
      expect(step.label, 'Load config');
      expect(step.status, BootstrapStepStatus.error);
      expect(step.error, 'Config file not found');
    });

    test('defaults status to pending', () {
      const step = BootstrapStep(label: 'Test step');
      expect(step.status, BootstrapStepStatus.pending);
    });

    test('defaults error to null', () {
      const step = BootstrapStep(label: 'Test step');
      expect(step.error, isNull);
    });

    group('copyWith', () {
      test('copies with new status', () {
        const original = BootstrapStep(label: 'Step A');
        final updated = original.copyWith(status: BootstrapStepStatus.running);

        expect(updated.label, 'Step A');
        expect(updated.status, BootstrapStepStatus.running);
        expect(updated.error, isNull);
      });

      test('copies with new error', () {
        const original = BootstrapStep(label: 'Step B');
        final updated = original.copyWith(error: 'Something failed');

        expect(updated.label, 'Step B');
        expect(updated.status, BootstrapStepStatus.pending);
        expect(updated.error, 'Something failed');
      });

      test('copies with both status and error', () {
        const original = BootstrapStep(label: 'Step C');
        final updated = original.copyWith(
          status: BootstrapStepStatus.error,
          error: 'Timeout',
        );

        expect(updated.label, 'Step C');
        expect(updated.status, BootstrapStepStatus.error);
        expect(updated.error, 'Timeout');
      });

      test('preserves status when not provided', () {
        const original = BootstrapStep(
          label: 'Step D',
          status: BootstrapStepStatus.done,
        );
        final updated = original.copyWith(error: 'note');

        expect(updated.status, BootstrapStepStatus.done);
      });

      test('preserves label when copying', () {
        const original = BootstrapStep(label: 'Original Label');
        final updated = original.copyWith(status: BootstrapStepStatus.done);

        expect(updated.label, 'Original Label');
      });

      test('does not carry over previous error when not specified', () {
        const original = BootstrapStep(
          label: 'Step E',
          status: BootstrapStepStatus.error,
          error: 'Old error',
        );
        // copyWith without error passes null, which replaces the old error
        final updated = original.copyWith(status: BootstrapStepStatus.running);

        expect(updated.error, isNull);
      });
    });
  });

  group('BootstrapProgressCallback', () {
    test('typedef is callable with required arguments', () {
      var callCount = 0;
      void callback(
        int stepIndex,
        BootstrapStepStatus status, [
        String? error,
      ]) {
        callCount++;
      }

      callback(0, BootstrapStepStatus.running);
      callback(1, BootstrapStepStatus.error, 'fail');
      expect(callCount, 2);
    });

    test('callback receives correct arguments', () {
      int? capturedIndex;
      BootstrapStepStatus? capturedStatus;
      String? capturedError;

      void callback(
        int stepIndex,
        BootstrapStepStatus status, [
        String? error,
      ]) {
        capturedIndex = stepIndex;
        capturedStatus = status;
        capturedError = error;
      }

      callback(3, BootstrapStepStatus.done, 'info');
      expect(capturedIndex, 3);
      expect(capturedStatus, BootstrapStepStatus.done);
      expect(capturedError, 'info');
    });

    test('callback error argument is optional', () {
      String? capturedError = 'initial';

      void callback(
        int stepIndex,
        BootstrapStepStatus status, [
        String? error,
      ]) {
        capturedError = error;
      }

      callback(0, BootstrapStepStatus.pending);
      expect(capturedError, isNull);
    });
  });
}
