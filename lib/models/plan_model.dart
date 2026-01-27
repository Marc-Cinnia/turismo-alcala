import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';

class PlanModel extends ChangeNotifier {
  PlanModel() {
    _fetchSavedPoints();
  }

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  final List<JourneyPoint?> _points = [];
  final String _journeyPlacesKey = 'journeyPlaces';

  bool _isPlanUploaded = false;

  List<dynamic> _fetchedPlan = [];
  
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  void _fetchSavedPoints() async {
    List<String>? places = await _asyncPrefs.getStringList(_journeyPlacesKey);
    _currentPosition = await getCurrentLocation();

    if (places != null && places.isNotEmpty) {
      _points.addAll(
        _getJourneyPointsFromPref(places),
      );
      _setIndices();
      notifyListeners();
    }
  }

  bool get planUploaded => _isPlanUploaded;

  List<JourneyPoint?> get journeyPoints => _points;

  List<dynamic> get fetchedPlan => _fetchedPlan;

  JourneyPoint? _findByPlaceName(String placeName) {
    final point = _points.firstWhere(
      (journeyPoint) => journeyPoint?.placeName == placeName,
      orElse: () => null,
    );
    return point;
  }

  List<JourneyPoint> _getJourneyPointsFromPref(List<String> jsonJourneyPoints) {
    List<JourneyPoint> journeyPoints = [];

    for (final journeyPoint in jsonJourneyPoints) {
      journeyPoints.add(JourneyPoint.fromJson(journeyPoint));
    }

    return journeyPoints;
  }

  String _getPreferenceKey(JourneyPoint journeyPoint) {
    return '${journeyPoint.placeName.replaceAll(' ', '-')}-${journeyPoint.visitDate}';
  }

  Future<void> addToPlan(JourneyPoint journeyPoint, UserAuth? userAuth) async {
    if (!_points.contains(journeyPoint)) {
      _points.add(journeyPoint);
      await this.backupPlan(_points, userAuth);
      await _saveCurrentPoints();
    }
  }

  Future<void> removeFromPlan(String placeName, UserAuth? userAuth) async {
    final journeyPoint = _findByPlaceName(placeName);

    if (journeyPoint != null) {
      _points.remove(journeyPoint);

      if (!_points.contains(journeyPoint)) {
        await this.backupPlan(journeyPoints, userAuth);
      }
    }
  }

  Future<Map<String, String>?> addAllToPlan(
      List<JourneyPoint> journeyPoints) async {
    if (_points.isNotEmpty) {
      _points.clear();
      await _saveCurrentPoints();
    }

    for (final point in journeyPoints) {
      bool currentPointNotInList = !_points.contains(point);

      if (currentPointNotInList) {
        _points.add(point);
      }
    }

    await _saveCurrentPoints();

    return {
      AppConstants.planResultMsgEn: AppConstants.planUploadedMsgEn,
      AppConstants.planResultMsg: AppConstants.planUploadedMsg,
    };
  }

  Future<Map<String, String>?> backupPlan(
    List<JourneyPoint?> journeyPoints,
    UserAuth? user,
  ) async {
    if (user != null) {
      List<dynamic> planList = [];

      if (journeyPoints.isNotEmpty) {
        for (final point in journeyPoints) {
          if (point != null) {
            final df = DateFormat('dd/MM/yyyy - HH:mm');
            final datehour = df.format(point.visitDate);

            final planPlace = {
              AppConstants.idDataKey: point.id,
              AppConstants.datehourKey: datehour,
              AppConstants.typeKey: point.placeType,
            };

            planList.add(planPlace);
          }
        }

        if (planList.isNotEmpty) {
          await _uploadPlan(planList, user);
        }
      } else {
        await _uploadPlan(planList, user);
      }

      if (_isPlanUploaded) {
        notifyListeners();
        await _saveCurrentPoints();

        return {
          AppConstants.planResultMsg: AppConstants.planUploadedMsg,
          AppConstants.planResultMsgEn: AppConstants.planUploadedMsgEn,
        };
      }
    }

    notifyListeners();
    await _saveCurrentPoints();

    return null;
  }

  bool placeAdded(String placeName) {
    final journeyPoint = _findByPlaceName(placeName);

    if (journeyPoint != null) {
      return _points.contains(journeyPoint);
    }

    return false;
  }

  Future<void> updateJourneyPoint(
    JourneyPoint previous,
    JourneyPoint updated,
    UserAuth? user,
  ) async {
    bool pointExists = _points.contains(previous);

    if (pointExists) {
      _points[_points.indexOf(previous)] = updated;

      if (user != null) {
        await this.backupPlan(journeyPoints, user);
      } else {
        await this.backupPlan(_points, null);
      }
    }
  }

  bool placesAdded() => _points.isNotEmpty;

  Future<void> _saveCurrentPoints() async {
    List<String> pointsToSave = [];

    await _asyncPrefs.setStringList(_journeyPlacesKey, []);

    _points.sort(
      (a, b) => a!.visitDate.compareTo(b!.visitDate),
    );

    for (final point in _points) {
      if (point != null) {
        final df = DateFormat(AppConstants.planDateFormat);

        Map<String, dynamic> map = {
          AppConstants.idDataKey: point.id,
          AppConstants.planPlaceLatKey: point.placeLatitude,
          AppConstants.planPlaceLonKey: point.placeLongitude,
          AppConstants.planPlaceNameKey: point.placeName,
          AppConstants.planPlaceTypeKey: point.placeType,
          AppConstants.planVisitDateKey: df.format(point.visitDate),
        };

        String jsonPoint = jsonEncode(map);

        pointsToSave.add(jsonPoint);
      }
    }

    await _asyncPrefs.setStringList(_journeyPlacesKey, pointsToSave);
    notifyListeners();
  }

  Future<List<JourneyPoint>> fetchUserPlan(UserAuth userAuth) async {
    final url =
        '${AppConstants.myPlanApi}?login=${userAuth.user}&password=${userAuth.pwd}';

    final response = await http.get(
      Uri.parse(url),
    );

    List<dynamic> userPlan = [];
    List<JourneyPoint> apiJourneyPoints = [];

    if (response.statusCode == AppConstants.success) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<dynamic> data = responseBody[AppConstants.dataKey];

      if (data.isNotEmpty) {
        for (final item in data) {
          String planJson = item[AppConstants.planKey];
          userPlan = jsonDecode(planJson);
        }

        if (userPlan.isNotEmpty) {
          apiJourneyPoints = _mapToJourneyPoints(userPlan);
          apiJourneyPoints.sort((a, b) => a.visitDate.compareTo(b.visitDate));
        }
      }
    }

    return apiJourneyPoints;
  }

  List<JourneyPoint> _mapToJourneyPoints(List<dynamic> userPlan) {
    final planMapped = userPlan.map(
      (place) {
        int id = place[AppConstants.idDataKey];
        String datehour = place[AppConstants.datehourKey];
        String type = place[AppConstants.typeKey];
        final dateFormat = DateFormat(AppConstants.planDateFormat);
        final dateTime = dateFormat.parse(datehour);

        return JourneyPoint(
          id: id,
          placeName: '',
          visitDate: dateTime,
          placeType: type,
        );
      },
    );

    final planList = planMapped.toList();
    _setJourneyPointsIndices(planList);

    return planList;
  }

  void _setIndices() {
    if (_points.isNotEmpty) {
      for (int i = 0; i < _points.length; i++) {
        if (_points[i] != null) {
          _points[i]!.placeIndex = i + 1;
        }
      }
    }
  }

  void _setJourneyPointsIndices(List<JourneyPoint> plan) {
    if (plan.isNotEmpty) {
      for (int i = 0; i < plan.length; i++) {
        plan[i].placeIndex = i + 1;
      }
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están permanentemente denegados.');
    }

    // Obtener la ubicación actual
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> _uploadPlan(List<dynamic> planList, UserAuth user) async {
    String jsonPlan = jsonEncode(planList);

    Map<String, dynamic> request = {
      AppConstants.planKey: jsonPlan,
      AppConstants.loginKey: user.user,
      AppConstants.pwdKey: user.pwd,
    };

    String jsonRequest = jsonEncode(request);

    final response = await http.post(
      Uri.parse(AppConstants.myPlanApi),
      headers: AppConstants.requestHeaders,
      body: jsonRequest,
    );

    if (response.statusCode == AppConstants.created) {
      _isPlanUploaded = true;
    }
  }

  Future<void> clearUserPlan() async {
    await _asyncPrefs.setStringList(_journeyPlacesKey, []);
    notifyListeners();
  }
}
