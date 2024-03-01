import 'package:deskpub/models/trending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../providers/providers.dart';

class TrendingWeek extends ConsumerWidget {
  const TrendingWeek({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Trending>> trending = ref.watch(weekTrendingProvider);
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
            // onLongPress: () => Clipboard.setData(ClipboardData(
            //         text:
            //             'https://github.com/${trending.owner}/${trending.repoName}'))
            //     .whenComplete(() => debugPrint('Link copied')),
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
