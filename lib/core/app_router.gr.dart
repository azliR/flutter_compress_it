// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:compress_it/audio_compress/audio_compressor/view/audio_compressor_page.dart'
    as _i7;
import 'package:compress_it/audio_compress/audio_results/view/audio_results_page.dart'
    as _i8;
import 'package:compress_it/audio_compress/select_audio/view/select_audio_page.dart'
    as _i6;
import 'package:compress_it/home-wrapper/view/home_wrapper_page.dart' as _i1;
import 'package:compress_it/image_compress/image_compare/view/image_compare_page.dart'
    as _i5;
import 'package:compress_it/image_compress/image_compressor/view/image_compressor_page.dart'
    as _i2;
import 'package:compress_it/image_compress/image_results/view/image_results_page.dart'
    as _i4;
import 'package:compress_it/image_compress/select_image/view/select_image_page.dart'
    as _i3;
import 'package:file_picker/file_picker.dart' as _i10;
import 'package:flutter/material.dart' as _i11;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    HomeWrapperRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeWrapperPage(),
      );
    },
    ImageCompressorRoute.name: (routeData) {
      final args = routeData.argsAs<ImageCompressorRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ImageCompressorPage(
          files: args.files,
          key: args.key,
        ),
      );
    },
    SelectImageRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SelectImagePage(),
      );
    },
    ImageResultsRoute.name: (routeData) {
      final args = routeData.argsAs<ImageResultsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ImageResultsPage(
          originalFiles: args.originalFiles,
          compressedFiles: args.compressedFiles,
          key: args.key,
        ),
      );
    },
    ImageCompareRoute.name: (routeData) {
      final args = routeData.argsAs<ImageCompareRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ImageComparePage(
          compressedImage: args.compressedImage,
          originalImage: args.originalImage,
          heroTag: args.heroTag,
          key: args.key,
        ),
      );
    },
    SelectAudioRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SelectAudioPage(),
      );
    },
    AudioCompressorRoute.name: (routeData) {
      final args = routeData.argsAs<AudioCompressorRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.AudioCompressorPage(
          files: args.files,
          key: args.key,
        ),
      );
    },
    AudioResultsRoute.name: (routeData) {
      final args = routeData.argsAs<AudioResultsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.AudioResultsPage(
          originalFiles: args.originalFiles,
          compressedFiles: args.compressedFiles,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeWrapperPage]
class HomeWrapperRoute extends _i9.PageRouteInfo<void> {
  const HomeWrapperRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapperRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ImageCompressorPage]
class ImageCompressorRoute extends _i9.PageRouteInfo<ImageCompressorRouteArgs> {
  ImageCompressorRoute({
    required List<_i10.PlatformFile> files,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ImageCompressorRoute.name,
          args: ImageCompressorRouteArgs(
            files: files,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageCompressorRoute';

  static const _i9.PageInfo<ImageCompressorRouteArgs> page =
      _i9.PageInfo<ImageCompressorRouteArgs>(name);
}

class ImageCompressorRouteArgs {
  const ImageCompressorRouteArgs({
    required this.files,
    this.key,
  });

  final List<_i10.PlatformFile> files;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ImageCompressorRouteArgs{files: $files, key: $key}';
  }
}

/// generated route for
/// [_i3.SelectImagePage]
class SelectImageRoute extends _i9.PageRouteInfo<void> {
  const SelectImageRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SelectImageRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectImageRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ImageResultsPage]
class ImageResultsRoute extends _i9.PageRouteInfo<ImageResultsRouteArgs> {
  ImageResultsRoute({
    required List<_i10.PlatformFile> originalFiles,
    required List<_i10.PlatformFile> compressedFiles,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ImageResultsRoute.name,
          args: ImageResultsRouteArgs(
            originalFiles: originalFiles,
            compressedFiles: compressedFiles,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageResultsRoute';

  static const _i9.PageInfo<ImageResultsRouteArgs> page =
      _i9.PageInfo<ImageResultsRouteArgs>(name);
}

class ImageResultsRouteArgs {
  const ImageResultsRouteArgs({
    required this.originalFiles,
    required this.compressedFiles,
    this.key,
  });

  final List<_i10.PlatformFile> originalFiles;

  final List<_i10.PlatformFile> compressedFiles;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ImageResultsRouteArgs{originalFiles: $originalFiles, compressedFiles: $compressedFiles, key: $key}';
  }
}

/// generated route for
/// [_i5.ImageComparePage]
class ImageCompareRoute extends _i9.PageRouteInfo<ImageCompareRouteArgs> {
  ImageCompareRoute({
    required _i10.PlatformFile compressedImage,
    required _i10.PlatformFile originalImage,
    required String heroTag,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ImageCompareRoute.name,
          args: ImageCompareRouteArgs(
            compressedImage: compressedImage,
            originalImage: originalImage,
            heroTag: heroTag,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageCompareRoute';

  static const _i9.PageInfo<ImageCompareRouteArgs> page =
      _i9.PageInfo<ImageCompareRouteArgs>(name);
}

class ImageCompareRouteArgs {
  const ImageCompareRouteArgs({
    required this.compressedImage,
    required this.originalImage,
    required this.heroTag,
    this.key,
  });

  final _i10.PlatformFile compressedImage;

  final _i10.PlatformFile originalImage;

  final String heroTag;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ImageCompareRouteArgs{compressedImage: $compressedImage, originalImage: $originalImage, heroTag: $heroTag, key: $key}';
  }
}

/// generated route for
/// [_i6.SelectAudioPage]
class SelectAudioRoute extends _i9.PageRouteInfo<void> {
  const SelectAudioRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SelectAudioRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectAudioRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.AudioCompressorPage]
class AudioCompressorRoute extends _i9.PageRouteInfo<AudioCompressorRouteArgs> {
  AudioCompressorRoute({
    required List<_i10.PlatformFile> files,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          AudioCompressorRoute.name,
          args: AudioCompressorRouteArgs(
            files: files,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AudioCompressorRoute';

  static const _i9.PageInfo<AudioCompressorRouteArgs> page =
      _i9.PageInfo<AudioCompressorRouteArgs>(name);
}

class AudioCompressorRouteArgs {
  const AudioCompressorRouteArgs({
    required this.files,
    this.key,
  });

  final List<_i10.PlatformFile> files;

  final _i11.Key? key;

  @override
  String toString() {
    return 'AudioCompressorRouteArgs{files: $files, key: $key}';
  }
}

/// generated route for
/// [_i8.AudioResultsPage]
class AudioResultsRoute extends _i9.PageRouteInfo<AudioResultsRouteArgs> {
  AudioResultsRoute({
    required List<_i10.PlatformFile> originalFiles,
    required List<_i10.PlatformFile> compressedFiles,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          AudioResultsRoute.name,
          args: AudioResultsRouteArgs(
            originalFiles: originalFiles,
            compressedFiles: compressedFiles,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AudioResultsRoute';

  static const _i9.PageInfo<AudioResultsRouteArgs> page =
      _i9.PageInfo<AudioResultsRouteArgs>(name);
}

class AudioResultsRouteArgs {
  const AudioResultsRouteArgs({
    required this.originalFiles,
    required this.compressedFiles,
    this.key,
  });

  final List<_i10.PlatformFile> originalFiles;

  final List<_i10.PlatformFile> compressedFiles;

  final _i11.Key? key;

  @override
  String toString() {
    return 'AudioResultsRouteArgs{originalFiles: $originalFiles, compressedFiles: $compressedFiles, key: $key}';
  }
}
