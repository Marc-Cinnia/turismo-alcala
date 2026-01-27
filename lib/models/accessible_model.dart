import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class AccessibleModel extends ChangeNotifier {
  AccessibleModel() {
    _readPreference();
  }

  final asyncPrefs = SharedPreferencesAsync();

  bool _accessibleEnabled = false;
  bool _preferenceAssigned = false;

  bool get enabled => _accessibleEnabled;
  bool get preferenceAssigned => _preferenceAssigned;

  void set enabled(bool enabled) {
    _accessibleEnabled = enabled;
    notifyListeners();
  }

  void _readPreference() async {
    final preference = await asyncPrefs.getBool(AppConstants.accessibleKey);

    if (preference != null) {
      _preferenceAssigned = true;
      _accessibleEnabled = preference;
      notifyListeners();
    }
  }

  void setPreference(bool value) {
    if (value != _accessibleEnabled) {
      asyncPrefs.setBool(AppConstants.accessibleKey, value).then(
        (_) {
          _accessibleEnabled = value;
          Restart.restartApp();
        },
      );
    }
  }
}
