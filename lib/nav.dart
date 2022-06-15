import 'dart:io';

import 'package:deskpub/pages/bookmark_page.dart';
import 'package:deskpub/pages/favourites_page.dart';
import 'package:deskpub/pages/firebase_page.dart';
import 'package:deskpub/pages/google_page.dart';
import 'package:deskpub/pages/trending_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
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
                      items: const [
                        SidebarItem(
                          label: Text('Flutter Favourites'),
                          leading: MacosIcon(
                            CupertinoIcons.rosette,
                            color: CupertinoColors.systemPink,
                          ),
                        ),
                        SidebarItem(
                            leading: MacosIcon(
                              Icons.android,
                              color: CupertinoColors.systemGreen,
                            ),
                            label: Text('Google Packages')),
                        SidebarItem(
                            leading: MacosIcon(
                              CupertinoIcons.flame_fill,
                              color: CupertinoColors.systemYellow,
                            ),
                            label: Text('Firebase Packages')),
                        SidebarItem(
                            leading: MacosIcon(
                              CupertinoIcons.chart_bar,
                              color: CupertinoColors.systemIndigo,
                            ),
                            label: Text('Trending Repositories')),
                        SidebarItem(
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
                  ),
                  PaneItem(
                    icon: Icon(Icons.android, color: Colors.green),
                    title: const Text('Google Packages'),
                  ),
                  PaneItem(
                    icon: Icon(
                      FluentIcons.flame_solid,
                      color: Colors.yellow,
                    ),
                    title: const Text('Firebase Packages'),
                  ),
                  PaneItem(
                    icon: Icon(
                      FluentIcons.graph_symbol,
                      color: Colors.yellow,
                    ),
                    title: const Text('Trending Repositories'),
                  ),
                  PaneItem(
                    icon: Icon(
                      FluentIcons.bookmarks,
                      color: Colors.blue,
                    ),
                    title: const Text('Bookmarks'),
                  ),
                ]),
            content: NavigationBody(
              index: pageIndex,
              children: pages,
              transitionBuilder: (child, animation) {
                return EntrancePageTransition(
                    animation: animation, child: child);
              },
            ),
          );
  }
}
