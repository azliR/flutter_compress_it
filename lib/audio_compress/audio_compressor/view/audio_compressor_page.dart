import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:compress_it/audio_compress/audio_compressor/repository/audio_compressor_repository.dart';
import 'package:compress_it/audio_compress/audio_compressor/widget/audio_tile_widget.dart';
import 'package:compress_it/audio_compress/audio_compressor/widget/bitrate_slider_widget.dart';
import 'package:compress_it/audio_compress/audio_compressor/widget/quality_slider_widget.dart';
import 'package:compress_it/core/app_router.gr.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_audio/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum CompressBy { quality, bitrate }

@RoutePage()
class AudioCompressorPage extends StatefulWidget {
  const AudioCompressorPage({required this.files, super.key});

  final List<PlatformFile> files;

  @override
  State<AudioCompressorPage> createState() => _AudioCompressorPageState();
}

class _AudioCompressorPageState extends State<AudioCompressorPage> {
  final _repository = AudioCompressorRepository();

  double _quality = 5;
  double _bitrate = 128;

  var _compressQueueIndex = 0;

  var _compressBy = CompressBy.quality;

  Future<void> _enableStatisticsCallback() async {
    final audioDurations = <double>[];

    for (var i = 0; i < widget.files.length; i++) {
      final (mediaInfo, failure) =
          await _repository.getMediaInformation(widget.files[i].path!);
      if (failure != null) {
        await EasyLoading.showError(
          'Gagal mengambil informasi dari file audio',
        );
        return;
      }
      audioDurations.add(double.parse(mediaInfo!.getDuration()!));
    }

    FFmpegKitConfig.enableStatisticsCallback((Statistics statistics) async {
      final timeInMilliseconds = statistics.getTime();
      if (timeInMilliseconds > 0) {
        final completePercentage =
            (timeInMilliseconds / 10) ~/ audioDurations[_compressQueueIndex];
        await EasyLoading.showProgress(
          completePercentage / 100,
          status:
              'Dikompresi $_compressQueueIndex/${audioDurations.length}: $completePercentage%',
        );
        if (completePercentage == 100) {
          if (_compressQueueIndex == audioDurations.length - 1) {
            _compressQueueIndex = 0;
          } else {
            _compressQueueIndex++;
          }
        }
      }
    });
  }

  @override
  void initState() {
    _enableStatisticsCallback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final totalSize = widget.files
        .fold(0, (previousValue, element) => previousValue += element.size);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Konfigurasi kompresi'),
          ),
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail audio', style: textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.files.length} audio, total ukuran ${formatSize(totalSize)}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode kompresi',
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      'Pilih metode kompresi antara kualitas atau bitrate',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(4)),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Kualitas'),
                  selected: _compressBy == CompressBy.quality,
                  onSelected: (value) {
                    if (value) {
                      setState(() => _compressBy = CompressBy.quality);
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Bitrate'),
                  selected: _compressBy == CompressBy.bitrate,
                  onSelected: (value) {
                    if (value) {
                      setState(() => _compressBy = CompressBy.bitrate);
                    }
                  },
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.center,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                transitionBuilder: (child, animation) => FadeScaleTransition(
                  animation: animation,
                  child: child,
                ),
                child: _compressBy == CompressBy.quality
                    ? Card(
                        key: const ValueKey(CompressBy.quality),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Kualitas',
                                  style: textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Semakin tinggi nilainya semakin bagus kualitasnya',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ),
                              QualitySlider(
                                initialValue: _quality,
                                onChanged: (value) {
                                  _quality = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        key: const ValueKey(CompressBy.bitrate),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Bitrate (kbps)',
                                  style: textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Bitrate mungkin memiliki limit sesuai dengan format kompresi.',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ),
                              BitrateSlider(
                                initialValue: _bitrate,
                                onChanged: (value) {
                                  if ((value == 0 && _bitrate != 0) ||
                                      (value != 0 && _bitrate == 0)) {
                                    setState(() {});
                                  }
                                  _bitrate = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(8)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FilledButton(
                onPressed: () async {
                  await EasyLoading.show(
                    status: 'Sedang mengompresi, harap tunggu...',
                  );
                  final (compressedFiles, failure) =
                      await _repository.compressAudios(
                    files: widget.files,
                    quality: _quality.round(),
                    bitrate: _bitrate.round(),
                  );
                  await EasyLoading.dismiss();
                  if (failure != null) {
                    await EasyLoading.showError(failure.message);
                    return;
                  }
                  if (mounted) {
                    await context.router.push(
                      AudioResultsRoute(
                        originalFiles: widget.files,
                        compressedFiles: compressedFiles!,
                      ),
                    );
                  }
                },
                child: const Text('Mulai kompres'),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(8)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList.builder(
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = widget.files[index];
                return AudioTile(file: file, repository: _repository);
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 64)),
        ],
      ),
    );
  }
}
