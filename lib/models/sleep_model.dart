import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/hotel.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

/// Model class for managing state for places
/// where users can rest (hotels)
class SleepModel extends AppModel with ChangeNotifier {
  SleepModel() {
    _fetchHotels();
  }

  final List<Hotel> _hotels = [];

  Set<PlaceCategory> _categories = {};
  Set<PlaceCategory> _categoriesEn = {};
  List<Hotel> _filteredHotels = [];

  List<Hotel> get placesToRest => _hotels;
  Set<PlaceCategory> get categories => _categories;
  Set<PlaceCategory> get categoriesEn => _categoriesEn;
  bool get hasData => _categories.isNotEmpty && _categoriesEn.isNotEmpty;

  /// Fetch data about places where user can
  /// sleep from corresponding https endpoint
  void _fetchHotels() async {
    if (_hotels.isEmpty) {
      final response = await http.get(Uri.parse(AppConstants.whereToSleep));

      if (response.statusCode == AppConstants.success) {
        dynamic body = jsonDecode(response.body);
        List<dynamic> hotels = body[AppConstants.dataKey];

        for (final hotel in hotels) {
          _setCategory(hotel);

          final placeServices = ContentValidator.placeServices(
            hotel[AppConstants.servicesKey],
            AppConstants.idHotelKey,
          );
          final place = getPlace(hotel) as Hotel;
          place.placeServices = placeServices;

          _hotels.add(place);
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
    }

    notifyListeners();
  }

  List<Hotel> filterByCategory(int categoryId) {
    if (_hotels.isNotEmpty) {
      _filteredHotels = _hotels
          .where(
            (item) => categoryId == item.category?.id,
          )
          .toList();
    }

    return _filteredHotels;
  }

  void _setCategory(dynamic item) {
    if (item[AppConstants.categoryKey] != null) {
      _categories.add(
        ContentValidator.professionalPlaceCategory(
            item, AppConstants.categoryKey, AppConstants.nameEs)!,
      );
      _categoriesEn.add(
        ContentValidator.professionalPlaceCategory(
            item, AppConstants.categoryKey, AppConstants.nameEn)!,
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
  Place getPlace(place) {
    Map<String, dynamic> placeSchedule = {};
    Map<String, dynamic> placeScheduleEn = {};
    bool canReserve = false;

    if (place[AppConstants.placeSchedule] != null) {
      final schedule = jsonEncode(place[AppConstants.placeSchedule]);
      placeSchedule = jsonDecode(schedule);
    }

    if (place[AppConstants.placeScheduleEn] != null) {
      placeScheduleEn = place[AppConstants.placeScheduleEn];
    }

    if (place[AppConstants.canReserveKey] != null) {
      canReserve = (place[AppConstants.canReserveKey] == 0) ? false : true;
    }

    return Hotel(
      placeId: place[AppConstants.idDataKey],
      placeName: place['name'],
      placeNameEn: place['name'],
      mainImageUrl: place['main_image'],
      shortDescription: place['short_description_es'],
      shortDescriptionEn: place['short_description_en'],
      longDescription: place['long_description_es'],
      longDescriptionEn: place['long_description_en'],
      address: place['address'],
      latitude: place['lat'],
      longitude: place['lon'],
      phoneNumber:
          place['phone_number']?.toString() ?? AppConstants.valueNotAvailable,
      secondPhoneNumber:
          place['phone_number2']?.toString() ?? AppConstants.valueNotAvailable,
      email: place['email'] ?? AppConstants.valueNotAvailable,
      websiteUrl: place['web'] ?? AppConstants.valueNotAvailable,
      bookingUrl: place['booking'] ?? AppConstants.valueNotAvailable,
      instagramUrl: place['instagram'] ?? AppConstants.valueNotAvailable,
      facebookUrl: place['facebook'] ?? AppConstants.valueNotAvailable,
      twitterUrl: place['twitter'] ?? AppConstants.valueNotAvailable,
      schedule: placeSchedule,
      scheduleEn: placeScheduleEn,
      holidays: place['holidays'] ?? AppConstants.noVacationDataLabel,
      category: ContentValidator.professionalPlaceCategory(place, AppConstants.categoryKey, AppConstants.nameEs),
      imageGallery: ContentValidator.imageGallery(
        place['image_gallery'] ?? [],
        AppConstants.idHotelKey,
      ),
      activeOffers: ContentValidator.activeOffers(
        place['offer'] ?? [],
      ),
      placeServices: ContentValidator.placeServices(
        place['services'] ?? [],
        AppConstants.idHotelKey,
      ),
      placeType: AppConstants.sleepApiType,
      placeTypeEn: AppConstants.sleepApiType,
      videoUrl: place[AppConstants.videoKey],
      canReserve: canReserve,
    );
  }
}
