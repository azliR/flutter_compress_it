import 'package:auto_route/auto_route.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:compress_it/core/app_router.dart';
import 'package:compress_it/home-wrapper/view/home_wrapper_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

final homeNavigationNotifier = ValueNotifier(HomePageNavigation.image);
final themeNotifier = ValueNotifier(ThemeMode.system);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  void didChangeDependencies() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness,
        statusBarBrightness: Theme.of(context).brightness,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    super.didChangeDependencies();
  }

  static bool _backButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) =>
      true;

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      switch (status) {
        case EasyLoadingStatus.show:
          BackButtonInterceptor.add(_backButtonInterceptor);
        case EasyLoadingStatus.dismiss:
          BackButtonInterceptor.remove(_backButtonInterceptor);
      }
    });
    SharedPreferences.getInstance().then((prefs) {
      themeNotifier.value = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
      themeNotifier.addListener(() async {
        await prefs.setInt('themeMode', themeNotifier.value.index);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.chasingDots
      ..loadingStyle = EasyLoadingStyle.dark
      ..maskType = EasyLoadingMaskType.black
      ..indicatorSize = 45.0
      ..radius = 16
      ..userInteractions = false
      ..dismissOnTap = false;

    return ValueListenableBuilder(
      valueListenable: homeNavigationNotifier,
      builder: (context, homeNavigation, child) {
        return ValueListenableBuilder(
          valueListenable: themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              title: 'CompressIt',
              themeMode: themeMode,
              theme: ThemeData(
                colorScheme: switch (homeNavigation) {
                  HomePageNavigation.image =>
                    ColorScheme.fromSeed(seedColor: Colors.blue),
                  HomePageNavigation.audio =>
                    ColorScheme.fromSeed(seedColor: Colors.green),
                },
                useMaterial3: true,
                inputDecorationTheme: const InputDecorationTheme(filled: true),
              ),
              darkTheme: ThemeData(
                colorScheme: switch (homeNavigation) {
                  HomePageNavigation.image => ColorScheme.fromSeed(
                      seedColor: Colors.blue,
                      brightness: Brightness.dark,
                    ),
                  HomePageNavigation.audio => ColorScheme.fromSeed(
                      seedColor: Colors.green,
                      brightness: Brightness.dark,
                    ),
                },
                useMaterial3: true,
                inputDecorationTheme: const InputDecorationTheme(filled: true),
              ),
              routerConfig: _appRouter.config(
                navigatorObservers: () => [AutoRouteObserver()],
              ),
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
