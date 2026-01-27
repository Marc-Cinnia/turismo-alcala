import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/widgets/plan_map.dart';
import 'package:valdeiglesias/widgets/plan_places_list.dart';

class PlanMainContent extends StatelessWidget {
  const PlanMainContent({super.key});

  final planMap = const PlanMap();
  final planPlacesList = const PlanPlacesList();

  @override
  Widget build(BuildContext context) {
    final placesAdded = context.watch<PlanModel>().placesAdded();
    final english = context.watch<LanguageModel>().english;
    final planEmptyPlacesLabel = (english)
        ? AppConstants.planEmptyPlacesLabelEn
        : AppConstants.planEmptyPlacesLabel;

    if (placesAdded) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            planMap,
            const SizedBox(height: AppConstants.spacing),
            planPlacesList,
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          planEmptyPlacesLabel,
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
