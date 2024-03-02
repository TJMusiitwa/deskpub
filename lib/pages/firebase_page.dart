import 'package:deskpub/pages/package_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/providers.dart';

class FirebasePage extends ConsumerWidget {
  const FirebasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MacosScaffold(
      toolBar: const ToolBar(title: Text('Firebase Packages')),
      children: [
        ContentArea(
          builder: (context, controller) =>
              ref.watch(firebasePackagesProvider).when(
                    data: ((data) => ListView.separated(
                          controller: ScrollController(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final package = data[index];
                            // final packageDetail = ref
                            //     .watch(singlePackageProvider(package.package))
                            //     .value!;
                            return CupertinoListTile(
                              title: Text(
                                package.package,
                                style: MacosTheme.of(context).typography.title2,
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          PackageDetailsPage(package.package))),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(
                            color: CupertinoColors.opaqueSeparator,
                          ),
                          primary: false,
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
