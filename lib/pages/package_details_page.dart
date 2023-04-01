import 'package:deskpub/widgets/readme_markdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:macos_ui/macos_ui.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/providers.dart';

class PackageDetailsPage extends ConsumerWidget {
  PackageDetailsPage(this.packageName, {super.key});
  final String packageName;

  final singlePackageProvider = FutureProvider.autoDispose
      .family<PubPackage, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    ref.onDispose(() => client.close());
    return await client.packageInfo(packageName);
  });

  final scorePackageProvider = FutureProvider.autoDispose
      .family<PackageScore, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    ref.onDispose(() => client.close());
    return await client.packageScore(packageName);
  });

  final metricsPackageProvider = FutureProvider.autoDispose
      .family<PackageMetrics?, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    ref.onDispose(() => client.close());
    return await client.packageMetrics(packageName);
  });

  final markdownProvider = FutureProvider.autoDispose
      .family<String, String>((ref, packageName) async {
    http.Response response;

    final client = ref.watch(pubClientProvider).packageInfo(packageName);
    final data = client.then((value) async {
      return '${value.latestPubspec.homepage!.replaceAll('github.com', 'raw.githubusercontent.com')}/README.md'
          .replaceFirst('/tree', '');
    }).then((url) async {
      response = await http.get(Uri.parse(url));
      return response.body;
    });

    return data.then((value) => value);
  });

  final packageReadmeProvider = FutureProvider.autoDispose
      .family<String, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    final githubClient = ref.watch(githubClientProvider);

    final owner = await client.packageInfo(packageName).then((value) =>
        value.latestPubspec.author ??
        value.latestPubspec.homepage!.split('/')[3]);
    final name = await client
        .packageInfo(packageName)
        .then((value) => value.latestPubspec.name ?? value.name);
    final readme =
        githubClient.repositories.getReadme(RepositorySlug(owner, name));

    ref.onDispose(() {
      client.close();
      githubClient.client.close();
    });

    return readme.then((value) => value.text);
  });

  final githubStuffProvider = FutureProvider.autoDispose
      .family<GitHubFile, String>((ref, packageName) async {
    final client = ref.watch(pubClientProvider);
    final githubClient = ref.watch(githubClientProvider);

    final owner = await client.packageInfo(packageName).then((value) =>
        value.latestPubspec.author ??
        value.latestPubspec.homepage!.split('/')[3]);
    final name = await client
        .packageInfo(packageName)
        .then((value) => value.latestPubspec.name ?? value.name);
    final readme =
        githubClient.repositories.getReadme(RepositorySlug(owner, name));

    ref.onDispose(() {
      client.close();
      githubClient.client.close();
    });

    return readme.then((value) => value);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PubPackage> singlePackage =
        ref.watch(singlePackageProvider(packageName));

    AsyncValue<PackageScore> packageScore =
        ref.watch(scorePackageProvider(packageName));

    AsyncValue<String> markdown = ref.watch(markdownProvider(packageName));

    AsyncValue<String?> packageReadme =
        ref.watch(packageReadmeProvider(packageName));

    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(packageName),
        titleWidth: 400,
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
          builder: (context, controller) {
            return singlePackage.when(
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
                        ...[
                          if (package.latestPubspec.homepage != null)
                            package.latestPubspec.homepage
                                    !.contains('github.com')
                                ? SelectableText(
                                    'Raw ReadmeURL: ${package.latestPubspec.homepage!.replaceAll('github.com', 'raw.githubusercontent.com')}/README.md'
                                        .replaceFirst('/tree', ''))
                                : package.latestPubspec.unParsedYaml!
                                        .containsKey('repository')
                                    ? SelectableText(
                                        'From UnparsedYaml: ${package.latestPubspec.unParsedYaml!['repository']}README.md')
                                    : const Text('nothing here'),
                        ],
                        const SizedBox(height: 16),
                        SelectableText(
                            'From UnparsedYaml: ${package.latestPubspec.unParsedYaml!['repository']}README.md'),
                        const SizedBox(height: 16),
                        markdown.when(
                          data: ((data) => PackageReadMeMarkdown(readme: data)),
                          error: (error, trace) =>
                              Center(child: Text('Error: $error')),
                          loading: () => const Center(child: ProgressCircle()),
                        )
                      ],
                    ),
                  )),
              error: (error, trace) => Center(child: Text('Error: $error')),
              loading: () => const Center(
                child: ProgressCircle(),
              ),
            );
          },
        ),
        ResizablePane(
            builder: (_, __) => packageScore.when(
                  data: (score) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(score.likeCount.toString()),
                          Text(score.grantedPoints.toString()),
                          Text(
                              '${(score.popularityScore! * 100).toStringAsFixed(0)}%'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('LIKES'),
                          Text('PUB POINTS'),
                          Text('POPULARITY'),
                        ],
                      ),
                      // Wrap(
                      //     children: metrics.scorecard.derivedTags
                      //         .map((tag) => Text('$tag, '))
                      //         .toList()),
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
            minSize: 150,
            resizableSide: ResizableSide.left,
            isResizable: false,
            startSize: 250)
      ],
    );
  }
}
