import 'package:flutter/material.dart';

class TabPage extends StatelessWidget {
  const TabPage({
    super.key,
    required this.tab,
    required this.tabScreen,
  });

  final int tab;
  final Widget tabScreen;

  @override
  Widget build(BuildContext context) => tabScreen;
}
