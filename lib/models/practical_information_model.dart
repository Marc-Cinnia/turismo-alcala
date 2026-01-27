import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/info.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class PracticalInformationModel extends ChangeNotifier {
  PracticalInformationModel() {
    _fetchData();
  }

  Info? _info = null;

  Info? get info => _info;
  bool get hasData => _info != null;

  List<String> galleryImages = [];

  void _fetchData() async {
    final response = await http.get(Uri.parse(AppConstants.practicalInfo));
    final responseEn = await http.get(Uri.parse(AppConstants.practicalInfoEn));
    List<dynamic> body = [];
    List<dynamic> bodyEn = [];

    if (response.statusCode == AppConstants.success) {
      body = jsonDecode(response.body);
    }

    if (responseEn.statusCode == AppConstants.success) {
      bodyEn = jsonDecode(responseEn.body);
    }

    if (body.isNotEmpty && bodyEn.isNotEmpty) {
      Map<String, dynamic> content = body.first;
      Map<String, dynamic> contentEn = bodyEn.first;

      _info = Info(
        title: content[AppConstants.titleKey].first[AppConstants.valueKey],
        titleEn: contentEn[AppConstants.titleKey].first[AppConstants.valueKey],
        imageUrl: ContentValidator.url(
          content[AppConstants.informationMainImage],
        ),
        description: content[AppConstants.informationDescription]
            .first[AppConstants.valueKey],
        descriptionEn: contentEn[AppConstants.informationDescription]
            .first[AppConstants.valueKey],
        subtitle1: content[AppConstants.informationTitle1]
            .first[AppConstants.valueKey],
        subtitle1En: contentEn[AppConstants.informationTitle1]
            .first[AppConstants.valueKey],
        galleryImages: ContentValidator.imageUrls(
          content[AppConstants.informationGallery],
        ),
      );

      notifyListeners();
    }
  }
}
