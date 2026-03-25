// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

/// Snackbar severity level that determines icon, color, and duration.
enum SnackBarType { success, error, info }

/// A modern floating snackbar with icon, themed colors, and optional action.
///
/// Usage:
/// ```dart
/// AppSnackBar.success(context, message: l10n.categorySaved);
/// AppSnackBar.error(context, message: l10n.somethingWentWrong);
/// AppSnackBar.info(context, message: l10n.sessionExpired);
/// ```
abstract final class AppSnackBar {
  static const _radius = 12.0;
  static const _margin = 16.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const _iconSpacing = 10.0;
  static const _elevation = 3.0;

  static const _successDuration = Duration(seconds: 2);
  static const _infoDuration = Duration(seconds: 3);
  static const _errorDuration = Duration(milliseconds: 3500);

  /// Show a success snackbar with a check icon.
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    message: message,
    type: SnackBarType.success,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Show an error snackbar with an error icon.
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    message: message,
    type: SnackBarType.error,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Show an info snackbar with an info icon.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    message: message,
    type: SnackBarType.info,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Clear all visible snackbars.
  static void clear(BuildContext context) =>
      ScaffoldMessenger.of(context).clearSnackBars();

  static void _show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (
      IconData icon,
      Color bg,
      Color fg,
      Duration duration,
    ) = switch (type) {
      SnackBarType.success => (
        Icons.check_circle_outline,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        _successDuration,
      ),
      SnackBarType.error => (
        Icons.error_outline,
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        _errorDuration,
      ),
      SnackBarType.info => (
        Icons.info_outline,
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        _infoDuration,
      ),
    };

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: fg, size: 22),
            SizedBox(width: _iconSpacing),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(color: fg),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: fg,
                onPressed: onAction ?? () {},
              )
            : null,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        elevation: _elevation,
        margin: const EdgeInsets.all(_margin),
        padding: _padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
