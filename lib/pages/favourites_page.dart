import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return const MacosScaffold(
      toolBar: ToolBar(
        title: Text('Flutter Favourite Packages'),
        titleWidth: 300,
      ),
    );
  }
}
