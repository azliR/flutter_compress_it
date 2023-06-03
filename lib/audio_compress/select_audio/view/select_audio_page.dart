import 'package:auto_route/auto_route.dart';
import 'package:compress_it/main.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SelectAudioPage extends StatelessWidget {
  const SelectAudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final platformBrightness = Theme.of(context).brightness;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Kompresi Audio'),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'dark_mode',
                  child: Row(
                    children: [
                      const Text('Mode Gelap'),
                      const Spacer(),
                      ValueListenableBuilder(
                        valueListenable: themeNotifier,
                        builder: (context, themeMode, child) {
                          return Checkbox.adaptive(
                            value: themeMode == ThemeMode.dark ||
                                (themeMode == ThemeMode.system &&
                                    platformBrightness == Brightness.dark),
                            onChanged: (value) {
                              themeNotifier.value =
                                  value! ? ThemeMode.dark : ThemeMode.light;
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'source_code',
                  child: Text('Buka Kode Sumber'),
                ),
                const PopupMenuItem(
                  value: 'about',
                  child: Text('Tentang'),
                ),
              ],
              onSelected: (value) async {
                if (value == 'dark_mode') {
                  themeNotifier.value = themeNotifier.value == ThemeMode.dark ||
                          (themeNotifier.value == ThemeMode.system &&
                              platformBrightness == Brightness.dark)
                      ? ThemeMode.light
                      : ThemeMode.dark;
                } else if (value == 'source_code') {
                  await launchUrl(
                    Uri.parse('https://github.com/azliR/flutter_compress_it'),
                    mode: LaunchMode.externalApplication,
                  );
                } else if (value == 'about') {
                  await PackageInfo.fromPlatform().then((packageInfo) {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/images/ic_launcher.png',
                        width: 56,
                      ),
                      applicationName: 'CompressIt',
                      applicationLegalese: '©2023 azliR',
                      applicationVersion: packageInfo.version,
                    );
                  });
                }
              },
            ),
          ],
        ),
        const SliverPadding(padding: EdgeInsets.all(16)),
        SliverToBoxAdapter(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Image.asset(
                  'assets/images/upload_audio_illustration.png',
                  width: constraints.maxWidth * 0.6,
                );
              },
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.all(16)),
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Ayo pilih gambar yang ingin kamu kompres!',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Semua kompresi dilakukan di perangkat kamu, tidak ada data yang dikirim ke server.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.symmetric(vertical: 64)),
      ],
    );
  }
}
