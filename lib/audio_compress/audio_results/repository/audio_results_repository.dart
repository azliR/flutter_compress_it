import 'dart:developer';

import 'package:compress_it/core/failures.dart';
import 'package:file_picker/file_picker.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:just_audio/just_audio.dart';

class AudioResultsRepository {
  final _audioPlayer = AudioPlayer();

  Stream<bool> get playingStream => _audioPlayer.playingStream;

  Future<(void, Failure?)> playAudio(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(path);
      await _audioPlayer.play();

      return (null, null);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }

  Future<(void, Failure?)> stopAudio() async {
    try {
      await _audioPlayer.stop();
      return (null, null);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }

  Future<(List<String>?, Failure?)> saveAudio({
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
