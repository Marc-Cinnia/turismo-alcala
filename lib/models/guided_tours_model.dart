import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class GuidedToursModel extends AppModel with ChangeNotifier {
  GuidedToursModel() {
    _fetchTours();
  }

  List<Place> _tours = [];

  List<Place> get tours => _tours;

  void _fetchTours() async {
    final response = await http.get(Uri.parse(AppConstants.toursUrl));

    _tours.addAll(_getPlaces(response));

    if (_tours.isNotEmpty) {
      notifyListeners();
    }
  }

  List<Place> _getPlaces(http.Response response) {
    List<Place> tours = [];

    if (response.statusCode == AppConstants.success) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> toursFetched = body[AppConstants.dataKey];

      for (final tour in toursFetched) {
        int tourId = tour[AppConstants.idDataKey];
        String name = tour[AppConstants.nameKey];
        String imgUrl = tour[AppConstants.mainImageKey];
        String? videoUrl = tour[AppConstants.videoKey];
        String shortDesc = tour[AppConstants.shortDescEs];
        String shortDescEn = tour[AppConstants.shortDescEn];
        String longDesc = tour[AppConstants.longDescEs];
        String longDescEn = tour[AppConstants.longDescEn];
        String phone1 = tour[AppConstants.phoneKey];
        String phone2 = tour[AppConstants.phone2Key];
        String email = tour[AppConstants.emailKey];
        String website = tour[AppConstants.websiteKey];
        bool canReserve =
            (tour[AppConstants.canReserveKey] != 0) ? true : false;

        List<dynamic> tourImages = tour[AppConstants.imageGalleryKey];
        final List<Offer> activeOffers = ContentValidator.activeOffers(
          tour[AppConstants.offersKey] ?? [],
        );

        tours.add(
          Place(
            placeId: tourId,
            placeName: name,
            placeNameEn: name,
            placeType: AppConstants.tourApiType,
            placeTypeEn: AppConstants.tourApiType,
            mainImageUrl: imgUrl,
            shortDescription: shortDesc,
            shortDescriptionEn: shortDescEn,
            longDescription: longDesc,
            longDescriptionEn: longDescEn,
            latitude: tour[AppConstants.placeLatitude],
            longitude: tour[AppConstants.placeLongitude2],
            phoneNumber: phone1,
            phoneNumber2: phone2,
            email: email,
            websiteUrl: website,
            imageUrls: ContentValidator.apiImageUrls(tourImages),
            videoUrl: videoUrl,
            canReserve: canReserve,
            activeOffers: activeOffers,
          ),
        );
      }
    }
    return tours;
  }

  @override
  List<InterestPlace> getInterestPlaces(List places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map((place) {
        return InterestPlace(
          latitude: place[AppConstants.placeLatitude],
          longitude: place[AppConstants.placeLongitude2],
          name: place[AppConstants.nameKey],
          imageUrl: place[AppConstants.mainImageKey],
          description: place[AppConstants.shortDescEs],
          descriptionEn: place[AppConstants.shortDescEn],
          placeForDetail: getPlace(place),
        );
      }).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    int tourId = place[AppConstants.idDataKey];
    String name = place[AppConstants.nameKey];
    String imgUrl = place[AppConstants.mainImageKey];
    String videoUrl = place[AppConstants.videoKey];
    String shortDesc = place[AppConstants.shortDescEs];
    String shortDescEn = place[AppConstants.shortDescEn];
    String longDesc = place[AppConstants.longDescEs];
    String longDescEn = place[AppConstants.longDescEn];
    String phone1 = place[AppConstants.phoneKey];
    String phone2 = place[AppConstants.phone2Key];
    String email = place[AppConstants.emailKey];
    String website = place[AppConstants.websiteKey];
    bool canReserve = (place[AppConstants.canReserveKey] != 0) ? true : false;

    List<dynamic> tourImages = place[AppConstants.imageGalleryKey];

    return Place(
      placeId: tourId,
      placeName: name,
      placeNameEn: name,
      placeType: AppConstants.tourApiType,
      placeTypeEn: AppConstants.tourApiType,
      mainImageUrl: imgUrl,
      shortDescription: shortDesc,
      shortDescriptionEn: shortDescEn,
      longDescription: longDesc,
      longDescriptionEn: longDescEn,
      latitude: place[AppConstants.placeLatitude],
      longitude: place[AppConstants.placeLongitude2],
      phoneNumber: phone1,
      phoneNumber2: phone2,
      email: email,
      websiteUrl: website,
      imageUrls: ContentValidator.apiImageUrls(tourImages),
      videoUrl: videoUrl,
      canReserve: canReserve,
    );
  }
}
