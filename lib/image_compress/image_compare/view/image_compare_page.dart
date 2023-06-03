import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/utils/string_formatters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

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
          SliverAppBar.large(
            title: const Text('Bandingkan gambar'),
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
                  final image = ImageSizeGetter.getSize(FileInput(file));

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
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondary.withOpacity(0.6),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onSecondary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Text(
                                    'Asli: ${image.width} × ${image.height}'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.tertiary.withOpacity(0.6),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onTertiary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Text(
                                    'Asli: ${formatSize(originalImage.size)}'),
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
                  final image = ImageSizeGetter.getSize(FileInput(file));

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
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondary.withOpacity(0.6),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onSecondary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Text(
                                  'Dikompresi: ${image.width} × ${image.height}',
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.tertiary.withOpacity(0.6),
                              textStyle: textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onTertiary),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                child: Text(
                                  'Dikompresi: ${formatSize(compressedImage.size)}',
                                  textAlign: TextAlign.end,
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
