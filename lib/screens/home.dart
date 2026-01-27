import 'package:flutter/material.dart';

import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/navigation_item.dart';
import 'package:valdeiglesias/dtos/section.dart';
import 'package:valdeiglesias/screens/achievments.dart';
import 'package:valdeiglesias/screens/map_screen.dart';
import 'package:valdeiglesias/screens/plan.dart';
import 'package:valdeiglesias/screens/settings.dart';
import 'package:valdeiglesias/screens/visit.dart';
import 'package:valdeiglesias/screens/search.dart';
import 'package:valdeiglesias/widgets/navigation_bar_menu.dart';
import 'package:valdeiglesias/widgets/tab_page.dart';

/// Global variable for manage my plan places.
const List<JourneyPoint> journeyPoints = [];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final visitKey = GlobalKey<NavigatorState>();
  final mapKey = GlobalKey<NavigatorState>();
  final infoKey = GlobalKey<NavigatorState>();
  final searchKey = GlobalKey<NavigatorState>();
  final planKey = GlobalKey<NavigatorState>();
  final settingsKey = GlobalKey<NavigatorState>();
  final List<Section> sectionsForMap = [];

  int selectedTab = 0;
  late List<NavigationItem> navigationItems;
  late Visit visit;
  late MapScreen map;
  late Achievments achievments;

  @override
  void initState() {
    visit = const Visit();
    map = const MapScreen();
    achievments = const Achievments();
    navigationItems = [
      NavigationItem(
        page: TabPage(
          tab: 0,
          tabScreen: visit,
        ),
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
        page: const TabPage(
          tab: 3,
          tabScreen: const SearchScreen(),
        ),
        navKey: searchKey,
      ),
      NavigationItem(
        page: const TabPage(
          tab: 4,
          tabScreen: Plan(),
        ),
        navKey: planKey,
      ),
      NavigationItem(
        page: const TabPage(
          tab: 5,
          tabScreen: const Settings(),
        ),
        navKey: settingsKey,
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        final tabCurrentState =
            navigationItems[selectedTab].navKey.currentState;

        if (tabCurrentState?.canPop() ?? false) {
          tabCurrentState?.popUntil((route) => route.isFirst);
        }
      },
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
        bottomNavigationBar: NavigationBarMenu(
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
