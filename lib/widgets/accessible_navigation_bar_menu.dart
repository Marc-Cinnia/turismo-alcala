import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/widgets/accessible_menu_item.dart';

class AccessibleNavigationBarMenu extends StatelessWidget {
  const AccessibleNavigationBarMenu({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  final int pageIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    bool english = context.watch<LanguageModel>().english;
    var borderRadius = BorderRadius.circular(AppConstants.borderRadius);

    return Container(
      height: 100.0,
      margin: const EdgeInsets.all(AppConstants.shortSpacing),
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: const Color.fromRGBO(4, 134, 170, 1), // #B8223D
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.shortSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccessibleMenuItem(
                    icon: Icons.explore_outlined,
                    label: (english)
                        ? AppConstants.visitMenuLabelEn
                        : AppConstants.visitMenuLabel,
                    selected: pageIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  AccessibleMenuItem(
                    icon: Icons.map_outlined,
                    label: (english)
                        ? AppConstants.mapMenuLabelEn
                        : AppConstants.mapMenuLabel,
                    selected: pageIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  AccessibleMenuItem(
                    icon: Icons.emoji_events_outlined,
                    label: (english)
                        ? AppConstants.achievmentsLabelEn
                        : AppConstants.achievmentsLabel,
                    selected: pageIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  AccessibleMenuItem(
                    icon: Icons.list_outlined,
                    label: (english)
                        ? AppConstants.planMenuLabelEn
                        : AppConstants.planMenuLabel,
                    selected: pageIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  AccessibleMenuItem(
                    icon: Icons.settings_outlined,
                    label: (english)
                        ? AppConstants.settingsMenuLabelEn
                        : AppConstants.settingsMenuLabel,
                    selected: pageIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // return Container(
    //   height: 100.0,
    //   margin: const EdgeInsets.all(AppConstants.shortSpacing),
    //   child: BottomAppBar(
    //     elevation: 0.0,
    //     color: Colors.transparent,
    //     child: Card(
    //       elevation: 4.0,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: borderRadius,
    //       ),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: borderRadius,
    //           color: AppConstants.primary,
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(AppConstants.shortSpacing),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               GestureDetector(
    //                 child: Row(
    //                   children: [
    //                     Icon(Icons.menu_outlined),
    //                     Text('Menu'),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),

    //         // Padding(
    //         //   padding: const EdgeInsets.all(AppConstants.shortSpacing),
    //         //   child: Row(
    //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //     children: [
    //         //       MenuItem(
    //         //         icon: Icons.explore_outlined,
    //         //         label: (english)
    //         //             ? AppConstants.visitMenuLabelEn
    //         //             : AppConstants.visitMenuLabel,
    //         //         selected: pageIndex == 0,
    //         //         onTap: () => onTap(0),
    //         //       ),
    //         //       MenuItem(
    //         //         icon: Icons.map_outlined,
    //         //         label: (english)
    //         //             ? AppConstants.mapMenuLabelEn
    //         //             : AppConstants.mapMenuLabel,
    //         //         selected: pageIndex == 1,
    //         //         onTap: () => onTap(1),
    //         //       ),
    //         //       MenuItem(
    //         //         icon: Icons.emoji_events_outlined,
    //         //         label: (english)
    //         //             ? AppConstants.achievmentsLabelEn
    //         //             : AppConstants.achievmentsLabel,
    //         //         selected: pageIndex == 2,
    //         //         onTap: () => onTap(2),
    //         //       ),
    //         //       MenuItem(
    //         //         icon: Icons.list_outlined,
    //         //         label: (english)
    //         //             ? AppConstants.planMenuLabelEn
    //         //             : AppConstants.planMenuLabel,
    //         //         selected: pageIndex == 3,
    //         //         onTap: () => onTap(3),
    //         //       ),
    //         //       MenuItem(
    //         //         icon: Icons.settings_outlined,
    //         //         label: (english)
    //         //             ? AppConstants.settingsMenuLabelEn
    //         //             : AppConstants.settingsMenuLabel,
    //         //         selected: pageIndex == 4,
    //         //         onTap: () => onTap(4),
    //         //       ),
    //         //     ],
    //         //   ),
    //         // ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
