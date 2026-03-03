// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:hexatuneapp/src/core/config/app_constants.dart';

/// Utility functions for image dimension calculations.
class ImageUtils {
  ImageUtils._();

  /// Calculate target dimensions for a 16:9 aspect ratio.
  ///
  /// The image is scaled to fit within the 16:9 frame, then the
  /// shorter dimension is padded (or the longer is cropped) to
  /// achieve the exact ratio. The output never exceeds
  /// [AppConstants.imageMaxWidth] × [AppConstants.imageMaxHeight].
  static ({int width, int height}) calculateTargetDimensions({
    required int sourceWidth,
    required int sourceHeight,
  }) {
    const targetRatio = AppConstants.imageAspectRatio; // 16/9

    int targetWidth;
    int targetHeight;

    final sourceRatio = sourceWidth / sourceHeight;

    if (sourceRatio > targetRatio) {
      // Source is wider — fit by height.
      targetHeight = sourceHeight;
      targetWidth = (targetHeight * targetRatio).round();
    } else {
      // Source is taller — fit by width.
      targetWidth = sourceWidth;
      targetHeight = (targetWidth / targetRatio).round();
    }

    // Clamp to max dimensions.
    if (targetWidth > AppConstants.imageMaxWidth) {
      targetWidth = AppConstants.imageMaxWidth;
      targetHeight = AppConstants.imageMaxHeight;
    }

    return (width: targetWidth, height: targetHeight);
  }
}
