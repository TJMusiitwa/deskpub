import 'package:deskpub/pages/trending/trending_month.dart';
import 'package:deskpub/pages/trending/trending_today.dart';
import 'package:deskpub/pages/trending/trending_week.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

import '../providers/providers.dart';

class TrendingPage extends ConsumerStatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrendingPageState();
}

class _TrendingPageState extends ConsumerState<TrendingPage>
    with AutomaticKeepAliveClientMixin<TrendingPage> {
  int _selectedViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Trending Repositories'),
        titleWidth: 250,
        actions: [
          ToolBarIconButton(
              label: 'Refresh',
              icon: const MacosIcon(CupertinoIcons.refresh),
              showLabel: true,
              onPressed: () {
                ref.invalidate(monthTrendingProvider);
                ref.invalidate(todayTrendingProvider);
                ref.read(weekTrendingProvider);
              }),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, controller) {
            return Stack(children: [
              SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  controller: controller,
                  child: _selectedViewIndex == 0
                      ? const TrendingToday()
                      : _selectedViewIndex == 1
                          ? const TrendingWeek()
                          : const TrendingMonth()),
              Positioned(
                top: 10,
                left: 50,
                right: 50,
                child: CupertinoSlidingSegmentedControl(
                  children: const {
                    0: Text('Today'),
                    1: Text('Week'),
                    2: Text('Month'),
                  },
                  groupValue: _selectedViewIndex,
                  thumbColor: MacosTheme.of(context).primaryColor,
                  onValueChanged: (value) =>
                      setState(() => _selectedViewIndex = value as int),
                ),
              )
            ]);
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
