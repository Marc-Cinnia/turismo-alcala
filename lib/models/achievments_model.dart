import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class AchievmentsModel extends ChangeNotifier {
  AchievmentsModel() {
    _fetchSavedBeacons();
  }

  int _detectedBeacons = 0;

  int get detectedBeacons => _detectedBeacons;

  void set detectedBeacons(int detectedBeacons) {
    _detectedBeacons = detectedBeacons;
    notifyListeners();
  }

  void _fetchSavedBeacons() async {
    final prefs = await SharedPreferences.getInstance();
    final beacons = prefs.getString(AppConstants.beaconsRegisteredKey);

    if (beacons != null && beacons.isNotEmpty) {
      print('beacons saved: $beacons');
    }
  }
}
