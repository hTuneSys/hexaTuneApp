// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Floating bottom navigation bar for the main app shell.
///
/// Displays a rounded floating card with four icon buttons (two on each side)
/// and a hexagonal center button that protrudes above the bar.
///
/// The bar is designed to float above page content with padding from the edges.
/// Use [extendBody: true] on the parent [Scaffold] so content scrolls behind it.
///
/// Usage:
/// ```dart
/// Scaffold(
///   extendBody: true,
///   bottomNavigationBar: const AppBottomBar(),
/// )
/// ```
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key, this.onItemTapped, this.onCenterTapped});

  /// Called when one of the four navigation icons is tapped.
  /// The [index] ranges from 0 (leftmost) to 3 (rightmost).
  final ValueChanged<int>? onItemTapped;

  /// Called when the center hexagonal button is tapped.
  final VoidCallback? onCenterTapped;

  static const double _hexSize = 64;
  static const double _barHeight = 64;
  static const double _hexProtrusion = _hexSize / 2;
  static const double _barRadius = 12;
  static const double _barMargin = 16;

  /// Total height of the bottom bar including hexagon protrusion and margin.
  /// Use this as bottom padding on scrollable content so the last item
  /// can be scrolled above the floating bar.
  static const double scrollPadding = _barHeight + _hexProtrusion + _barMargin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _barMargin,
        0,
        _barMargin,
        _barMargin + bottomPadding,
      ),
      child: SizedBox(
        height: _barHeight + _hexProtrusion,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(_barRadius),
                color: colorScheme.surface,
                surfaceTintColor: colorScheme.surfaceTint,
                child: SizedBox(
                  height: _barHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home_outlined),
                        onPressed: () => onItemTapped?.call(0),
                        color: colorScheme.onSurface,
                      ),
                      IconButton(
                        icon: const Icon(Icons.newspaper_outlined),
                        onPressed: () => onItemTapped?.call(1),
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(width: _hexSize),
                      IconButton(
                        icon: const Icon(Icons.workspaces_outlined),
                        onPressed: () => onItemTapped?.call(2),
                        color: colorScheme.onSurface,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () => onItemTapped?.call(3),
                        color: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: _HexagonButton(
                  size: _hexSize,
                  fillColor: colorScheme.surface,
                  strokeColor: colorScheme.primary,
                  onPressed: onCenterTapped ?? () {},
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A hexagonal-shaped button drawn with [CustomPaint].
class _HexagonButton extends StatelessWidget {
  const _HexagonButton({
    required this.size,
    required this.fillColor,
    required this.strokeColor,
    required this.onPressed,
    required this.child,
  });

  final double size;
  final Color fillColor;
  final Color strokeColor;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: _HexagonPainter(
          fillColor: fillColor,
          strokeColor: strokeColor,
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Paints a pointy-top hexagon with fill and stroke.
class _HexagonPainter extends CustomPainter {
  _HexagonPainter({required this.fillColor, required this.strokeColor});

  final Color fillColor;
  final Color strokeColor;
  static const double strokeWidth = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _hexPath(size);

    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Path _hexPath(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - strokeWidth / 2;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (60.0 * i) * math.pi / 180.0;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter oldDelegate) =>
      fillColor != oldDelegate.fillColor ||
      strokeColor != oldDelegate.strokeColor;
}
