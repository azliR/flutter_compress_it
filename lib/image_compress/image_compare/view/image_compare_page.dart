import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter_heic/image_size_getter_heic.dart';

@RoutePage()
class ImageComparePage extends StatelessWidget {
  const ImageComparePage({
    required this.compressedImage,
    required this.originalImage,
    required this.heroTag,
    super.key,
  });

  final PlatformFile originalImage;
  final PlatformFile compressedImage;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Bandingkan gambar'),
          ),
          SliverToBoxAdapter(
            child: Hero(
              tag: heroTag,
              child: ImageCompareSlider(
                itemOne: Image.file(
                  File(originalImage.path!),
                  fit: BoxFit.fitWidth,
                ),
                itemTwo: Image.file(
                  File(compressedImage.path!),
                  fit: BoxFit.fitWidth,
                ),
                itemOneBuilder: (child, context) {
                  final file = File(originalImage.path!);
                  final imageSize = ImageSizeGetter.getSize(FileInput(file));

                  return SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: child,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondary.withOpacity(0.8),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onSecondary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Asli:',
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      '${imageSize.width} × ${imageSize.height}',
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      formatSize(originalImage.size),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      originalImage.extension?.toUpperCase() ??
                                          '',
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemTwoBuilder: (child, context) {
                  final file = File(compressedImage.path!);
                  final imageSize = ImageSizeGetter.getSize(FileInput(file));

                  return SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: child,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondary.withOpacity(0.8),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onSecondary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Dikompresi:',
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      '${imageSize.width} × ${imageSize.height}',
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      formatSize(compressedImage.size),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      compressedImage.extension
                                              ?.toUpperCase() ??
                                          '',
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(16))
        ],
      ),
    );
  }
}
