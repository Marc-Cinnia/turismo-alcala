import 'package:flutter/material.dart';

class NavigationItem {
  NavigationItem({
    required this.page,
    required this.navKey,
  });

  final Widget page;
  final GlobalKey<NavigatorState> navKey;
}
