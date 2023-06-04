import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/app_router.gr.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:compress_it/image_compress/image_results/repository/image_results_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:percent_indicator/percent_indicator.dart';

@RoutePage()
class ImageResultsPage extends StatefulWidget {
  const ImageResultsPage({
    required this.originalFiles,
    required this.compressedFiles,
    super.key,
  });

  final List<PlatformFile> originalFiles;
  final List<PlatformFile> compressedFiles;

  @override
  State<ImageResultsPage> createState() => _ImageResultsPageState();
}

class _ImageResultsPageState extends State<ImageResultsPage> {
  final _repository = ImageResultsRepository();

  final _savedFolders = <String>[];

  @override
  void initState() {
    imageCache
      ..clear()
      ..clearLiveImages();
    super.initState();
  }

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
                      ),
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
                            await _repository.saveImages(
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
                    : const Text('Simpan ke galeri'),
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
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.compressedFiles.length,
              itemBuilder: (context, index) {
                final originalImage = widget.originalFiles[index];
                final compressedImage = widget.compressedFiles[index];

                final file = File(compressedImage.path!);
                final heroTag = '${originalImage.name}-$index';

                final imageSize = ImageSizeGetter.getSize(FileInput(file));

                return InkWell(
                  onTap: () => context.router.push(
                    ImageCompareRoute(
                      compressedImage: compressedImage,
                      originalImage: originalImage,
                      heroTag: heroTag,
                    ),
                  ),
                  child: Hero(
                    tag: heroTag,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(
                            File(widget.compressedFiles[index].path!),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.secondary,
                                textStyle: textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.onSecondary),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    '${imageSize.width} × ${imageSize.height}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.secondary,
                                textStyle: textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.onSecondary),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    formatSize(
                                      widget.compressedFiles[index].size,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Material(
                              shape: const CircleBorder(),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.compare,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
