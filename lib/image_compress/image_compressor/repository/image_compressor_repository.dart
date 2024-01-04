import 'dart:developer';
import 'dart:io';

import 'package:compress_it/core/failures.dart';
import 'package:fc_native_image_resize/fc_native_image_resize.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart' as path;

class ImageCompressorRepository {
  final _imageResizer = FcNativeImageResize();

  Future<(List<PlatformFile>?, Duration, Failure?)> compressImages({
    required List<PlatformFile> files,
    required int quality,
    required int? minWidth,
    required int? minHeight,
    required CompressFormat compressFormat,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final compressedFiles = <PlatformFile>[];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final imageSize = ImageSizeGetter.getSize(FileInput(File(file.path!)));
        final temporaryDir = await path.getTemporaryDirectory();
        final resizedImagePath = '${temporaryDir.path}/resized_${file.name}';

        await _imageResizer.resizeFile(
          srcFile: file.path!,
          destFile: resizedImagePath,
          width: minWidth ?? imageSize.width,
          height: minHeight ?? imageSize.height,
          format: resizedImagePath.split('.').last,
          keepAspectRatio: true,
        );

        final compressedImage = await FlutterImageCompress.compressWithFile(
          resizedImagePath,
          quality: quality,
          format: compressFormat,
        );

        if (compressedImage == null) {
          stopwatch.stop();
          return (null, stopwatch.elapsed, Failure('Gagal mengompres gambar'));
        }

        final compressedImageName =
            (file.name.split('.')..removeLast()).join('.');
        final compressedImageExt = compressFormat.name;
        final compressedImagePath =
            '${temporaryDir.path}/compressed_$compressedImageName.$compressedImageExt';

        await File(compressedImagePath).writeAsBytes(compressedImage);

        compressedFiles.add(
          PlatformFile(
            name: '$compressedImageName.$compressedImageExt',
            size: compressedImage.length,
            path: compressedImagePath,
          ),
        );
      }
      stopwatch.stop();
      return (compressedFiles, stopwatch.elapsed, null);
    } catch (e, stackTrace) {
      stopwatch.stop();
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (
        null,
        stopwatch.elapsed,
        Failure(e.toString(), error: e, stackTrace: stackTrace)
      );
    }
  }
}
