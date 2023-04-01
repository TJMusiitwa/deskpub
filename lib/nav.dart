import 'dart:io';

import 'package:deskpub/pages/bookmark_page.dart';
import 'package:deskpub/pages/favourites_page.dart';
import 'package:deskpub/pages/firebase_page.dart';
import 'package:deskpub/pages/google_page.dart';
import 'package:deskpub/pages/trending_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:macos_ui/macos_ui.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int pageIndex = 0;

  final List<Widget> pages = <Widget>[
    //CupertinoTabView(builder: (BuildContext context) => const MenuPage()),
    CupertinoTabView(builder: (BuildContext context) => const FavouritesPage()),
    CupertinoTabView(builder: (BuildContext context) => const GooglePage()),
    CupertinoTabView(builder: (BuildContext context) => const FirebasePage()),
    CupertinoTabView(builder: (BuildContext context) => const TrendingPage()),
    CupertinoTabView(builder: (BuildContext context) => const BookmarkPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Platform.isMacOS
        ? MacosWindow(
            sidebar: Sidebar(
                builder: (_, controller) => SidebarItems(
                      currentIndex: pageIndex,
                      onChanged: (i) => setState(
                        (() => pageIndex = i),
                      ),
                      items: [
                        const SidebarItem(
                          label: Text('Flutter Favourites'),
                          leading: MacosIcon(
                            CupertinoIcons.rosette,
                            color: CupertinoColors.systemPink,
                          ),
                        ),
                        SidebarItem(
                            leading: SvgPicture.asset('assets/google.svg',
                            colorFilter: const ColorFilter.mode(
                                  CupertinoColors.systemGreen, BlendMode.srcIn),
                                ),
                            label: const Text('Google Packages')),
                        SidebarItem(
                            leading: SvgPicture.asset('assets/firebase.svg',
                            colorFilter: const ColorFilter.mode(
                                    CupertinoColors.systemYellow,
                                    BlendMode.srcIn),
                               ),
                            label: const Text('Firebase Packages')),
                        const SidebarItem(
                            leading: MacosIcon(
                              CupertinoIcons.chart_bar,
                              color: CupertinoColors.systemIndigo,
                            ),
                            label: Text('Trending Repositories')),
                        const SidebarItem(
                          label: Text('Bookmarks'),
                          leading: MacosIcon(CupertinoIcons.bookmark_fill),
                        ),
                      ],
                    ),
                minWidth: 250),
            child: IndexedStack(
              index: pageIndex,
              children: pages,
            ))
        : NavigationView(
            appBar: const NavigationAppBar(
              title: Text('DeskPub'),
              automaticallyImplyLeading: false,
            ),
            pane: NavigationPane(
                selected: pageIndex,
                onChanged: (changed) => setState(() => pageIndex = changed),
                size: const NavigationPaneSize(
                  openMinWidth: 250,
                  openMaxWidth: 350,
                ),
                displayMode: PaneDisplayMode.open,
                items: [
                  PaneItem(
                    icon: Icon(
                      FluentIcons.heart,
                      color: Colors.red,
                    ),
                    title: const Text('Flutter Favourites'),
                    body: const FavouritesPage(),
                  ),
                  PaneItem(
                    icon: Icon(Icons.android, color: Colors.green),
                    title: const Text('Google Packages'),
                    body: const GooglePage(),
                  ),
                  PaneItem(
                    icon: Icon(
                      FluentIcons.flame_solid,
                      color: Colors.yellow,
                    ),
                    title: const Text('Firebase Packages'),
                    body: const FirebasePage(),
                  ),
                  PaneItem(
                    icon: Icon(
                      FluentIcons.graph_symbol,
                      color: Colors.yellow,
                    ),
                    title: const Text('Trending Repositories'),
                    body: const TrendingPage(),
                  ),
                  PaneItem(
                      icon: Icon(
                        FluentIcons.bookmarks,
                        color: Colors.blue,
                      ),
                      title: const Text('Bookmarks'),
                      body: const BookmarkPage()),
                ]),
            transitionBuilder: (child, animation) {
              return EntrancePageTransition(animation: animation, child: child);
            },
          );
  }
}
