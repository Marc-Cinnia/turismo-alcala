import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

import 'package:valdeiglesias/dtos/user_auth.dart';

class SessionModel extends ChangeNotifier {
  SessionModel() {
    _getUserLoggedPreference();
  }

  final asyncPrefs = SharedPreferencesAsync();
  bool _active = false;
  UserAuth? _userLoggedIn;

  bool get isActive => _active;
  UserAuth? get credentials => _userLoggedIn;

  void _getUserLoggedPreference() async {
    final data = await asyncPrefs.getString(AppConstants.userDataKey);

    if (data != null) {
      Map<String, dynamic> userData = jsonDecode(data);
      _userLoggedIn = UserAuth(
        user: userData[AppConstants.userKey],
        pwd: userData[AppConstants.passwordLoginKey],
        userId: userData[AppConstants.userIdLoginKey],
      );
      _active = _userLoggedIn != null;
    }
  }

  Future<void> loginUser(UserAuth auth) async {
    final response = await http.post(
      Uri.parse(AppConstants.login),
      body: {
        AppConstants.loginKey: auth.user,
        AppConstants.pwdKey: auth.pwd,
      },
    );

    if (response.statusCode == AppConstants.success) {
      final responseBody = jsonDecode(response.body);
      _active = true;

      final authData = responseBody['success'];

      if (authData != null) {
        _userLoggedIn = UserAuth(
          user: authData[AppConstants.loginKey],
          userId: authData[AppConstants.userIdKey].toString(),
          pwd: authData[AppConstants.passwordKey],
        );

        Map<String, dynamic> userData = {
          'user': _userLoggedIn!.user,
          'userId': _userLoggedIn!.userId,
          'pwd': _userLoggedIn!.pwd,
        };

        asyncPrefs.setString(AppConstants.userDataKey, jsonEncode(userData));
        _active = _userLoggedIn != null;
        notifyListeners();
      }
    }
  }

  void logoutUser() {
    _active = false;
    asyncPrefs.remove(AppConstants.userDataKey);
    notifyListeners();
  }
}
