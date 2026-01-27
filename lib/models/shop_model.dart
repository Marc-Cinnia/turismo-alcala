import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/store.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

/// Model class for managing state for stores
/// or places where users can make shopping
class ShopModel extends AppModel with ChangeNotifier {
  ShopModel() {
    _fetchData();
  }

  final List<Store> _stores = [];

  Set<PlaceCategory> _categories = {};
  Set<PlaceCategory> _categoriesEn = {};
  List<Store> _filteredStores = [];

  List<Store> get placesToShop => _stores;
  Set<PlaceCategory> get categories => _categories;
  Set<PlaceCategory> get categoriesEn => _categoriesEn;

  bool get hasData =>
      _stores.isNotEmpty && _categories.isNotEmpty && _categoriesEn.isNotEmpty;

  void _setCategory(dynamic item) {
    if (item[AppConstants.categoryKey] != null) {
      _categories.add(ContentValidator.professionalPlaceCategory(
        item,
        AppConstants.categoryKey,
        AppConstants.nameEs,
      )!);

      _categoriesEn.add(ContentValidator.professionalPlaceCategory(
        item,
        AppConstants.categoryKey,
        AppConstants.nameEn,
      )!);
    }
  }

  /// Fetch the data for store items available
  /// in backend
  void _fetchData() async {
    final response = await http.get(Uri.parse(AppConstants.whereToShop));

    if (response.statusCode == AppConstants.success) {
      dynamic body = jsonDecode(response.body);
      List<dynamic> shopItems = body[AppConstants.dataKey] ?? [];

      if (shopItems.isNotEmpty) {
        for (var item in shopItems) {
          _setCategory(item);

          _stores.add(getPlace(item) as Store);
        }

        _categories = ContentBuilder.getProfessionalOrderedCategories(
          categories,
          AppConstants.categoryAll,
        );

        _categoriesEn = ContentBuilder.getProfessionalOrderedCategories(
          categoriesEn,
          AppConstants.categoryAllEn,
        );
      }
    }

    notifyListeners();
  }

  void filterByCategory(int categoryId) {
    if (_stores.isNotEmpty) {
      _filteredStores = _stores;

      if (categoryId != 0) {
        _filteredStores = _stores
            .where(
              (item) => categoryId == item.categoryId,
            )
            .toList();
      }
    }

    notifyListeners();
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map(
        (place) {
          return InterestPlace(
            latitude: place[AppConstants.placeLatitude],
            longitude: place[AppConstants.placeLongitude2],
            name: place[AppConstants.nameKey],
            nameEn: place[AppConstants.nameKey],
            imageUrl: place[AppConstants.mainImageKey],
            description: place[AppConstants.shortDescEs],
            descriptionEn: place[AppConstants.shortDescEn],
            placeForDetail: getPlace(place),
          );
        },
      ).toList(),
    );

    return mappedPlaces;
  }

  List<InterestPlace> getInterestPlacesEn(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map(
        (place) {
          return InterestPlace(
            latitude: place[AppConstants.placeLatitude],
            longitude: place[AppConstants.placeLongitude2],
            name: place[AppConstants.nameKey],
            nameEn: place[AppConstants.nameKey],
            imageUrl: place[AppConstants.mainImageKey],
            description: place[AppConstants.shortDescEs],
            descriptionEn: place[AppConstants.shortDescEn],
            placeForDetail: getPlace(place),
          );
        },
      ).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    Map<String, dynamic> placeSchedule = {};

    if (place[AppConstants.placeSchedule] != null) {
      final schedule = jsonEncode(place[AppConstants.placeSchedule]);
      placeSchedule = jsonDecode(schedule);
    }

    final shortDescEn = place[AppConstants.shortDescEn];
    final shortDescEs = place[AppConstants.shortDescEs];

    return Store(
      placeId: place[AppConstants.idDataKey],
      mainImageUrl: place[AppConstants.mainImageKey],
      placeName: place[AppConstants.nameKey],
      placeNameEn: place[AppConstants.nameKey],
      shortDescription: shortDescEs,
      shortDescriptionEn: shortDescEn,
      longDescription: place[AppConstants.longDescriptionEsKey],
      longDescriptionEn: place[AppConstants.longDescriptionEnKey],
      categoryId: place[AppConstants.categoryKey][AppConstants.idDataKey],
      address: place[AppConstants.addressKey] ?? AppConstants.valueNotAvailable,
      latitude: place[AppConstants.placeLatitude],
      longitude: place[AppConstants.placeLongitude2],
      websiteUrl: place[AppConstants.websiteKey] ?? '',
      instagramUrl: place[AppConstants.igKey] ?? '',
      facebookUrl: place[AppConstants.fbKey] ?? '',
      twitterUrl: place[AppConstants.twitterKey] ?? '',
      activeOffers: ContentValidator.activeOffers(
        place[AppConstants.offersKey] ?? [],
      ),
      imageGallery: ContentValidator.imageGallery(
        place[AppConstants.imageGalleryKey] ?? [],
        AppConstants.idShopKey,
      ),
      schedule: placeSchedule,
      holidays: place['holidays'] ?? '',
      videoUrl: place[AppConstants.videoKey],
      placeType: AppConstants.shopApiType,
      placeTypeEn: AppConstants.shopApiType,
    );
  }
}
