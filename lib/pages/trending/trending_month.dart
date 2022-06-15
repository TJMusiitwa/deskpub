import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:deskpub/models/trending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

final monthTrendingProvider = FutureProvider<List<Trending>>((ref) async {
  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/month.json'));

  final trending = trendingFromJson(response.body);
  return trending;
});

class TrendingMonth extends ConsumerWidget {
  const TrendingMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Trending>> trending = ref.watch(monthTrendingProvider);

    return trending.when(
      data: (data) => ListView.builder(
        controller: ScrollController(),
        primary: false,
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final trending = data[index];
          return CupertinoListTile(
            title: Text(
              trending.repoName,
              style: MacosTheme.of(context).typography.title2,
            ),
            subtitle: Text(
              trending.description,
              softWrap: true,
              style: MacosTheme.of(context).typography.body,
            ),
            trailing: const MacosIcon(CupertinoIcons.link),
            onTap: () => launchUrlString(
                'https://github.com/${trending.owner}/${trending.repoName}'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text:
                          'https://github.com/${trending.owner}/${trending.repoName}'))
                  .whenComplete(() => debugPrint('Link copied'));
            },
          );
        },
      ),
      error: (error, trace) => Center(child: Text('Error: $error')),
      loading: () => const Center(
        child: ProgressCircle(),
      ),
    );
  }
}
