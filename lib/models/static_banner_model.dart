import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/static_banner.dart';

class StaticBannerModel extends ChangeNotifier {
  StaticBannerModel() {
    _fetchBannerData();
  }

  List<StaticBanner> bannerItems = [];
  StaticBanner? bannerToShow;

  void _fetchBannerData() async {
    final response = await http.get(Uri.parse(AppConstants.staticBannerEs));

    if (response.statusCode == AppConstants.success) {
      final List<dynamic> body = jsonDecode(response.body);

      for (final item in body) {
        final List<dynamic> expList = item[AppConstants.bannerExpirationDate];
        final List<dynamic> navLinkList = item[AppConstants.bannerNavLinkKey];
        final List<dynamic> imgList = item[AppConstants.staticBannerDesktopUrl];

        final String imageUrl = imgList.first[AppConstants.urlKey];
        final String expirationFormatted = expList.first[AppConstants.valueKey];
        final String linkToNav = navLinkList.first[AppConstants.valueKey];

        final currentDate = DateTime.now();
        final dateFormat = DateFormat(AppConstants.basicDateFormat);
        final expirationDate = dateFormat.parse(expirationFormatted);

        if (expirationDate.isAfter(currentDate)) {
          bannerItems.add(
            StaticBanner(
              imageUrl: imageUrl,
              navigationUrl: linkToNav,
              expirationDate: expirationDate,
            ),
          );
        }
      }

      if (bannerItems.isNotEmpty) {
        final randomIndex = Random().nextInt(bannerItems.length);
        bannerToShow = bannerItems[randomIndex];
        notifyListeners();
      }
    }
  }
}
