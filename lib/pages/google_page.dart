import 'package:deskpub/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

final googlePackagesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final client = ref.watch(pubClientProvider);
  return await client.fetchGooglePackages();
});

class GooglePage extends ConsumerWidget {
  const GooglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<String>> allGooglePackagesList =
        ref.watch(googlePackagesProvider);
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Google Packages'),
      ),
      children: [
        ContentArea(
          builder: (context, controller) => allGooglePackagesList.when(
            data: ((data) => ListView.builder(
                  controller: controller,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final package = data[index];
                    return MacosListTile(
                        title: Text(
                      package,
                      style: MacosTheme.of(context).typography.title3,
                    ));
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
