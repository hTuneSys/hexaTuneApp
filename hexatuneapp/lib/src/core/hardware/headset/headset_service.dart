// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter_headset_detector/flutter_headset_detector.dart' as hd;
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/hardware/headset/headset_state.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Continuously monitors wired and Bluetooth headset connection status.
///
/// Exposes the current [HeadsetState] as a synchronous snapshot via
/// [currentState] and as a reactive broadcast [Stream] via [state].
/// State transitions are logged in development mode.
@singleton
class HeadsetService {
  HeadsetService(this._logService);

  final LogService _logService;
  final hd.HeadsetDetector _detector = hd.HeadsetDetector();

  final _stateController = StreamController<HeadsetState>.broadcast();

  HeadsetState _currentState = const HeadsetState();

  /// The current headset connection state.
  HeadsetState get currentState => _currentState;

  /// A broadcast stream of headset connection state changes.
  Stream<HeadsetState> get state => _stateController.stream;

  /// Whether any headset (wired or wireless) is connected.
  bool get isConnected => _currentState.isAnyConnected;

  /// Reads the initial headset state and starts listening for changes.
  Future<void> init() async {
    try {
      final initial = await _detector.getCurrentState;
      _updateState(
        HeadsetState(
          wiredConnected:
              initial[hd.HeadsetType.WIRED] == hd.HeadsetState.CONNECTED,
          wirelessConnected:
              initial[hd.HeadsetType.WIRELESS] == hd.HeadsetState.CONNECTED,
        ),
      );

      _detector.setListener(_onHeadsetEvent);

      _logService.info(
        'HeadsetService initialized — '
        'wired: ${_currentState.wiredConnected}, '
        'wireless: ${_currentState.wirelessConnected}',
        category: LogCategory.hardware,
      );
    } catch (e, st) {
      _logService.warning(
        'HeadsetService initialization failed: $e',
        category: LogCategory.hardware,
        exception: e,
        stackTrace: st,
      );
    }
  }

  void _onHeadsetEvent(hd.HeadsetChangedEvent event) {
    switch (event) {
      case hd.HeadsetChangedEvent.WIRED_CONNECTED:
        _updateState(_currentState.copyWith(wiredConnected: true));
      case hd.HeadsetChangedEvent.WIRED_DISCONNECTED:
        _updateState(_currentState.copyWith(wiredConnected: false));
      case hd.HeadsetChangedEvent.WIRELESS_CONNECTED:
        _updateState(_currentState.copyWith(wirelessConnected: true));
      case hd.HeadsetChangedEvent.WIRELESS_DISCONNECTED:
        _updateState(_currentState.copyWith(wirelessConnected: false));
    }
  }

  void _updateState(HeadsetState newState) {
    final previous = _currentState;
    _currentState = newState;
    _stateController.add(newState);

    if (previous != newState) {
      _logService.devLog(
        'Headset state changed: '
        'wired ${previous.wiredConnected} → ${newState.wiredConnected}, '
        'wireless ${previous.wirelessConnected} → ${newState.wirelessConnected} '
        '(connected: ${newState.isAnyConnected})',
        category: LogCategory.hardware,
      );
    }
  }

  /// Stops listening and closes the state stream.
  @disposeMethod
  void dispose() {
    _detector.removeListener();
    _stateController.close();
  }
}
