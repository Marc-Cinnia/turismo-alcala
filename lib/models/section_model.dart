import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/section.dart';

class SectionModel extends ChangeNotifier {
  SectionModel() {
    _getSections();
  }

  final List<Section> _items = [];
  final List<Section> _itemsEn = [];

  List<Section> get items => _items;
  List<Section> get itemsEn => _itemsEn;

  /// Fetch the `List` of `CardItem`s from service layer
  void _getSections() async {
    const String imageKey = 'field_section_image';
    final response = await http.get(Uri.parse(AppConstants.sections));
    final responseEn = await http.get(Uri.parse(AppConstants.sectionsEn));

    print('=== SECTION MODEL DEBUG ===');
    print('Sections API response status: ${response.statusCode}');

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);
      print('Sections from API: ${body.length}');

      for (var item in body) {
        final routeName =
            item[AppConstants.sectionRoute].first[AppConstants.valueKey];
        final label = item[AppConstants.titleKey].first[AppConstants.valueKey];

        print('Section found: $label - routeName: $routeName');

        final sectionItem = Section(
          label: label,
          backgroundImage: NetworkImage(
            item[imageKey].first[AppConstants.urlKey],
          ),
          routeName: routeName,
        );
        _items.add(sectionItem);
      }
      print('Total sections loaded: ${_items.length}');
    }
    print('==========================');

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(responseEn.body);

      for (var item in body) {
        final sectionItem = Section(
          label: item[AppConstants.titleKey].first[AppConstants.valueKey],
          backgroundImage: NetworkImage(
            item[imageKey].first[AppConstants.urlKey],
          ),
          routeName:
              item[AppConstants.sectionRoute].first[AppConstants.valueKey],
        );
        _itemsEn.add(sectionItem);
      }
    }

    if (_items.isNotEmpty && _itemsEn.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<List<Section>> fetchSections() async {
    const String imageKey = 'field_section_image';
    final response = await http.get(Uri.parse(AppConstants.sections));
    List<Section> mappedSections = [];

    if (response.statusCode == AppConstants.success) {
      List<dynamic> sections = jsonDecode(response.body);

      for (var section in sections) {
        final sectionRoute =
            section[AppConstants.sectionRoute].first[AppConstants.valueKey];

        final sectionItem = Section(
          label: section[AppConstants.titleKey].first[AppConstants.valueKey],
          backgroundImage: NetworkImage(
            section[imageKey].first[AppConstants.urlKey],
          ),
          routeName: sectionRoute,
        );
        mappedSections.add(sectionItem);
      }
    }

    return mappedSections;
  }
}
