import 'package:flutter/material.dart';

import 'package:valdeiglesias/dtos/navigation_item.dart';
import 'package:valdeiglesias/dtos/section.dart';
import 'package:valdeiglesias/screens/accessible_visit.dart';
import 'package:valdeiglesias/screens/achievments.dart';
import 'package:valdeiglesias/screens/map_screen.dart';
import 'package:valdeiglesias/screens/plan.dart';
import 'package:valdeiglesias/screens/settings.dart';
import 'package:valdeiglesias/widgets/accessible_navigation_bar_menu.dart';
import 'package:valdeiglesias/widgets/tab_page.dart';

class AccessibleHome extends StatefulWidget {
  const AccessibleHome({super.key});

  @override
  State<AccessibleHome> createState() => _AccessibleHomeState();
}

class _AccessibleHomeState extends State<AccessibleHome> {
  final visitKey = GlobalKey<NavigatorState>();
  final mapKey = GlobalKey<NavigatorState>();
  final infoKey = GlobalKey<NavigatorState>();
  final planKey = GlobalKey<NavigatorState>();
  final settingsKey = GlobalKey<NavigatorState>();
  final List<Section> sectionsForMap = [];

  int selectedTab = 0;

  late List<NavigationItem> navigationItems;
  late AccessibleVisit visit;
  late MapScreen map;
  late Achievments achievments;
  late Plan plan;
  late Settings settings;

  @override
  void initState() {
    visit = const AccessibleVisit();
    map = const MapScreen();
    achievments = const Achievments();
    plan = const Plan();
    settings = const Settings();

    navigationItems = [
      NavigationItem(
        page: TabPage(tab: 0, tabScreen: visit),
        navKey: visitKey,
      ),
      NavigationItem(
        page: const TabPage(
          tab: 1,
          tabScreen: MapScreen(),
        ),
        navKey: mapKey,
      ),
      NavigationItem(
        page: TabPage(
          tab: 2,
          tabScreen: achievments,
        ),
        navKey: infoKey,
      ),
      NavigationItem(
        page: TabPage(
          tab: 3,
          tabScreen: plan,
        ),
        navKey: planKey,
      ),
      NavigationItem(
        page: TabPage(
          tab: 4,
          tabScreen: settings,
        ),
        navKey: settingsKey,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: selectedTab,
          children: navigationItems
              .map(
                (page) => Navigator(
                  key: page.navKey,
                  onGenerateInitialRoutes: (navigatorState, initialRoute) {
                    return [MaterialPageRoute(builder: (context) => page.page)];
                  },
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: AccessibleNavigationBarMenu(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              navigationItems[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() => selectedTab = index);
            }
          },
        ),
      ),
    );
  }
}
