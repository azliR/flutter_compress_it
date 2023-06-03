import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeWrapperRoute.page,
          children: [
            AutoRoute(page: SelectImageRoute.page),
            AutoRoute(page: SelectAudioRoute.page),
          ],
        ),
        AutoRoute(
          path: '/image-compressor',
          page: ImageCompressorRoute.page,
        ),
        AutoRoute(
          path: '/image-results',
          page: ImageResultsRoute.page,
        ),
        AutoRoute(
          path: '/image-compare',
          page: ImageCompareRoute.page,
        ),
        AutoRoute(
          path: '/audio-compressor',
          page: AudioCompressorRoute.page,
        ),
        AutoRoute(
          path: '/audio-result',
          page: AudioResultsRoute.page,
        ),
      ];
}
