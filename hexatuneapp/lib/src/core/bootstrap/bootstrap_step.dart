// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Status of an individual bootstrap initialization step.
enum BootstrapStepStatus { pending, running, done, error }

/// Callback signature for reporting bootstrap progress.
typedef BootstrapProgressCallback =
    void Function(int stepIndex, BootstrapStepStatus status, [String? error]);

/// Represents a single step in the application bootstrap sequence.
class BootstrapStep {
  const BootstrapStep({
    required this.label,
    this.status = BootstrapStepStatus.pending,
    this.error,
  });

  final String label;
  final BootstrapStepStatus status;
  final String? error;

  BootstrapStep copyWith({BootstrapStepStatus? status, String? error}) {
    return BootstrapStep(
      label: label,
      status: status ?? this.status,
      error: error,
    );
  }
}
