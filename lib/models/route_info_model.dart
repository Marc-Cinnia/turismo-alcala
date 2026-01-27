import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_info.dart';

class RouteInfoModel extends ChangeNotifier {
  RouteInfoModel({
    required this.routeTypeId,
    required this.circuitTypeId,
    required this.distance,
    required this.travelTimeInHours,
    required this.travelTimeInMins,
    required this.difficultyId,
    required this.maximumAltitude,
    required this.minimumAltitude,
    required this.positiveElevation,
    required this.negativeElevation,
  }) {
    _fetchRouteInfo();
  }

  final int routeTypeId;
  final int circuitTypeId;
  final String distance;
  final int travelTimeInHours;
  final int travelTimeInMins;
  final int difficultyId;
  final int maximumAltitude;
  final int minimumAltitude;
  final int positiveElevation;
  final int negativeElevation;

  late RouteInfo _routeInfo;
  bool _dataFetched = false;

  RouteInfo get routeInfo => _routeInfo;

  bool get hasData => _dataFetched;

  void _fetchRouteInfo() async {
    final routeTypeResponse = await http.get(
      Uri.parse(AppConstants.routeType),
    );
    final routeTypeResponseEn = await http.get(
      Uri.parse(AppConstants.routeTypeEn),
    );
    final circuitTypeResponse = await http.get(
      Uri.parse(AppConstants.circuitType),
    );
    final circuitTypeResponseEn = await http.get(
      Uri.parse(AppConstants.circuitTypeEn),
    );
    final difficultyResponse = await http.get(
      Uri.parse(AppConstants.difficultyType),
    );
    final difficultyResponseEn = await http.get(
      Uri.parse(AppConstants.difficultyTypeEn),
    );

    String routeTypeName = '';
    String routeTypeNameEn = '';
    String circuitTypeName = '';
    String circuitTypeNameEn = '';
    String difficultyTypeName = '';
    String difficultyTypeNameEn = '';

    // Route type name
    if (routeTypeResponse.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(routeTypeResponse.body);

      for (var item in body) {
        int routeTypeIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (routeTypeId == routeTypeIdFetched) {
          routeTypeName =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    if (routeTypeResponseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(routeTypeResponseEn.body);

      for (var item in body) {
        int routeTypeIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (routeTypeId == routeTypeIdFetched) {
          routeTypeNameEn =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    // Circuit type name
    if (circuitTypeResponse.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(circuitTypeResponse.body);

      for (var item in body) {
        int circuitTypeIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (circuitTypeId == circuitTypeIdFetched) {
          circuitTypeName =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    if (circuitTypeResponseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(circuitTypeResponseEn.body);

      for (var item in body) {
        int circuitTypeIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (circuitTypeId == circuitTypeIdFetched) {
          circuitTypeNameEn =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    // Difficulty type name
    if (difficultyResponse.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(difficultyResponse.body);

      for (var item in body) {
        int difficultyIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (difficultyId == difficultyIdFetched) {
          difficultyTypeName =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    if (difficultyResponseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(difficultyResponseEn.body);

      for (var item in body) {
        int difficultyIdFetched =
            item[AppConstants.idKey].first[AppConstants.valueKey];

        if (difficultyId == difficultyIdFetched) {
          difficultyTypeNameEn =
              item[AppConstants.nameKey].first[AppConstants.valueKey];
        }
      }
    }

    _routeInfo = RouteInfo(
      routeTypeName: routeTypeName,      
      routeTypeNameEn: routeTypeNameEn,
      circuitTypeName: circuitTypeName,
      circuitTypeNameEn: circuitTypeNameEn,
      difficultyTypeName: difficultyTypeName,
      difficultyTypeNameEn: difficultyTypeNameEn,
    );

    _dataFetched = true;
    notifyListeners();
  }
}
