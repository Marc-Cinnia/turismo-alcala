import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/food_item.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/place_service.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class EatModel extends AppModel with ChangeNotifier {
  EatModel() {
    _fetchPlaces();
  }

  final List<FoodItem> _placesToEat = [];
  final List<FoodItem> _placesToEatEn = [];
  final List<PlaceService> _services = [];
  Set<PlaceCategory> _categories = {};
  Set<PlaceCategory> _categoriesEn = {};
  List<FoodItem> _filteredPlaces = [];
  bool _dataFetched = false;

  List<FoodItem> get placesToEat => _placesToEat;
  List<FoodItem> get placesToEatEn => _placesToEatEn;
  List<FoodItem> get filteredPlaces => _filteredPlaces;
  Set<PlaceCategory> get categories => _categories;
  Set<PlaceCategory> get categoriesEn => _categoriesEn;
  List<PlaceService> get services => _services;
  bool get hasData => _dataFetched;

  /// Fetch data about places where user can
  /// eat from corresponding https endpoint
  void _fetchPlaces() async {
    if (_placesToEat.isEmpty) {
      final response = await http.get(Uri.parse(AppConstants.whereToEat));

      if (response.statusCode == AppConstants.success) {
        dynamic body = jsonDecode(response.body);
        List<dynamic> restaurants = body[AppConstants.dataKey];

        for (final restaurant in restaurants) {
          _setCategory(restaurant);

          final placeServices = ContentValidator.placeServices(
            restaurant[AppConstants.servicesKey] ?? [],
            AppConstants.idRestaurantKey,
          );
          final place = getPlace(restaurant) as FoodItem;
          place.placeServices = placeServices;

          _services.addAll(placeServices);
          _placesToEat.add(place);
        }

        _categories = ContentBuilder.getProfessionalOrderedCategories(
          _categories.toSet(),
          AppConstants.categoryAll,
        );
        _categoriesEn = ContentBuilder.getProfessionalOrderedCategories(
          _categoriesEn.toSet(),
          AppConstants.categoryAllEn,
        );
      }

      _dataFetched = true;
    }

    notifyListeners();
  }

  List<FoodItem> filterByCategory(int categoryId) {
    if (_placesToEat.isNotEmpty) {
      _filteredPlaces = _placesToEat
          .where((item) => categoryId == item.category?.id)
          .toList();
    }

    return _filteredPlaces;
  }

  void _setCategory(dynamic item) {
    if (item[AppConstants.categoryKey] != null) {
      _categories.add(
        ContentValidator.professionalPlaceCategory(
          item,
          AppConstants.categoryKey,
          AppConstants.nameEs,
        )!,
      );
      _categoriesEn.add(
        ContentValidator.professionalPlaceCategory(
          item,
          AppConstants.categoryKey,
          AppConstants.nameEn,
        )!,
      );
    }
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
  Place getPlace(dynamic place) {
    Map<String, dynamic> placeSchedule = {};
    Map<String, dynamic> placeScheduleEn = {};
    bool canReserve = false;

    if (place[AppConstants.placeSchedule] != null) {
      final schedule = jsonEncode(place[AppConstants.placeSchedule]);
      final scheduleEn = jsonEncode(place[AppConstants.placeScheduleEn]);

      placeSchedule = jsonDecode(schedule);
      placeScheduleEn = jsonDecode(scheduleEn);
    }

    if (place[AppConstants.canReserveKey] != null) {
      canReserve = (place[AppConstants.canReserveKey] == 0) ? false : true;
    }

    return FoodItem(
      placeId: place[AppConstants.idDataKey],
      placeName: place[AppConstants.nameKey],
      placeNameEn: place[AppConstants.nameKey],
      mainImageUrl: place[AppConstants.mainImageKey],
      shortDescription: place[AppConstants.shortDescEs],
      longDescription: place[AppConstants.longDescriptionEsKey],
      shortDescriptionEn: place[AppConstants.shortDescEn],
      longDescriptionEn: place[AppConstants.longDescriptionEnKey],
      address: place[AppConstants.addressKey] ?? AppConstants.valueNotAvailable,
      latitude: place[AppConstants.placeLatitude],
      longitude: place[AppConstants.placeLongitude2],
      phoneNumber: place['phone_number'].toString(),
      secondPhoneNumber: place['phone_number2'].toString(),
      email: place['email'] ?? '',
      websiteUrl: place[AppConstants.websiteKey] ?? '',
      tripAdvisorUrl: place['tripadvisor'] ?? '',
      bookingUrl: place['booking'] ?? '',
      instagramUrl: place[AppConstants.igKey] ?? '',
      facebookUrl: place[AppConstants.fbKey] ?? '',
      twitterUrl: place[AppConstants.twitterKey] ?? '',
      schedule: placeSchedule,
      scheduleEn: placeScheduleEn,
      holidays: place['holidays'] ?? AppConstants.noVacationDataLabel,
      category: ContentValidator.professionalPlaceCategory(
        place,
        AppConstants.categoryKey,
        AppConstants.nameEs,
      ),
      imageGallery: ContentValidator.imageGallery(
        place[AppConstants.imageGalleryKey] ?? [],
        AppConstants.idRestaurantKey,
      ),
      activeOffers: ContentValidator.activeOffers(
        place[AppConstants.offersKey] ?? [],
      ),
      placeServices: services,
      placeType: AppConstants.eatApiType,
      placeTypeEn: AppConstants.eatApiType,
      videoUrl: place[AppConstants.videoKey],
      canReserve: canReserve,
    );
  }
}
