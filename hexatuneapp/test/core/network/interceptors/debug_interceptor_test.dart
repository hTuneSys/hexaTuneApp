// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';
import 'package:hexatuneapp/src/core/network/interceptors/debug_interceptor.dart';

void main() {
  group('DebugDioInterceptor', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      DebugLogBuffer.instance.clear();
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      dio.interceptors.insert(0, DebugDioInterceptor());
    });

    group('onRequest', () {
      test('captures request to DebugLogBuffer with HTTP-REQ level', () async {
        dioAdapter.onGet('/items', (server) => server.reply(200, {'ok': true}));

        await dio.get('/items');

        final entries = DebugLogBuffer.instance.entries
            .where((e) => e.level == 'HTTP-REQ')
            .toList();
        expect(entries, isNotEmpty);
        expect(entries.last.message, contains('GET'));
        expect(entries.last.message, contains('/items'));
      });

      test('captures request headers', () async {
        dioAdapter.onGet('/test', (server) => server.reply(200, null));

        await dio.get('/test');

        final entry = DebugLogBuffer.instance.entries.firstWhere(
          (e) => e.level == 'HTTP-REQ',
        );
        expect(entry.message, contains('Headers:'));
      });

      test('captures request body for POST', () async {
        dioAdapter.onPost(
          '/create',
          (server) => server.reply(201, {'id': '1'}),
          data: {'name': 'test'},
        );

        await dio.post('/create', data: {'name': 'test'});

        final entry = DebugLogBuffer.instance.entries.firstWhere(
          (e) => e.level == 'HTTP-REQ',
        );
        expect(entry.message, contains('Body:'));
      });
    });

    group('onResponse', () {
      test('captures response to DebugLogBuffer with HTTP-RES level', () async {
        dioAdapter.onGet(
          '/data',
          (server) => server.reply(200, {'result': 42}),
        );

        await dio.get('/data');

        final entries = DebugLogBuffer.instance.entries
            .where((e) => e.level == 'HTTP-RES')
            .toList();
        expect(entries, isNotEmpty);
        expect(entries.last.message, contains('200'));
        expect(entries.last.message, contains('/data'));
      });

      test('captures response body', () async {
        dioAdapter.onGet(
          '/info',
          (server) => server.reply(200, {'key': 'value'}),
        );

        await dio.get('/info');

        final entry = DebugLogBuffer.instance.entries.firstWhere(
          (e) => e.level == 'HTTP-RES',
        );
        expect(entry.message, contains('Body:'));
      });
    });

    group('onError', () {
      test('captures error to DebugLogBuffer with HTTP-ERR level', () async {
        dioAdapter.onGet(
          '/fail',
          (server) => server.reply(500, {'error': 'server down'}),
        );

        try {
          await dio.get('/fail');
        } on DioException {
          // Expected.
        }

        final entries = DebugLogBuffer.instance.entries
            .where((e) => e.level == 'HTTP-ERR')
            .toList();
        expect(entries, isNotEmpty);
        expect(entries.last.message, contains('/fail'));
      });

      test('captures error status code', () async {
        dioAdapter.onGet(
          '/not-found',
          (server) => server.reply(404, {'error': 'not found'}),
        );

        try {
          await dio.get('/not-found');
        } on DioException {
          // Expected.
        }

        final entries = DebugLogBuffer.instance.entries
            .where((e) => e.level == 'HTTP-ERR')
            .toList();
        expect(entries, isNotEmpty);
        expect(entries.last.message, contains('404'));
      });
    });

    group('request and response captured together', () {
      test('both HTTP-REQ and HTTP-RES entries are created', () async {
        dioAdapter.onGet('/both', (server) => server.reply(200, 'ok'));

        await dio.get('/both');

        final levels = DebugLogBuffer.instance.entries
            .map((e) => e.level)
            .toList();
        expect(levels, contains('HTTP-REQ'));
        expect(levels, contains('HTTP-RES'));
      });
    });
  });
}
