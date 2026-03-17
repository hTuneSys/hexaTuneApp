// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Current status of an in-app purchase operation.
enum IapStatus {
  /// No purchase in progress.
  idle,

  /// Loading products from store.
  loading,

  /// Purchase initiated, waiting for store confirmation.
  pending,

  /// Purchase completed, verifying with backend.
  verifying,

  /// Purchase verified and coins credited.
  success,

  /// Purchase failed with an error.
  error,

  /// Purchase was canceled by the user.
  canceled,

  /// In-app purchases are not available on this device.
  unavailable,
}
