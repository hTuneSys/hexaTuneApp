// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/pages/shared/harmonize_source.dart';

/// Holds the current harmonize source selection across bottom sheet
/// open/close cycles and app lifecycle transitions.
///
/// Registered as a lazy singleton so the state persists
/// as long as the app is alive.
@lazySingleton
class HarmonizeSourceHolder {
  /// The currently selected harmonize source.
  HarmonizeSource? source;

  /// Clears the current source.
  void clear() => source = null;
}
