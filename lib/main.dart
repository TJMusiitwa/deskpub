import 'package:deskpub/nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  await _configureMacosWindowUtils();
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
        //typography: MacosTypography.of(context).,
      ),
      themeMode: ThemeMode.system,
      home: const Nav(),
    );
  }
}
