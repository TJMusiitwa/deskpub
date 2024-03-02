import 'package:deskpub/pages/package_versions_page.dart';
import 'package:deskpub/widgets/readme_markdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/providers.dart';

class PackageDetailsPage extends ConsumerWidget {
  const PackageDetailsPage(this.packageName, {super.key});
  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PubPackage> singlePackage =
        ref.watch(singlePackageProvider(packageName));

    AsyncValue<PackageScore> packageScore =
        ref.watch(scorePackageProvider(packageName));

    AsyncValue<String?> packageReadme =
        ref.watch(packageReadmeProvider(packageName));

    // AsyncValue<PackageMetrics?> packageMetrics =
    //     ref.watch(metricsPackageProvider(packageName));

    return singlePackage.when(
      data: ((package) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverToolBar(
              title: Text(packageName),
              titleWidth: 400,
              actions: [
                const ToolBarIconButton(
                  label: 'Bookmark',
                  icon: MacosIcon(CupertinoIcons.bookmark),
                  onPressed: null,
                  showLabel: true,
                ),
                ToolBarIconButton(
                  label: 'Open',
                  icon: const MacosIcon(CupertinoIcons.globe),
                  onPressed: () => launchUrlString(package.url),
                  showLabel: true,
                ),
                ToolBarIconButton(
                  label: 'Changelog',
                  icon: const MacosIcon(CupertinoIcons.doc),
                  onPressed: () => launchUrlString(package.changelogUrl),
                  showLabel: true,
                ),
                ToolBarIconButton(
                  label: 'Share',
                  icon: const MacosIcon(CupertinoIcons.share),
                  onPressed: () =>
                      Share.share('https://pub.dev/packages/$packageName'),
                  showLabel: true,
                ),
                ToolBarIconButton(
                  label: 'Versions',
                  icon: const MacosIcon(CupertinoIcons.list_bullet),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                PackageVersionsPage(packageName)));
                  },
                  showLabel: true,
                ),
              ],
            ),
            SliverFillRemaining(
              child: ContentArea(
                builder: (context, controller) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(package.description,
                            style: MacosTheme.of(context)
                                .typography
                                .body
                                .copyWith(fontSize: 16)),
                        const SizedBox(height: 20),
                        packageScore.when(
                          data: (score) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(score.likeCount.toString()),
                                  Text(score.grantedPoints.toString()),
                                  Text(
                                      '${(score.popularityScore! * 100).toStringAsFixed(0)}%'),
                                  Text(ref
                                          .watch(packagePublisherProvider(
                                              packageName))
                                          .whenData((publisher) => publisher)
                                          .value
                                          ?.publisherId ??
                                      '')
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Likes'),
                                  Text('Pub Points'),
                                  Text('Popularity'),
                                  Text('Publisher')
                                ],
                              ),
                            ],
                          ),
                          error: (error, trace) {
                            debugPrint(trace.toString());
                            return Center(child: Text('Error: $error'));
                          },
                          loading: () => const Center(
                            child: Text('Loading Package Metrics...'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        packageReadme.when(
                          data: ((data) =>
                              PackageReadMeMarkdown(readme: data!)),
                          error: (error, trace) =>
                              Center(child: Text('Error: $error')),
                          loading: () => const Center(child: ProgressCircle()),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
      error: (error, trace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: ProgressCircle()),
    );
  }
}
