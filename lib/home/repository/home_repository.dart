import 'dart:developer';

import 'package:compress_it/core/failures.dart';
import 'package:file_picker/file_picker.dart';

class HomeRepository {
  final _filePicker = FilePicker.platform;

  Future<(List<PlatformFile>?, Failure?)> pickFiles(FileType type) async {
    try {
      final result = await _filePicker.pickFiles(
        allowMultiple: true,
        type: type,
        // withData: true,
      );
      return (result?.files, null);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }
}
