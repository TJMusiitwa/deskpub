import 'package:deskpub/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PackageDetailsPage extends ConsumerWidget {
  PackageDetailsPage(this.packageName, {super.key});
  final String packageName;

  final singlePackageProvider = FutureProvider.autoDispose
      .family<PubPackage, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    ref.onDispose(() => client.close());
    return await client.packageInfo(packageName);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PubPackage> singlePackage =
        ref.watch(singlePackageProvider(packageName));
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(packageName),
        actions: [
          ToolBarIconButton(
            label: 'Open',
            icon: const MacosIcon(
              CupertinoIcons.link,
            ),
            onPressed: () =>
                launchUrlString('https://pub.dev/packages/$packageName'),
            showLabel: true,
          ),
          ToolBarIconButton(
            label: 'Share',
            icon: const MacosIcon(
              CupertinoIcons.share,
            ),
            onPressed: () =>
                Share.share('https://pub.dev/packages/$packageName'),
            showLabel: true,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, controller) => singlePackage.when(
            data: ((package) => SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(package.description,
                          style: MacosTheme.of(context)
                              .typography
                              .body
                              .copyWith(fontSize: 16)),
                      const SizedBox(height: 16),
                    ],
                  ),
                )),
            error: (error, trace) => Center(child: Text('Error: $error')),
            loading: () => const Center(
              child: ProgressCircle(),
            ),
          ),
        ),
      ],
    );
  }
}
