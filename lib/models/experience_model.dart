import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/experience_categories_data.dart';
import 'package:valdeiglesias/dtos/experience_item.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class ExperienceModel extends AppModel with ChangeNotifier {
  ExperienceModel() {
    _getData();
  }

  List<ExperienceItem> _experiences = [];
  List<PlaceCategory> _categories = [];

  ExperienceCategoriesData? _screenData;

  bool _dataFetched = false;

  List<ExperienceItem> get items => _experiences;

  List<PlaceCategory> get categories => _categories;

  ExperienceCategoriesData? get screenData => _screenData;

  bool get hasData => _dataFetched;

  void _getData() async {
    final response = await http.get(Uri.parse(AppConstants.experiences));
    final responseEn = await http.get(Uri.parse(AppConstants.experiencesEn));

    final categoriesResponse = await http.get(
      Uri.parse(AppConstants.experienceCategories),
    );

    final categoriesEnResponse = await http.get(
      Uri.parse(AppConstants.experienceCategoriesEn),
    );

    Set<PlaceCategory> placeCategories = {};
    Set<PlaceCategory> placeCategoriesEn = {};
    List<dynamic> places = [];
    List<dynamic> placesEn = [];
    List<dynamic> categories = [];
    List<dynamic> categoriesEn = [];

    if (response.statusCode == AppConstants.success) {
      places = jsonDecode(response.body);
    }

    if (responseEn.statusCode == AppConstants.success) {
      placesEn = jsonDecode(responseEn.body);
    }

    if (categoriesResponse.statusCode == AppConstants.success) {
      categories = jsonDecode(categoriesResponse.body);
    }

    if (categoriesEnResponse.statusCode == AppConstants.success) {
      categoriesEn = jsonDecode(categoriesEnResponse.body);
    }

    if (places.isNotEmpty) {
      for (var place in places) {
        int categoryId = _getCategoryId(
          place[AppConstants.experienceCategory] ?? [],
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
              .where((category) => category.name == filteredCategory.name)
              .isEmpty;

          if (categoryNotPresent) {
            placeCategories.add(filteredCategory);
          }
        }

        if (filteredCategoryEn != null) {
          bool categoryNotPresent = placeCategories
              .where((category) => category.name == filteredCategoryEn.name)
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

    _experiences = _getPlaces(places);

    _screenData = ExperienceCategoriesData(
      categories: orderedCategories,
      categoriesEn: orderedCategoriesEn,
      places: _getPlaces(places),
      placesEn: _getPlaces(placesEn),
    );

    _dataFetched = true;

    notifyListeners();
  }

  Future<ExperienceCategoriesData> fetchData() async {
    final response = await http.get(Uri.parse(AppConstants.experiences));
    final responseEn = await http.get(Uri.parse(AppConstants.experiencesEn));

    final categoriesResponse = await http.get(
      Uri.parse(AppConstants.experienceCategories),
    );

    final categoriesEnResponse = await http.get(
      Uri.parse(AppConstants.experienceCategoriesEn),
    );

    Set<PlaceCategory> placeCategories = {};
    Set<PlaceCategory> placeCategoriesEn = {};
    List<dynamic> places = [];
    List<dynamic> placesEn = [];
    List<dynamic> categories = [];
    List<dynamic> categoriesEn = [];

    if (response.statusCode == AppConstants.success) {
      places = jsonDecode(response.body);
    }

    if (responseEn.statusCode == AppConstants.success) {
      placesEn = jsonDecode(responseEn.body);
    }

    if (categoriesResponse.statusCode == AppConstants.success) {
      categories = jsonDecode(categoriesResponse.body);
    }

    if (categoriesEnResponse.statusCode == AppConstants.success) {
      categoriesEn = jsonDecode(categoriesEnResponse.body);
    }

    if (places.isNotEmpty) {
      for (var place in places) {
        int categoryId = _getCategoryId(
          place[AppConstants.experienceCategory] ?? [],
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
              .where((category) => category.name == filteredCategory.name)
              .isEmpty;

          if (categoryNotPresent) {
            placeCategories.add(filteredCategory);
          }
        }

        if (filteredCategoryEn != null) {
          bool categoryNotPresent = placeCategories
              .where((category) => category.name == filteredCategoryEn.name)
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

    _experiences = _getPlaces(places);
    notifyListeners();

    return ExperienceCategoriesData(
      categories: orderedCategories,
      categoriesEn: orderedCategoriesEn,
      places: _getPlaces(places),
      placesEn: _getPlaces(placesEn),
    );
  }

  /// Maps the places data to a `List<Place>`
  List<ExperienceItem> _getPlaces(List<dynamic> places) {
    List<ExperienceItem> mappedPlaces = [];

    for (var item in places) {
      mappedPlaces.add(
        getPlace(item) as ExperienceItem,
      );
    }

    return mappedPlaces;
  }

  int _getCategoryId(List<dynamic> place) {
    return place.first[AppConstants.targetIdKey];
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

  String _getUrl(dynamic item) {
    final url =
        item[AppConstants.experienceMainImage].first[AppConstants.urlKey];

    return (url != null && url != '') ? url : AppConstants.valueNotAvailable;
  }

  String _getPhoneNumber(dynamic item) {
    List<dynamic> phoneNumberList = item[AppConstants.experiencePhoneNumber];
    String phoneNumber = '';

    if (phoneNumberList.isNotEmpty) {
      phoneNumber = phoneNumberList.first[AppConstants.valueKey].toString();
    }

    return (phoneNumber != '') ? phoneNumber : AppConstants.valueNotAvailable;
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map(
        (place) {
          return InterestPlace(
            latitude: place[AppConstants.experienceLocation]
                .first[AppConstants.placeLatitude],
            longitude: place[AppConstants.experienceLocation]
                .first[AppConstants.placeLongitude],
            name: place[AppConstants.titleKey].first[AppConstants.valueKey],
            nameEn: place[AppConstants.titleKey].first[AppConstants.valueKey],
            imageUrl: _getUrl(place),
            description:
                ContentValidator.value(place[AppConstants.experienceShortDesc]),
            descriptionEn:
                ContentValidator.value(place[AppConstants.experienceShortDesc]),
            placeForDetail: getPlace(place),
          );
        },
      ).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(dynamic place) {
    return ExperienceItem(
      mainImageUrl: _getUrl(place),
      placeId: place[AppConstants.nIdKey].first[AppConstants.valueKey],
      placeName: ContentValidator.value(place[AppConstants.titleKey]),
      placeNameEn: ContentValidator.value(place[AppConstants.titleKey]),
      shortDescription:
          ContentValidator.value(place[AppConstants.experienceShortDesc]),
      longDescription:
          ContentValidator.value(place[AppConstants.experienceLongDesc]),
      latitude: place[AppConstants.experienceLocation]
          .first[AppConstants.placeLatitude],
      longitude: place[AppConstants.experienceLocation]
          .first[AppConstants.placeLongitude],
      phoneNumber: _getPhoneNumber(place),
      websiteUrl: ContentValidator.value(
        place[AppConstants.experienceWebsiteUrl],
      ),
      address: ContentValidator.value(
        place[AppConstants.experienceAddress],
      ),
      imageUrls: ContentValidator.imageUrls(
        place[AppConstants.experienceGallery] ?? [],
      ),
      categoryId: _getCategoryId(
        place[AppConstants.experienceCategory] ?? [],
      ),
      placeType: AppConstants.experienceApiType,
      placeTypeEn: AppConstants.experienceApiType,
      videoUrl: ContentValidator.videoUrl(place[AppConstants.experienceVideo]),
    );
  }
}
