import 'dart:developer';
import 'dart:io';

import 'package:compress_it/core/failures.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart' as path;

class AudioCompressorRepository {
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

  Future<(List<PlatformFile>?, Failure?)> compressAudios({
    required List<PlatformFile> files,
    required int quality,
    required int? bitrate,
  }) async {
    try {
      final compressedFiles = <PlatformFile>[];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];

        final temporaryDir = await path.getTemporaryDirectory();
        final copiedAudioPath =
            '${temporaryDir.path}/copied_$i.${file.extension}';
        final compressedAudioPath =
            '${temporaryDir.path}/compressed_$i.${file.extension}';

        final copiedFile = await File(file.path!).copy(copiedAudioPath);
        final ffmpegQuality = 9 - quality + 1;

        final String command;
        if (bitrate != null && bitrate != 0) {
          command =
              '-i ${copiedFile.path} -b:a ${bitrate}k $compressedAudioPath -y';
        } else {
          command =
              '-i ${copiedFile.path} -q:a $ffmpegQuality $compressedAudioPath -y';
        }

        final session = await FFmpegKit.execute(command);
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
        } else if (ReturnCode.isCancel(returnCode)) {
          return (null, Failure('Operasi dibatalkan!'));
        } else {
          final logs = await session.getAllLogsAsString() ?? '';
          final stackTraceString = await session.getFailStackTrace() ?? '';

          log(logs, stackTrace: StackTrace.fromString(stackTraceString));
          return (null, Failure('Gagal mengompres gambar!'));
        }

        final compressedAudioFile = File(compressedAudioPath);

        compressedFiles.add(
          PlatformFile(
            name: file.name,
            size: await compressedAudioFile.length(),
            path: compressedAudioPath,
          ),
        );
      }
      return (compressedFiles, null);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return (null, Failure(e.toString(), error: e, stackTrace: stackTrace));
    }
  }

  Future<(MediaInformation?, Failure?)> getMediaInformation(String path) async {
    final mediaInfoSession = await FFprobeKit.getMediaInformation(path);
    final returnCode = await mediaInfoSession.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
    } else if (ReturnCode.isCancel(returnCode)) {
      return (null, Failure('Operasi dibatalkan!'));
    } else {
      final logs = await mediaInfoSession.getAllLogsAsString() ?? '';
      final stackTraceString = await mediaInfoSession.getFailStackTrace() ?? '';

      log(logs, stackTrace: StackTrace.fromString(stackTraceString));
      return (null, Failure('Gagal mengompres gambar!'));
    }
    final mediaInfo = mediaInfoSession.getMediaInformation()!;
    return (mediaInfo, null);
  }
}
