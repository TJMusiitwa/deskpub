import 'package:deskpub/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:timeago/timeago.dart' as timeago;

class PackageVersionsPage extends ConsumerWidget {
  const PackageVersionsPage(this.packageName, {super.key});
  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageDetail = ref.watch(singlePackageProvider(packageName));
    return MacosScaffold(
      toolBar: const ToolBar(title: Text('Package Versions'), titleWidth: 300),
      children: [
        ContentArea(
          builder: (context, controller) => packageDetail.when(
            data: ((package) => ListView.separated(
                  controller: ScrollController(),
                  primary: false,
                  itemCount: package.versions.length,
                  itemBuilder: (context, index) {
                    final version = package.versions.reversed.toList()[index];
                    return CupertinoListTile(
                      title: Text(version.version),
                      trailing: Text(timeago.format(version.published)),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: CupertinoColors.opaqueSeparator,
                  ),
                )),
            error: (error, trace) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: ProgressCircle()),
          ),
        ),
      ],
    );
  }
}
