import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MacosScaffold(
      toolBar: ToolBar(
        title: Text('Your Bookmarks'),
      ),
    );
  }
}
