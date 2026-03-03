// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Wraps [TalkerDioLogger] so it can be injected into [ApiClient].
@singleton
class LoggingInterceptor {
  LoggingInterceptor(this._logService);

  final LogService _logService;

  late final TalkerDioLogger _interceptor;

  TalkerDioLogger get interceptor => _interceptor;

  @PostConstruct()
  void init() {
    _interceptor = TalkerDioLogger(
      talker: _logService.talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: Env.isDev,
        printResponseMessage: true,
        printRequestData: Env.isDev,
        printResponseData: Env.isDev,
      ),
    );
  }
}
