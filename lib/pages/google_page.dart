import 'package:deskpub/pages/package_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/providers.dart';

class GooglePage extends ConsumerWidget {
  const GooglePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<String>> allGooglePackagesList =
        ref.watch(googlePackagesProvider);
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Google Packages'),
        actions: [
          //? Work on adding search as done in https://github.com/TJMusiitwa/not_apple_developer/blob/77d4b5d3596b92e2b917ced0f63c6d8947b5e57e/lib/pages/search.dart
          CustomToolbarItem(inToolbarBuilder: (context) {
            return SizedBox(
              width: 200,
              child: MacosSearchField(
                placeholder: 'Search',
                onChanged: (value) {},
              ),
            );
          }),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, controller) => allGooglePackagesList.when(
            data: ((data) => ListView.separated(
                  controller: ScrollController(),
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
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    height: 1,
                    color: MacosColors.separatorColor,
                  ),
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
