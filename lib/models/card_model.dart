import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/card_item.dart';

class CardModel extends ChangeNotifier {
  CardModel() {
    _getCardsData();
  }

  final List<CardItem> _items = [];
  final List<CardItem> _itemsEn = [];

  List<CardItem> get items => _items;
  List<CardItem> get itemsEn => _itemsEn;

  /// Fetch the `List` of `CardItem`s from service layer
  void _getCardsData() async {
    const String imageKey = 'field_featured_image';

    final response = await http.get(
      Uri.parse(AppConstants.banner),
    );
    final responseEn = await http.get(
      Uri.parse(AppConstants.bannerEn),
    );

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (final item in body) {
        if (_itemIsActive(item)) {
          List<dynamic> itemUrl = item[AppConstants.bannerLinkKey];
          String relatedUrl = '';

          if (itemUrl.isNotEmpty) {
            relatedUrl = itemUrl.first[AppConstants.valueKey];
          }

          CardItem cardItem = CardItem(
            title: item[AppConstants.titleKey].first[AppConstants.valueKey],
            subtitle:
                item[AppConstants.subtitleKey].first[AppConstants.valueKey],
            imageUrl: item[imageKey].first[AppConstants.urlKey],
            relatedUrl: relatedUrl,
          );
          _items.add(cardItem);
        }
      }
    }

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> bodyEn = jsonDecode(responseEn.body);
      
      for (var item in bodyEn) {
        if (_itemIsActive(item)) {
          List<dynamic> itemUrl = item[AppConstants.bannerLinkKey];
          String relatedUrl = '';

          if (itemUrl.isNotEmpty) {
            relatedUrl = itemUrl.first[AppConstants.valueKey];
          }

          CardItem cardItem = CardItem(
            title: item[AppConstants.titleKey].first[AppConstants.valueKey],
            subtitle:
                item[AppConstants.subtitleKey].first[AppConstants.valueKey],
            imageUrl: item[imageKey].first[AppConstants.urlKey],
            relatedUrl: relatedUrl,
          );
          _itemsEn.add(cardItem);
        }
      }
    }

    if (_items.isNotEmpty && _itemsEn.isNotEmpty) {
      notifyListeners();
    }
  }

  bool _itemIsActive(dynamic item) {
    final expirationData = item[AppConstants.expirationKey];
    final now = DateTime.now();
    final expiration = expirationData.first[AppConstants.valueKey];
    final expDateTime = DateTime.parse(expiration);
    return expDateTime.isAfter(now);
  }
}
