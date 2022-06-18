import 'package:deskpub/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown/markdown.dart' as md;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PubPackage> singlePackage =
        ref.watch(singlePackageProvider(packageName));

    AsyncValue<PackageScore> packageScore =
        ref.watch(scorePackageProvider(packageName));

    AsyncValue<String> markdown = ref.watch(markdownProvider(packageName));
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
                        Text(package.url),
                        //SelectableText(package.latestPubspec.homepage! ?? ''),
                        Text(
                            '${package.latestPubspec.homepage!.replaceAll('github.com', 'raw.githubusercontent.com')}/README.md'),
                        const SizedBox(height: 16),
                        package.latestPubspec.homepage!.isNotEmpty == true
                            ? markdown.when(
                                data: (readme) => Markdown(
                                  data: readme,
                                  selectable: true,
                                  shrinkWrap: true,
                                  styleSheetTheme:
                                      MarkdownStyleSheetBaseTheme.platform,
                                  styleSheet:
                                      MarkdownStyleSheet.fromCupertinoTheme(
                                          CupertinoTheme.of(context).copyWith(
                                    brightness:
                                        MacosTheme.of(context).brightness,
                                    primaryColor:
                                        MacosTheme.of(context).primaryColor,
                                    scaffoldBackgroundColor:
                                        MacosTheme.of(context).canvasColor,
                                  )),
                                  extensionSet: md.ExtensionSet.gitHubFlavored,
                                  blockSyntaxes: const [
                                    md.CodeBlockSyntax(),
                                    md.TableSyntax()
                                  ],
                                  inlineSyntaxes: [
                                    md.InlineHtmlSyntax(),
                                    md.CodeSyntax(),
                                  ],
                                  imageBuilder: (url, _, __) =>
                                      url.isScheme('file')
                                          ? const SizedBox.shrink()
                                          : Image.network(
                                              url.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                  onTapLink: (link, _, __) =>
                                      launchUrlString(link),
                                ),
                                error: (error, trace) =>
                                    Center(child: Text('Error: $error')),
                                loading: () =>
                                    const Center(child: ProgressCircle()),
                              )
                            : const Text('No README.md found'),
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
            minWidth: 150,
            resizableSide: ResizableSide.left,
            isResizable: false,
            startWidth: 250)
      ],
    );
  }
}
