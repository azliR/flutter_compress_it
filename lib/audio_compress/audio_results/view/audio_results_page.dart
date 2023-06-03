import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:compress_it/audio_compress/audio_compressor/repository/audio_compressor_repository.dart';
import 'package:compress_it/audio_compress/audio_compressor/widget/audio_tile_widget.dart';
import 'package:compress_it/audio_compress/audio_results/repository/audio_results_repository.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/percent_indicator.dart';

@RoutePage()
class AudioResultsPage extends StatefulWidget {
  const AudioResultsPage({
    required this.originalFiles,
    required this.compressedFiles,
    super.key,
  });

  final List<PlatformFile> originalFiles;
  final List<PlatformFile> compressedFiles;

  @override
  State<AudioResultsPage> createState() => _AudioResultsPageState();
}

class _AudioResultsPageState extends State<AudioResultsPage> {
  final _repository = AudioResultsRepository();
  final _audioCompressedRepository = AudioCompressorRepository();

  final _savedFolders = <String>[];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final originalSize = widget.originalFiles.fold(
      0,
      (previousValue, element) => previousValue += element.size,
    );
    final compressedSize = widget.compressedFiles.fold(
      0,
      (previousValue, element) => previousValue += element.size,
    );
    final max = math.max(originalSize, compressedSize);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: const Text('Hasil Kompresi'),
            ),
            if (max == compressedSize && max != originalSize)
              SliverToBoxAdapter(
                child: Card(
                  margin: EdgeInsets.zero,
                  color: colorScheme.errorContainer,
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text.rich(
                      TextSpan(
                        text: 'Perhatian! ',
                        children: [
                          TextSpan(
                            text:
                                'Hasil kompresi lebih besar daripada file aslinya! Anda dapat menurunkan kualitas di halaman sebelumnya dan lakukan kompresi ulang.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                          )
                        ],
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverToBoxAdapter(
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: LinearPercentIndicator(
                          percent: max == originalSize
                              ? 1
                              : originalSize / compressedSize,
                          lineHeight: 16,
                          animation: true,
                          animationDuration: 800,
                          curve: Curves.easeOut,
                          barRadius: const Radius.circular(8),
                          progressColor: colorScheme.error,
                          leading: SizedBox(
                            width: 80,
                            child: Text(
                              'Sebelum',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: Text(
                              formatSize(originalSize),
                              textAlign: TextAlign.end,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: LinearPercentIndicator(
                          percent: max == compressedSize
                              ? 1
                              : compressedSize / originalSize,
                          lineHeight: 16,
                          animation: true,
                          animationDuration: 800,
                          curve: Curves.easeOut,
                          barRadius: const Radius.circular(8),
                          progressColor: colorScheme.primary,
                          leading: SizedBox(
                            width: 80,
                            child: Text(
                              'Sesudah',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: Text(
                              formatSize(compressedSize),
                              textAlign: TextAlign.end,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverToBoxAdapter(
              child: FilledButton.icon(
                onPressed: _savedFolders.isEmpty
                    ? () async {
                        await EasyLoading.show(status: 'Menyimpan...');

                        final (savedFolders, failure) =
                            await _repository.saveAudio(
                          files: widget.compressedFiles,
                        );
                        if (failure != null) {
                          await EasyLoading.showError(failure.message);
                          return;
                        } else {
                          setState(() {
                            _savedFolders.addAll(savedFolders!);
                          });
                        }
                        await EasyLoading.dismiss();
                      }
                    : null,
                icon: _savedFolders.isNotEmpty
                    ? const Icon(Icons.check)
                    : const Icon(Icons.save_alt),
                label: _savedFolders.isNotEmpty
                    ? const Text('Berhasil disimpan!')
                    : const Text('Simpan ke penyimpanan'),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverToBoxAdapter(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: _savedFolders.isEmpty
                    ? const SizedBox()
                    : Card(
                        margin: EdgeInsets.zero,
                        color: colorScheme.secondaryContainer,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hasil kompresi berhasil disimpan di folder berikut:',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                              Text(
                                _savedFolders.join('\n'),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverList.builder(
              itemCount: widget.compressedFiles.length,
              itemBuilder: (context, index) {
                final file = widget.compressedFiles[index];
                return AudioTile(
                  file: file,
                  repository: _audioCompressedRepository,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
