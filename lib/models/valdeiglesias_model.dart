import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/valdeiglesias_content.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class ValdeiglesiasModel extends ChangeNotifier {
  ValdeiglesiasModel() {
    _fetchData();
  }

  ValdeiglesiasContent? _content = null;
  ValdeiglesiasContent? _contentEn = null;

  ValdeiglesiasContent? get content => _content;
  ValdeiglesiasContent? get contentEn => _contentEn;

  /// Fetch `ValdeiglesiasModel` data from network
  void _fetchData() async {
    final response = await http.get(Uri.parse(AppConstants.smdv));
    final responseEn = await http.get(Uri.parse(AppConstants.smdvEn));

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        _content = ValdeiglesiasContent(
          title: ContentValidator.value(item[AppConstants.titleKey]),
          mainImageUrl: _url(item[AppConstants.valdeiglesiasMainImage]),
          paragraphTitle1:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle1]),
          paragraph1: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph1]),
          paragraphTitle2:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle2]),
          paragraph2: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph2]),
          paragraphTitle3:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle3]),
          paragraph3: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph3]),
          paragraphTitle4:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle4]),
          paragraph4: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph4]),
          imageUrls: _urlList(item[AppConstants.valdeiglesiasGallery]),
        );
      }
    }

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(responseEn.body);

      for (var item in body) {
        _contentEn = ValdeiglesiasContent(
          title: ContentValidator.value(item[AppConstants.titleKey]),
          mainImageUrl: _url(item[AppConstants.valdeiglesiasMainImage]),
          paragraphTitle1:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle1]),
          paragraph1: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph1]),
          paragraphTitle2:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle2]),
          paragraph2: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph2]),
          paragraphTitle3:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle3]),
          paragraph3: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph3]),
          paragraphTitle4:
              ContentValidator.value(item[AppConstants.valdeiglesiasTitle4]),
          paragraph4: ContentValidator.value(
              item[AppConstants.valdeiglesiasParagraph4]),
          imageUrls: _urlList(item[AppConstants.valdeiglesiasGallery]),
        );
      }
    }

    if (_content != null && _contentEn != null) {
      notifyListeners();
    }
  }

  String _url(List<dynamic> item) {
    String url = '';

    if (item.isNotEmpty) {
      url = item.first[AppConstants.urlKey];
    }

    return url;
  }

  List<String> _urlList(List<dynamic> item) {
    List<String> urls = [];

    if (item.isNotEmpty) {
      for (var url in item) {
        urls.add(url[AppConstants.urlKey]);
      }
    }

    return urls;
  }
}
