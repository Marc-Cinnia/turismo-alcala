import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/incident_reason.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';

class IncidentModel extends ChangeNotifier {
  IncidentModel() {
    _fetchIncidentReasons();
  }

  List<IncidentReason> _incidentReasons = [];
  int? _selectedReasonId;
  String? _incidentName;
  String? _incidentDescription;
  String? _incidentImg;
  Position? _position;
  LatLng? _initialCentral;
  LatLng? _userPosition;
  Map<String, String> _result = {};
  List<Marker> _markers = [];
  bool _fetchingData = true;
  bool _reportSent = false;
  bool _userPositionAdded = false;

  List<IncidentReason> get reasons => _incidentReasons;
  int? get selectedReason => _selectedReasonId;
  String? get image => _incidentImg;
  Map<String, String> get result => _result;
  Position? get position => _position;
  LatLng get initialCentral =>
      _initialCentral ?? AppConstants.smvCentralLocation;
  LatLng? get userPosition => _userPosition;
  List<Marker> get markers => _markers;
  bool get fetchingData => _fetchingData;
  bool get reportSent => _reportSent;
  bool get userPositionAdded => _userPositionAdded;

  void set userPositionAdded(bool userPositionAdded) {
    _userPositionAdded = userPositionAdded;
    notifyListeners();
  }

  void set userPosition(LatLng? position) {
    if (position != null) {
      _userPosition = position;
    }
  }

  void _fetchIncidentReasons() async {
    final response = await http.get(
      Uri.parse(AppConstants.incidentReasons),
    );

    if (response.statusCode == AppConstants.success) {
      final responseBody = jsonDecode(response.body);      

      _setReasons(responseBody[AppConstants.dataKey]);
      _fetchingData = false;
      _initialCentral = AppConstants.smvCentralLocation;
      notifyListeners();
    }
  }

  void _setReasons(Map<String, dynamic> reasons) {
    reasons.forEach(
      (key, reason) {
        final incidentReason = IncidentReason(
          id: reason[AppConstants.idDataKey],
          name: reason[AppConstants.nameEs],
          nameEn: reason[AppConstants.nameEn],
        );

        if (!_incidentReasons.contains(incidentReason)) {
          _incidentReasons.add(incidentReason);
        }
      },
    );
  }

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

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

    final currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    _userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    return _userPosition;
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void setName(String incidentName) {
    _incidentName = incidentName;
  }

  void selectReason(int? reasonId) {
    if (reasonId != null) {
      _selectedReasonId = reasonId;
    }
  }

  void setImage(String base64Image) {
    _incidentImg = base64Image;
  }

  void setPosition(Position currentPosition) {
    _position = currentPosition;
  }

  void setDescription(String description) {
    _incidentDescription = description;
  }

  Future<void> sendIssueReport(
    UserAuth? auth,
  ) async {
    if (auth != null && _userPosition != null) {
      final incidentBody = {
        'name': _incidentName,
        'description': _incidentDescription,
        'date_hour': DateFormat(AppConstants.dateFormat).format(DateTime.now()),
        'state': 0,
        'id_reason': _selectedReasonId,
        'lat': _userPosition!.latitude,
        'lon': _userPosition!.longitude,
        'photo': _incidentImg,
        'login': auth.user,
        'password': auth.pwd,
      };

      final request = jsonEncode(incidentBody);

      final response = await http.post(
        Uri.parse(AppConstants.incident),
        headers: AppConstants.requestHeaders,
        body: request,
      );

      if (response.statusCode == AppConstants.created) {
        _result = {
          'message': AppConstants.incidentSendedLabel,
          'messageEn': AppConstants.incidentSendedLabelEn
        };
        _reportSent = true;
        notifyListeners();
      }
    }
  }

  void clear() {
    _selectedReasonId = null;
    _incidentImg = null;
    _incidentDescription = null;
    notifyListeners();
  }
}
