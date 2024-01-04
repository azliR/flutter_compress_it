import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/app_router.gr.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:compress_it/image_compress/image_compressor/repository/image_compressor_repository.dart';
import 'package:compress_it/image_compress/image_compressor/widget/quality_slider_widget.dart';
import 'package:compress_it/image_compress/image_compressor/widget/resize_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

@RoutePage()
class ImageCompressorPage extends StatefulWidget {
  const ImageCompressorPage({required this.files, super.key});

  final List<PlatformFile> files;

  @override
  State<ImageCompressorPage> createState() => _ImageCompressorPageState();
}

class _ImageCompressorPageState extends State<ImageCompressorPage> {
  final _repository = ImageCompressorRepository();

  double _quality = 80;
  int? _minWidth;
  int? _minHeight;
  var _compressFormat = CompressFormat.jpeg;

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
                    Text('Detail gambar', style: textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.files.length} foto, total ukuran ${formatSize(totalSize)}',
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Kualitas', style: textTheme.titleSmall),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Text('Resize', style: textTheme.titleSmall),
                    const SizedBox(height: 4),
                    ResizeField(
                      onChanged: (width, height) {
                        _minWidth = width;
                        _minHeight = height;
                      },
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
                    Text('Konversi', style: textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih format output gambar. Beberapa format mungkin tidak didukung oleh perangkat Anda.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      children: CompressFormat.values.map((compressFormat) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(compressFormat.name),
                            selected: _compressFormat == compressFormat,
                            onSelected: (value) {
                              setState(() => _compressFormat = compressFormat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
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
                  final (compressedFiles, elapsed, failure) =
                      await _repository.compressImages(
                    files: widget.files,
                    quality: _quality.round(),
                    minWidth: _minWidth,
                    minHeight: _minHeight,
                    compressFormat: _compressFormat,
                  );
                  await EasyLoading.dismiss();
                  if (failure != null) {
                    await EasyLoading.showError(failure.message);
                    return;
                  }
                  if (mounted) {
                    await context.router.push(
                      ImageResultsRoute(
                        originalFiles: widget.files,
                        compressedFiles: compressedFiles!,
                        duration: elapsed,
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
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = File(widget.files[index].path!);
                final image = ImageSizeGetter.getSize(FileInput(file));

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(widget.files[index].path!)),
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
                              child: Text('${image.width} × ${image.height}'),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.tertiary,
                                textStyle: textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.onTertiary),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    widget.files[index].extension
                                            ?.toUpperCase() ??
                                        '',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.tertiary,
                                textStyle: textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.onTertiary),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    formatSize(widget.files[index].size),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 64)),
        ],
      ),
    );
  }
}
