import 'package:deskpub/nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pub_api_client/pub_api_client.dart';

final pubClientProvider = Provider.autoDispose<PubClient>((ref) => PubClient());
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'DeskPub',
      debugShowCheckedModeBanner: false,
      theme: MacosThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        canvasColor: const Color(0xFFFAFAFA),
      ),
      darkTheme: MacosThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xff044064),
        iconTheme: const MacosIconThemeData(
          color: Color(0xffa7b39a),
        ),
        typography: MacosTypography.white,
      ),
      themeMode: ThemeMode.system,
      home: const Nav(),
    );
  }
}
