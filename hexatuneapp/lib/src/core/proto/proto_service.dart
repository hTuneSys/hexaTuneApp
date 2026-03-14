// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/hexa_tune_proto_ffi.dart';

/// Singleton service that loads and holds the native hexaTuneProto FFI
/// instance.
///
/// On Android the shared library is loaded by name from `jniLibs/`.
/// On iOS the symbols are statically linked into the app binary.
@singleton
class ProtoService {
  ProtoService(this._logService);

  final LogService _logService;
  HexaTuneProto? _proto;

  /// The loaded native protocol instance.
  ///
  /// Throws [StateError] if [init] has not been called or the platform is
  /// unsupported.
  HexaTuneProto get proto {
    final p = _proto;
    if (p == null) {
      throw StateError('ProtoService has not been initialized');
    }
    return p;
  }

  /// Whether the native library has been loaded successfully.
  bool get isLoaded => _proto != null;

  /// Load the native library for the current platform.
  void init() {
    if (_proto != null) return;

    try {
      if (Platform.isAndroid) {
        _proto = HexaTuneProto('libhexa_tune_proto_ffi.so');
      } else if (Platform.isIOS) {
        _proto = HexaTuneProto.open();
      } else {
        throw UnsupportedError(
          'hexaTuneProto FFI is not supported on this platform',
        );
      }

      _logService.devLog(
        'ProtoService initialized (${Platform.operatingSystem})',
        category: LogCategory.hardware,
      );
    } catch (e, st) {
      _logService.warning(
        'ProtoService initialization failed: $e',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
