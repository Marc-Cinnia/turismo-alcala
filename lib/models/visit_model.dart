import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/places_categories.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class VisitModel extends AppModel with ChangeNotifier {
  VisitModel({this.english}) {
    print('VisitModel initialized, starting data load...');
    _setData(english ?? false);
  }

  final bool? english;
  final List<Place> _places = [];
  PlacesCategories? _placesCategories;

  List<Place> get placesToVisit => _places;
  PlacesCategories? get placesCategories => _placesCategories;

  /// Maps the places data to a `List<Place>`
  List<Place> _getPlaces(List<dynamic> places) {
    print('_getPlaces called with ${places.length} items');
    List<Place> mappedPlaces = [];

    for (var item in places) {
      try {
        final place = getPlace(item);
        mappedPlaces.add(place);
        print('Successfully mapped place: ${place.placeName}');
      } catch (e) {
        print('Error mapping place: $e');
        print('Item data: $item');
      }
    }

    print('_getPlaces returning ${mappedPlaces.length} mapped places');
    return mappedPlaces;
  }

  int _getCategoryId(List<dynamic> place) {
    return place.first[AppConstants.targetIdKey];
  }

  void _setData(bool english) async {
    print('=== VISIT MODEL _setData STARTED ===');
    print('Making request to: ${AppConstants.places}');

    final response = await http.get(Uri.parse(AppConstants.places));
    final responseEn = await http.get(Uri.parse(AppConstants.placesEn));

    print('Response status: ${response.statusCode}');
    print('Response body length: ${response.body.length}');

    final categoriesResponse = await http.get(
      Uri.parse(AppConstants.categories),
    );
    final enCategoriesResponse = await http.get(
      Uri.parse(AppConstants.categoriesEn),
    );

    Set<PlaceCategory> placeCategories = {};
    Set<PlaceCategory> placeCategoriesEn = {};
    List<dynamic> places = [];
    List<dynamic> placesEn = [];
    List<dynamic> categories = [];
    List<dynamic> categoriesEn = [];

    if (response.statusCode == AppConstants.success) {
      try {
        places = jsonDecode(response.body);
        print('Successfully decoded ${places.length} places from API');
      } catch (e) {
        print('Error decoding places JSON: $e');
        print('Response body: ${response.body.substring(0, 200)}...');
      }
    } else {
      print('Places API failed with status: ${response.statusCode}');
      print('Error body: ${response.body}');
    }

    if (responseEn.statusCode == AppConstants.success) {
      try {
        placesEn = jsonDecode(responseEn.body);
        print('Successfully decoded ${placesEn.length} places EN from API');
      } catch (e) {
        print('Error decoding places EN JSON: $e');
      }
    } else {
      print('Places EN API failed with status: ${responseEn.statusCode}');
    }

    if (categoriesResponse.statusCode == AppConstants.success) {
      try {
        categories = jsonDecode(categoriesResponse.body);
        print('Successfully decoded ${categories.length} categories from API');
      } catch (e) {
        print('Error decoding categories JSON: $e');
      }
    } else {
      print(
          'Categories API failed with status: ${categoriesResponse.statusCode}');
    }

    if (enCategoriesResponse.statusCode == AppConstants.success) {
      try {
        categoriesEn = jsonDecode(enCategoriesResponse.body);
        print(
            'Successfully decoded ${categoriesEn.length} categories EN from API');
      } catch (e) {
        print('Error decoding categories EN JSON: $e');
      }
    } else {
      print(
          'Categories EN API failed with status: ${enCategoriesResponse.statusCode}');
    }

    if (places.isNotEmpty) {
      for (var place in places) {
        int categoryId = _getCategoryId(
          place[AppConstants.placeCategory] ?? [],
        );

        PlaceCategory? filteredCategory = _filterCategory(
          categoryId,
          categories,
        );

        PlaceCategory? filteredCategoryEn = _filterCategory(
          categoryId,
          categoriesEn,
        );

        if (filteredCategory != null) {
          bool categoryNotPresent = placeCategories
              .where(
                (category) => category == filteredCategory,
              ) // category.name == filteredCategory.name)
              .isEmpty;

          if (categoryNotPresent) {
            placeCategories.add(filteredCategory);
          }
        }

        if (filteredCategoryEn != null) {
          bool categoryNotPresent = placeCategories
              .where(
                (category) => category == filteredCategoryEn,
              )
              .isEmpty;

          if (categoryNotPresent) {
            placeCategoriesEn.add(filteredCategoryEn);
          }
        }
      }
    }

    final orderedCategories = ContentBuilder.getOrderedCategories(
      placeCategories,
      AppConstants.categoryAll,
    );

    final orderedCategoriesEn = ContentBuilder.getOrderedCategories(
        placeCategoriesEn, AppConstants.categoryAllEn);

    _placesCategories = PlacesCategories(
      categories: orderedCategories,
      categoriesEn: orderedCategoriesEn,
      places: _getPlaces(places),
      placesEn: _getPlaces(placesEn),
    );

    print('=== VISIT MODEL DEBUG ===');
    print('Places from API: ${places.length}');
    print('Mapped places: ${_getPlaces(places).length}');

    if (_places.isEmpty) {
      final mappedPlaces = _getPlaces(places);
      print('About to add ${mappedPlaces.length} places to _places');
      _places.addAll(mappedPlaces);
      print('Places added to _places: ${_places.length}');
      print(
          'Sample place: ${_places.isNotEmpty ? _places.first.placeName : "None"}');
      notifyListeners();
    } else {
      print('Places already loaded: ${_places.length}');
    }
    print('========================');
  }

  PlaceCategory? _filterCategory(int categoryId, List<dynamic> categories) {
    PlaceCategory? category = null;

    if (categories.isNotEmpty) {
      final filteredCategory = categories.firstWhere(
        (category) {
          return category[AppConstants.idKey]?.first[AppConstants.valueKey] ==
              categoryId;
        },
        orElse: () => null,
      );

      if (filteredCategory != null) {
        category = _getCategory(filteredCategory);
      }
    }

    return category;
  }

  PlaceCategory _getCategory(dynamic category) {
    var placeCategory = PlaceCategory(
      id: category[AppConstants.idKey]?.first[AppConstants.valueKey],
      name: category[AppConstants.nameKey]?.first[AppConstants.valueKey],
    );
    return placeCategory;
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    for (final item in places) {
      mappedPlaces.add(
        InterestPlace(
          latitude: item[AppConstants.placeLocation]
              .first[AppConstants.placeLatitude],
          longitude: item[AppConstants.placeLocation]
              .first[AppConstants.placeLongitude],
          name: item[AppConstants.titleKey].first[AppConstants.valueKey],
          nameEn: item[AppConstants.titleKey].first[AppConstants.valueKey],
          imageUrl:
              item[AppConstants.placeMainImage].first[AppConstants.urlKey],
          description: ContentValidator.value(
            item[AppConstants.placeShortDescription] ?? [],
          ),
          descriptionEn: ContentValidator.value(
            item[AppConstants.placeShortDescription] ?? [],
          ),
          placeForDetail: getPlace(item),
        ),
      );
    }

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    return Place(
      mainImageUrl:
          place[AppConstants.placeMainImage].first[AppConstants.urlKey],
      placeId: place[AppConstants.nIdKey].first[AppConstants.valueKey],
      placeName: place[AppConstants.titleKey].first[AppConstants.valueKey],
      placeNameEn: place[AppConstants.titleKey].first[AppConstants.valueKey],
      subtitle: ContentValidator.value(
        place[AppConstants.placeSubtitle] ?? [],
      ),
      shortDescription: ContentValidator.value(
        place[AppConstants.placeShortDescription] ?? [],
      ),
      longDescription: ContentValidator.value(
        place[AppConstants.placeLongDescription] ?? [],
      ),
      phoneNumber: ContentValidator.value(
        place[AppConstants.placePhoneNumber] ?? [],
      ),
      websiteUrl: ContentValidator.value(
        place[AppConstants.placeWebsite] ?? [],
      ),
      address: ContentValidator.value(
        place[AppConstants.placeAddress] ?? [],
      ),
      latitude:
          place[AppConstants.placeLocation].first[AppConstants.placeLatitude],
      longitude:
          place[AppConstants.placeLocation].first[AppConstants.placeLongitude],
      imageUrls: ContentValidator.imageUrls(
        place[AppConstants.placeGallery],
      ),
      videoUrl: ContentValidator.videoUrl(
        place[AppConstants.placeVideo],
      ),
      categoryId: _getCategoryId(place[AppConstants.placeCategory] ?? []),
      placeType: AppConstants.placeApiType,
      placeTypeEn: AppConstants.placeApiType,
    );
  }
}
