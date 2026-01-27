import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/widgets/bottom_sheet_actions.dart';
import 'package:valdeiglesias/widgets/bottom_sheet_header.dart';
import 'package:valdeiglesias/widgets/filter_list.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet({
    super.key,
    this.itemsDescription,
    this.itemsDescriptionEn,
  });

  final String? itemsDescription;
  final String? itemsDescriptionEn;

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final title = (language.english)
        ? '${AppConstants.serviceFilterLabelEn} '
        : '${AppConstants.serviceFilterLabelEs} ';

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            BottomSheetHeader(title: title),
            FilterList(),
            BottomSheetActions(),
          ],
        ),
      ),
    );
  }
}
