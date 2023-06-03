import 'dart:developer';

import 'package:compress_it/core/failures.dart';
import 'package:file_picker/file_picker.dart';
import 'package:folder_file_saver/folder_file_saver.dart';

class ImageResultsRepository {
  Future<(List<String>?, Failure?)> saveImages({
    required List<PlatformFile> files,
  }) async {
    try {
      final savedPaths = <String>[];
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final savedPath = await FolderFileSaver.saveFileToFolderExt(file.path!);
        if (savedPath == null) {
          return (null, Failure('Failed to save file'));
        }
        savedPaths.add((savedPath.split('/')..removeLast()).join('/'));
      }
      return (savedPaths.toSet().toList(), null);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }
}
