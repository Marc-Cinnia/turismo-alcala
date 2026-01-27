import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:valdeiglesias/constants/app_constants.dart';

class JourneyPoint {
  JourneyPoint({
    required this.id,
    required this.placeName,
    required this.visitDate,
    required this.placeType,
    this.placeLatitude,
    this.placeLongitude,
    this.placeIndex,
  });
  
  final DateTime visitDate;
  final String placeType;
  
  int id;
  String placeName;
  double? placeLatitude;
  double? placeLongitude;
  int? placeIndex;

  Map<String, String> toJson() {
    return {
      'placeLatitude': placeLatitude.toString(),
      'placeLongitude': placeLongitude.toString(),
      'visitDate': visitDate.toIso8601String(),
      'placeName': placeName,
      'placeType': placeType,
    };
  }

  static JourneyPoint fromJson(String json) {
    Map<String, dynamic> decoded = jsonDecode(json);
    final df = DateFormat(AppConstants.planDateFormat);

    final journeyPoint = JourneyPoint(
      id: decoded[AppConstants.idDataKey],
      placeLatitude: decoded[AppConstants.planPlaceLatKey],
      placeLongitude: decoded[AppConstants.planPlaceLonKey],
      visitDate: df.parse(decoded[AppConstants.planVisitDateKey]),
      placeName: decoded[AppConstants.planPlaceNameKey],
      placeType: decoded[AppConstants.planPlaceTypeKey],
    );

    return journeyPoint;
  }
}
