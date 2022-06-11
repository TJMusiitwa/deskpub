import 'package:deskpub/nav.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pub_api_client/pub_api_client.dart';

final client = Provider.autoDispose<PubClient>((ref) => PubClient());
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'DeskPub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfffafafa),
      ),
      home: const Nav(),
    );
  }
}
