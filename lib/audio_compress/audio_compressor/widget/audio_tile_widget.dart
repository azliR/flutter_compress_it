import 'package:auto_route/auto_route.dart';
import 'package:compress_it/audio_compress/audio_compressor/repository/audio_compressor_repository.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:ffmpeg_kit_flutter_audio/media_information.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AudioTile extends StatefulWidget {
  const AudioTile({required this.file, required this.repository, super.key});

  final PlatformFile file;
  final AudioCompressorRepository repository;

  @override
  State<AudioTile> createState() => _AudioTileState();
}

class _AudioTileState extends State<AudioTile> with AutoRouteAware {
  AutoRouteObserver? _observer;

  String? _currentPlayingPath;

  Future<void> _playAudio() async {
    _currentPlayingPath = widget.file.path;
    final (_, failure) = await widget.repository.playAudio(widget.file.path!);

    if (failure != null) {
      await EasyLoading.showError(failure.message);
    } else {
      _currentPlayingPath = null;
    }
  }

  Future<void> _stopAudio() async {
    _currentPlayingPath = null;
    final (_, failure) = await widget.repository.stopAudio();
    if (failure != null) {
      await EasyLoading.showError(failure.message);
    } else {
      _currentPlayingPath = widget.file.path;
    }
  }

  Future<MediaInformation?> _getMediaInformation() async {
    final (mediaInfo, _) =
        await widget.repository.getMediaInformation(widget.file.path!);
    return mediaInfo;
  }

  @override
  void didPushNext() {
    widget.repository.stopAudio().then((value) => _currentPlayingPath = null);
  }

  @override
  void didPop() {
    widget.repository.stopAudio().then((value) => _currentPlayingPath = null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer =
        RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
    if (_observer != null) {
      _observer?.subscribe(this, context.routeData);
    }
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          tileColor: colorScheme.surfaceVariant,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          title: Text(
            widget.file.name,
            style: textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: FutureBuilder<MediaInformation?>(
            future: _getMediaInformation(),
            builder: (context, snapshot) {
              final fileSize = widget.file.size;
              final extensionName =
                  widget.file.name.split('.').last.toUpperCase();
              final mediaInfo = snapshot.data;
              return Text(
                snapshot.data == null
                    ? '${formatSize(fileSize)} | $extensionName'
                    : '${formatSize(widget.file.size)} | ${int.parse(mediaInfo!.getBitrate()!) ~/ 1000} kbps | $extensionName',
                style: textTheme.bodySmall,
              );
            },
          ),
          leading: const Icon(Icons.audiotrack),
          contentPadding: const EdgeInsets.only(left: 16, right: 12),
          trailing: StreamBuilder<bool>(
            initialData: false,
            stream: widget.repository.playingStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data!;

              return IconButton.outlined(
                onPressed: isPlaying && _currentPlayingPath == widget.file.path
                    ? _stopAudio
                    : _playAudio,
                icon: isPlaying && _currentPlayingPath == widget.file.path
                    ? const Icon(Icons.stop_rounded)
                    : const Icon(Icons.play_arrow_rounded),
              );
            },
          ),
        ),
      ),
    );
  }
}
