// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/app_constants.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/media/image_utils.dart';

/// Pick images from camera or gallery, resize to 16:9, compress,
/// and return the processed bytes ready for upload.
@singleton
class ImageService {
  ImageService(this._logService);

  final LogService _logService;
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the camera, resize to 16:9, and compress.
  /// Returns null if the user cancels.
  Future<Uint8List?> pickFromCamera() async {
    final xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return null;
    }
    return _processFile(File(xFile.path));
  }

  /// Pick an image from the gallery, resize to 16:9, and compress.
  /// Returns null if the user cancels.
  Future<Uint8List?> pickFromGallery() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      return null;
    }
    return _processFile(File(xFile.path));
  }

  /// Process an existing file: resize to 16:9 and compress.
  Future<Uint8List?> processFile(File file) => _processFile(file);

  Future<Uint8List?> _processFile(File file) async {
    _logService.debug(
      'Processing image: ${file.path}',
      category: LogCategory.media,
    );

    final dimensions = await _getImageDimensions(file);
    if (dimensions == null) {
      _logService.warning(
        'Failed to decode image: ${file.path}',
        category: LogCategory.media,
      );
      return null;
    }

    final target = ImageUtils.calculateTargetDimensions(
      sourceWidth: dimensions.width,
      sourceHeight: dimensions.height,
    );

    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: target.width,
      minHeight: target.height,
      quality: AppConstants.imageQuality,
      format: CompressFormat.jpeg,
    );

    if (result != null) {
      _logService.info(
        'Image processed: ${target.width}x${target.height}, '
        '${(result.length / 1024).toStringAsFixed(1)} KB',
        category: LogCategory.media,
      );
    }

    return result;
  }

  Future<({int width, int height})?> _getImageDimensions(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final result = (width: descriptor.width, height: descriptor.height);
      descriptor.dispose();
      buffer.dispose();
      return result;
    } catch (e) {
      _logService.error(
        'Failed to decode image dimensions',
        category: LogCategory.media,
        exception: e,
      );
      return null;
    }
  }
}
