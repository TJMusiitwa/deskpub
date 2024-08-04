import 'package:deskpub/pages/package_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/providers.dart';

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
            data: ((data) {
              return ListView.separated(
                controller: ScrollController(),
                primary: false,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final package = data[index];
                  final favouriteDetails =
                      ref.watch(singlePackageProvider(package)).value;
                  return CupertinoListTile(
                    title: Text(
                      '$package ${favouriteDetails?.latest.version}',
                      style: MacosTheme.of(context).typography.title3,
                    ),
                    subtitle: Text(
                      favouriteDetails?.latestPubspec.platforms.keys
                              .map((e) => e)
                              .join(', ') ??
                          '',
                      style: MacosTheme.of(context).typography.title3,
                    ),
                    trailing: Text(
                      timeago.format(favouriteDetails!.latest.published),
                      style: MacosTheme.of(context).typography.title3,
                    ),
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PackageDetailsPage(package))),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: CupertinoColors.opaqueSeparator,
                ),
              );
            }),
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
