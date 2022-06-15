import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:deskpub/models/trending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

final todayTrendingProvider =
    FutureProvider.autoDispose<List<Trending>>((ref) async {
  var request = http.Request(
      'GET', Uri.parse('http://api.flutter.space/v1/trending/today.json'));

  //http.StreamedResponse response = await request.send();

  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/today.json'));

  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  // } else {
  //   print(response.reasonPhrase);
  // }
  ref.keepAlive();

  final trending = trendingFromJson(response.body);

  return trending;
});

class TrendingToday extends ConsumerStatefulWidget {
  const TrendingToday({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrendingTodayState();
}

class _TrendingTodayState extends ConsumerState<TrendingToday>
    with AutomaticKeepAliveClientMixin<TrendingToday> {
  @override
  void initState() {
    super.initState();
    ref.read(todayTrendingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final trending = ref.watch(todayTrendingProvider);
    return trending.when(
      data: (data) => ListView.builder(
        controller: ScrollController(),
        primary: false,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final trending = data[index];
          return CupertinoListTile(
              title: Row(
                children: [
                  Text(
                    trending.repoName,
                    style: MacosTheme.of(context).typography.title2,
                  ),
                  const Spacer(),
                  const MacosIcon(
                    CupertinoIcons.star,
                    size: 14,
                    color: CupertinoColors.systemYellow,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trending.totalStars.toString(),
                    style: MacosTheme.of(context)
                        .typography
                        .body
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                trending.description,
                softWrap: true,
                style: MacosTheme.of(context).typography.body,
              ),
              trailing: const SizedBox.shrink(),
              onTap: () => launchUrlString(
                  'https://github.com/${trending.owner}/${trending.repoName}'),
              onLongPress: () => Clipboard.setData(ClipboardData(
                  text:
                      'https://github.com/${trending.owner}/${trending.repoName}')));
        },
      ),
      error: (error, trace) => Center(child: Text('Error: $error')),
      loading: () => const Center(
        child: ProgressCircle(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
