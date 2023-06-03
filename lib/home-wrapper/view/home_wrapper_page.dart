import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:compress_it/core/app_router.gr.dart';
import 'package:compress_it/core/failures.dart';
import 'package:compress_it/home-wrapper/repository/home_repository.dart';
import 'package:compress_it/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum HomePageNavigation { image, audio }

enum NavigationType { bottom, rail, drawer }

@RoutePage()
class HomeWrapperPage extends StatefulWidget {
  const HomeWrapperPage({super.key});

  @override
  State<HomeWrapperPage> createState() => _HomeWrapperPageState();
}

class _HomeWrapperPageState extends State<HomeWrapperPage> {
  final _selectImageRepository = HomeRepository();

  List<AdaptiveScaffoldDestination> _getDestinations(BuildContext context) {
    return HomePageNavigation.values.map((section) {
      return switch (section) {
        HomePageNavigation.image => const AdaptiveScaffoldDestination(
            icon: Icons.image_outlined,
            selectedIcon: Icons.image,
            label: 'Gambar',
          ),
        HomePageNavigation.audio => const AdaptiveScaffoldDestination(
            icon: Icons.audiotrack_outlined,
            selectedIcon: Icons.audiotrack,
            label: 'Audio',
          ),
      };
    }).toList();
  }

  void _onNavigationChanged(BuildContext context, int index) {
    homeNavigationNotifier.value = HomePageNavigation.values[index];

    final tabsRouter = AutoTabsRouter.of(context);
    if (index != tabsRouter.activeIndex) {
      tabsRouter.setActiveIndex(index);
    } else {
      tabsRouter.stackRouterOfIndex(index)?.popUntilRoot();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final destinations = _getDestinations(context);

    final NavigationType navigationType;
    if (data.size.width < 600) {
      if (data.orientation == Orientation.portrait) {
        navigationType = NavigationType.bottom;
      } else {
        navigationType = NavigationType.rail;
      }
    } else if (data.size.width < 1024) {
      navigationType = NavigationType.rail;
    } else {
      navigationType = NavigationType.drawer;
    }

    return AutoTabsRouter(
      curve: Curves.easeIn,
      routes: HomePageNavigation.values.map((section) {
        return switch (section) {
          HomePageNavigation.image => const SelectImageRoute(),
          HomePageNavigation.audio => const SelectAudioRoute(),
        };
      }).toList(),
      transitionBuilder: (context, child, animation) => FadeThroughTransition(
        animation: animation,
        secondaryAnimation: ReverseAnimation(animation),
        fillColor: Theme.of(context).canvasColor,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return WillPopScope(
          onWillPop: () async {
            if (tabsRouter.activeIndex != 0) {
              tabsRouter.setActiveIndex(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            bottomNavigationBar: navigationType == NavigationType.bottom
                ? NavigationBar(
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: (index) =>
                        _onNavigationChanged(context, index),
                    destinations: destinations
                        .map(
                          (destination) => NavigationDestination(
                            label: destination.label,
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(destination.selectedIcon),
                          ),
                        )
                        .toList(),
                  )
                : null,
            floatingActionButton: FloatingActionButton.large(
              shape: const CircleBorder(),
              onPressed: () async {
                await EasyLoading.show(status: 'Loading...');

                final section =
                    HomePageNavigation.values[tabsRouter.activeIndex];

                Failure? error;

                switch (section) {
                  case HomePageNavigation.image:
                    final (files, e) =
                        await _selectImageRepository.pickFiles(FileType.image);
                    if (mounted && files != null) {
                      unawaited(
                        context.router.push(ImageCompressorRoute(files: files)),
                      );
                    }
                    error = e;
                  case HomePageNavigation.audio:
                    final (files, e) =
                        await _selectImageRepository.pickFiles(FileType.audio);
                    if (mounted && files != null) {
                      unawaited(
                        context.router.push(AudioCompressorRoute(files: files)),
                      );
                    }
                    error = e;
                }

                if (mounted && error != null) {
                  await EasyLoading.showError(error.message);
                  return;
                }

                await EasyLoading.dismiss();
              },
              child: const Icon(Icons.file_upload_outlined),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Row(
              children: [
                if (navigationType != NavigationType.bottom) ...[
                  _HomeNavigationRail(
                    extended: navigationType == NavigationType.drawer,
                    destinations: destinations,
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: (index) =>
                        _onNavigationChanged(context, index),
                  ),
                  const VerticalDivider(width: 1, thickness: 0.2),
                ],
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AdaptiveScaffoldDestination {
  const AdaptiveScaffoldDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _HomeNavigationRail extends StatelessWidget {
  const _HomeNavigationRail({
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final bool extended;
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;
  final List<AdaptiveScaffoldDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      leading: SizedBox(
        height: MediaQuery.of(context).padding.top,
      ),
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              label: Text(destination.label),
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
            ),
          )
          .toList(),
    );
  }
}
