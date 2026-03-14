// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/models/problem_details.dart';

void main() {
  group('ProblemDetails', () {
    test('fromJson with all fields', () {
      final json = {
        'type': 'https://example.com/not-found',
        'title': 'Not Found',
        'status': 404,
        'detail': 'The resource was not found.',
        'trace_id': 'trace-xyz-123',
      };
      final problem = ProblemDetails.fromJson(json);
      expect(problem.type, 'https://example.com/not-found');
      expect(problem.title, 'Not Found');
      expect(problem.status, 404);
      expect(problem.detail, 'The resource was not found.');
      expect(problem.traceId, 'trace-xyz-123');
    });

    test('fromJson without trace_id', () {
      final json = {
        'type': 'https://example.com/bad-request',
        'title': 'Bad Request',
        'status': 400,
        'detail': 'Invalid input.',
      };
      final problem = ProblemDetails.fromJson(json);
      expect(problem.type, 'https://example.com/bad-request');
      expect(problem.title, 'Bad Request');
      expect(problem.status, 400);
      expect(problem.detail, 'Invalid input.');
      expect(problem.traceId, isNull);
    });

    test('toJson produces correct keys including snake_case trace_id', () {
      const problem = ProblemDetails(
        type: 'https://example.com/error',
        title: 'Error',
        status: 500,
        detail: 'Internal error.',
        traceId: 'trace-001',
      );
      final json = problem.toJson();
      expect(json['type'], 'https://example.com/error');
      expect(json['title'], 'Error');
      expect(json['status'], 500);
      expect(json['detail'], 'Internal error.');
      expect(json['trace_id'], 'trace-001');
    });

    test('toJson round-trip preserves values', () {
      const original = ProblemDetails(
        type: 'https://example.com/conflict',
        title: 'Conflict',
        status: 409,
        detail: 'Duplicate entry.',
        traceId: 'trace-round',
      );
      final json = original.toJson();
      final restored = ProblemDetails.fromJson(json);
      expect(restored, original);
    });
  });
}
