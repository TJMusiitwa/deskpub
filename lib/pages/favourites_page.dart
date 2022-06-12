import 'package:deskpub/main.dart';
import 'package:deskpub/pages/package_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

final flutterFavouritesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final client = ref.watch(pubClientProvider);
  ref.onDispose(() => client.close());
  return await client.fetchFlutterFavorites();
});

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<String>> allFlutterFavouritesList =
        ref.watch(flutterFavouritesProvider);
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Flutter Favourite Packages'),
        titleWidth: 300,
      ),
      children: [
        ContentArea(
          builder: (context, controller) => allFlutterFavouritesList.when(
            data: ((data) => ListView.builder(
                  controller: ScrollController(),
                  primary: false,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final package = data[index];
                    return MacosListTile(
                      title: Text(
                        package,
                        style: MacosTheme.of(context).typography.title3,
                      ),
                      onClick: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  PackageDetailsPage(package))),
                    );
                  },
                )),
            error: (error, trace) => Center(
              child: Text('Error: $error'),
            ),
            loading: () => const Center(
              child: ProgressCircle(),
            ),
          ),
        ),
      ],
    );
  }
}
