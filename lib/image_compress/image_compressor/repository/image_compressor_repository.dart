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

  Future<(List<PlatformFile>?, Failure?)> compressImages({
    required List<PlatformFile> files,
    required int quality,
    required int? minWidth,
    required int? minHeight,
  }) async {
    try {
      final compressedFiles = <PlatformFile>[];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final imageSize = ImageSizeGetter.getSize(FileInput(File(file.path!)));
        // final image = await decodeImageFile(file.path!);
        // final resizedImage =
        //     copyResize(image!, width: minWidth, height: minHeight);
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
        );

        if (compressedImage == null) {
          return (null, Failure('Gagal mengompres gambar'));
        }

        final compressedImagePath =
            '${temporaryDir.path}/compressed_${file.name}';

        await File(compressedImagePath).writeAsBytes(compressedImage);

        compressedFiles.add(
          PlatformFile(
            name: file.name,
            size: compressedImage.length,
            path: compressedImagePath,
          ),
        );
      }
      return (compressedFiles, null);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }
}
