// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';

/// DIO interceptor that captures full request/response details into
/// [DebugLogBuffer] for the debug log monitor page.
///
/// Works in ALL environments (dev, test, stage, prod) since the buffer
/// is independent of [LogService] settings. Intended as a temporary
/// debugging aid — remove when no longer needed.
class DebugDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buf = StringBuffer()
      ..writeln('→ ${options.method} ${options.uri}')
      ..writeln('  Headers: ${_safeEncode(options.headers)}');

    if (options.data != null) {
      if (options.data is FormData) {
        final fd = options.data as FormData;
        buf.writeln(
          '  Body: [FormData] fields=${fd.fields.length}, '
          'files=${fd.files.length}',
        );
        for (final field in fd.fields) {
          buf.writeln('    field: ${field.key}=${field.value}');
        }
        for (final file in fd.files) {
          buf.writeln(
            '    file: ${file.key} → ${file.value.filename} '
            '(${file.value.length} bytes)',
          );
        }
      } else {
        buf.writeln('  Body: ${_safeEncode(options.data)}');
      }
    }

    DebugLogBuffer.instance.add('HTTP-REQ', buf.toString().trimRight());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buf = StringBuffer()
      ..writeln(
        '← ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}',
      )
      ..writeln('  Headers: ${_safeEncode(response.headers.map)}')
      ..writeln('  Body: ${_safeEncode(response.data)}');

    DebugLogBuffer.instance.add('HTTP-RES', buf.toString().trimRight());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buf = StringBuffer()
      ..writeln(
        '✗ ${err.type.name} ${err.requestOptions.method} '
        '${err.requestOptions.uri}',
      )
      ..writeln('  Message: ${err.message}');

    if (err.response != null) {
      buf
        ..writeln('  Status: ${err.response?.statusCode}')
        ..writeln('  Body: ${_safeEncode(err.response?.data)}');
    }
    if (err.error != null) {
      buf.writeln('  Error: ${err.error}');
    }

    DebugLogBuffer.instance.add('HTTP-ERR', buf.toString().trimRight());
    handler.next(err);
  }

  String _safeEncode(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is String) return data;
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
