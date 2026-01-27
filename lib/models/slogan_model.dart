import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';

class SloganModel extends ChangeNotifier {
  SloganModel() {
    _setSlogan();
  }

  String _slogan = '';
  String _sloganEn = '';

  String get value => _slogan;
  String get valueEn => _sloganEn;

  void _setSlogan() async {
    final response = await http.get(Uri.parse(AppConstants.slogan));
    final responseEn = await http.get(Uri.parse(AppConstants.sloganEn));

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        _slogan = item['field_personalization_eslogan'].first['value'];
      }
    }

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(responseEn.body);

      for (var item in body) {
        _sloganEn = item['field_personalization_eslogan'].first['value'];
      }
    }

    if (_slogan.isNotEmpty && _sloganEn.isNotEmpty) {
      notifyListeners();
    }
  }
}
