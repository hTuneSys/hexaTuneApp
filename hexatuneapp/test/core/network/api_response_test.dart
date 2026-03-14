// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('success holds data', () {
      const response = ApiResponse<String>.success('hello');
      expect(response, isA<ApiSuccess<String>>());
      expect((response as ApiSuccess<String>).data, 'hello');
    });

    test('error holds message', () {
      const response = ApiResponse<String>.error('failed');
      expect(response, isA<ApiError<String>>());
      expect((response as ApiError<String>).message, 'failed');
    });

    test('error holds optional exception', () {
      final ex = Exception('boom');
      final response = ApiResponse<int>.error('failed', exception: ex);
      expect((response as ApiError<int>).exception, ex);
    });

    test('allows exhaustive switch', () {
      const ApiResponse<int> response = ApiResponse.success(42);
      final result = switch (response) {
        ApiSuccess(:final data) => 'data: $data',
        ApiError(:final message) => 'error: $message',
      };
      expect(result, 'data: 42');
    });
  });
}
