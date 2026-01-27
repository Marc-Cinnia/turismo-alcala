import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_info_model.dart';

class RouteInfo extends StatelessWidget {
  const RouteInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();

    return Consumer<RouteInfoModel>(
      builder: (context, model, child) {
        if (model.hasData) {
          final routeType = (language.english)
              ? AppConstants.routeTypeLabelEn
              : AppConstants.routeTypeLabel;

          final circuitType = (language.english)
              ? AppConstants.routeCircuitTypeLabelEn
              : AppConstants.routeCircuitTypeLabel;

          final distance = (language.english)
              ? AppConstants.routeDistanceLabelEn
              : AppConstants.routeDistanceLabel;

          final travelTime = (language.english)
              ? AppConstants.routeTravelTimeLabelEn
              : AppConstants.routeTravelTimeLabel;

          final hour = (language.english)
              ? AppConstants.routeHoursLabelEn
              : AppConstants.routeHoursLabel;

          final minute = (language.english)
              ? AppConstants.routeMinutesLabelEn
              : AppConstants.routeMinutesLabel;

          final technicalDifficulty = (language.english)
              ? AppConstants.routeDifficultyLabelEn
              : AppConstants.routeDifficultyLabel;

          final maximumAltitude = (language.english)
              ? AppConstants.routeMaxAltitudeLabelEn
              : AppConstants.routeMaxAltitudeLabel;

          final minimumAltitude = (language.english)
              ? AppConstants.routeMinAltitudeLabelEn
              : AppConstants.routeMinAltitudeLabel;

          final positiveElevationGain = (language.english)
              ? AppConstants.routePosElevationLabelEn
              : AppConstants.routePosElevationLabel;

          final negativeElevationGain = (language.english)
              ? AppConstants.routeNegElevationLabelEn
              : AppConstants.routeNegElevationLabel;

          final routeTypeName = (language.english)
              ? model.routeInfo.routeTypeNameEn
              : model.routeInfo.routeTypeName;

          final routeCircuitTypeName = (language.english)
              ? model.routeInfo.circuitTypeNameEn
              : model.routeInfo.circuitTypeName;

          final difficultyTypeName = (language.english)
              ? model.routeInfo.difficultyTypeNameEn
              : model.routeInfo.difficultyTypeName;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(routeType, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value(routeTypeName, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(circuitType, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value(routeCircuitTypeName, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(distance, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value(model.distance, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(travelTime, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value(
                      '${model.travelTimeInHours} $hour ${model.travelTimeInMins} $minute',
                      context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(technicalDifficulty, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value(difficultyTypeName, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(maximumAltitude, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value('${model.maximumAltitude} m', context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(minimumAltitude, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value('${model.minimumAltitude} m', context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(positiveElevationGain, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value('${model.positiveElevation} m', context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(negativeElevationGain, context),
                  const SizedBox(width: AppConstants.shortSpacing),
                  _value('${model.negativeElevation} m', context),
                ],
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(color: AppConstants.primary),
        );
      },
    );
  }
}

Widget _header(String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: AppConstants.spacing,
      left: AppConstants.spacing,
      right: AppConstants.spacing,
    ),
    child: Text(
      value,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppConstants.primary,
            fontWeight: FontWeight.w600,
          ),
    ),
  );
}

Widget _value(String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: AppConstants.spacing,
      left: AppConstants.spacing,
      right: AppConstants.spacing,
    ),
    child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
  );
}
