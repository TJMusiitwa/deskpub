import 'dart:io';

import 'package:deskpub/pages/bookmark_page.dart';
import 'package:deskpub/pages/favourites_page.dart';
import 'package:deskpub/pages/google_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int pageIndex = 0;

  final List<Widget> pages = <Widget>[
    //CupertinoTabView(builder: (BuildContext context) => const MenuPage()),
    const FavouritesPage(),
    const GooglePage(),
    const BookmarkPage(),

    //const CartPage(),
    //CupertinoTabView(builder: (BuildContext context) => const SettingsPage()),
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
                          leading: Icon(CupertinoIcons.heart_solid),
                        ),
                        SidebarItem(
                            leading: Icon(Icons.android),
                            label: Text('Google Packages')),
                        SidebarItem(
                          label: Text('Bookmarks'),
                          leading: Icon(CupertinoIcons.bookmark_fill),
                        ),
                      ],
                    ),
                minWidth: 200),
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
                    icon: const Icon(FluentIcons.heart),
                    title: const Text('Flutter Favourites'),
                  ),
                  PaneItem(
                    icon: const Icon(Icons.android),
                    title: const Text('Google Packages'),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.bookmarks),
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
