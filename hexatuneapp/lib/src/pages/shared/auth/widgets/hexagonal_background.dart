// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter/material.dart';

/// Decorative hexagonal glass pattern background used on auth screens.
/// Colors are derived from the app theme.
class HexagonalBackground extends StatelessWidget {
  const HexagonalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned.fill(
      child: CustomPaint(
        painter: _HexagonalPainter(
          baseColor: colorScheme.outlineVariant,
          accentColor: colorScheme.primary,
        ),
      ),
    );
  }
}

class _HexagonalPainter extends CustomPainter {
  _HexagonalPainter({required this.baseColor, required this.accentColor});

  final Color baseColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final hexagons = <_Hexagon>[
      _Hexagon(0.15, -0.02, 80, 0.07),
      _Hexagon(0.55, 0.02, 100, 0.05),
      _Hexagon(0.85, 0.08, 60, 0.08),
      _Hexagon(0.35, 0.10, 120, 0.04),
      _Hexagon(0.70, 0.15, 70, 0.06),
      _Hexagon(0.05, 0.18, 50, 0.09),
      _Hexagon(0.90, 0.22, 90, 0.05),
      _Hexagon(0.45, 0.25, 110, 0.03),
      _Hexagon(0.20, 0.28, 65, 0.07),
      _Hexagon(0.75, 0.32, 85, 0.04),
      _Hexagon(0.10, 0.35, 55, 0.06),
      _Hexagon(0.60, 0.38, 75, 0.05),
      _Hexagon(0.30, 0.05, 95, 0.06),
      _Hexagon(0.50, 0.15, 45, 0.08),
    ];

    for (final hex in hexagons) {
      final cx = hex.relX * size.width;
      final cy = hex.relY * size.height;
      final r = hex.radius * (size.width / 400);
      final useAccent = random.nextDouble() > 0.7;
      final color = useAccent ? accentColor : baseColor;
      final paint = Paint()
        ..color = color.withValues(alpha: hex.opacity)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = color.withValues(alpha: hex.opacity * 1.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final path = _hexagonPath(cx, cy, r);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, strokePaint);
    }
  }

  Path _hexagonPath(double cx, double cy, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (pi / 3) * i - pi / 6;
      final x = cx + radius * cos(angle);
      final y = cy + radius * sin(angle);
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
  bool shouldRepaint(covariant _HexagonalPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor ||
      accentColor != oldDelegate.accentColor;
}

class _Hexagon {
  const _Hexagon(this.relX, this.relY, this.radius, this.opacity);
  final double relX;
  final double relY;
  final double radius;
  final double opacity;
}
