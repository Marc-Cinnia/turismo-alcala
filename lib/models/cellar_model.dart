import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/utils/content_validator.dart';
import 'package:valdeiglesias/models/app_model.dart';

class CellarModel extends AppModel with ChangeNotifier {
  CellarModel() {
    _fetchCellars();
  }

  List<Place> _cellars = [];

  List<Place> get cellars => _cellars;

  void _fetchCellars() async {
    print('=== CELLAR DEBUG ===');
    print('Fetching cellars from: ${AppConstants.cellarUrl}');

    try {
      final response = await http.get(Uri.parse(AppConstants.cellarUrl));
      print('Response status: ${response.statusCode}');

      if (response.statusCode == AppConstants.success) {
        final newCellars = _getPlaces(response);
        print('Parsed ${newCellars.length} cellars');
        
        _cellars.addAll(newCellars);
        
        if (_cellars.isNotEmpty) {
          notifyListeners();
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cellars: $e');
    }
    print('==================');
  }

  List<Place> _getPlaces(http.Response response) {
    List<Place> cellars = [];
    print('=== CELLAR PARSING DEBUG ===');

    if (response.statusCode == AppConstants.success) {
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        print('JSON decoded successfully');
        print('Body keys: ${body.keys.toList()}');

        // Verificar que la respuesta es exitosa según el formato del API
        if (body['status_code'] == 200 && body['data'] != null) {
          final List<dynamic> cellarsFetched = body['data'];
          print('Cellars in data key: ${cellarsFetched.length}');

          for (final cellar in cellarsFetched) {
            print('Processing cellar: ${cellar['name']}');

            try {
              // Usar los nombres de campos correctos del API
              cellars.add(
                Place(
                  placeId: cellar['id'],
                  placeName: cellar['name'],
                  placeNameEn: cellar['name'],
                  placeType: AppConstants.cellarApiType,
                  placeTypeEn: AppConstants.cellarApiType,
                  mainImageUrl: cellar['main_image'],
                  shortDescription: cellar['short_description_es'],
                  shortDescriptionEn: cellar['short_description_en'],
                  longDescription: cellar['long_description_es'],
                  longDescriptionEn: cellar['long_description_en'],
                  phoneNumber: cellar['phone_number'],
                  phoneNumber2: cellar['phone_number2'] ?? '',
                  email: cellar['email'],
                  websiteUrl: cellar['web'],
                  imageUrls: ContentValidator.apiImageUrls(cellar['image_gallery'] ?? []),
                  videoUrl: cellar['video'],
                  canReserve: cellar['can_reserve'] == 1,
                  latitude: cellar['lat']?.toDouble(),
                  longitude: cellar['lon']?.toDouble(),
                  address: cellar['address'],
                  instagramUrl: cellar['instagram'],
                  facebookUrl: cellar['facebook'],
                  twitterUrl: cellar['twitter'],
                  holidays: cellar['holidays'],
                  activeOffers: ContentValidator.activeOffers(cellar['offer'] ?? []),
                  schedule: cellar['schedule_es'],
                  scheduleEn: cellar['schedule_en'],
                ),
              );
            } catch (e) {
              print('Error parsing individual cellar: $e');
            }
          }
        } else {
          print('API response not successful or missing data');
        }
      } catch (e) {
        print('Error parsing cellar data: $e');
      }
    }

    print('Final cellars count: ${cellars.length}');
    print('========================');
    return cellars;
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map((place) {
        return InterestPlace(
          latitude: place['lat']?.toDouble(),
          longitude: place['lon']?.toDouble(),
          name: place['name'],
          imageUrl: place['main_image'],
          description: place['short_description_es'],
          descriptionEn: place['short_description_en'],
          placeForDetail: getPlace(place),
        );
      }).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    return Place(
      placeId: place['id'],
      placeName: place['name'],
      placeNameEn: place['name'],
      placeType: AppConstants.cellarApiType,
      placeTypeEn: AppConstants.cellarApiType,
      mainImageUrl: place['main_image'],
      shortDescription: place['short_description_es'],
      shortDescriptionEn: place['short_description_en'],
      longDescription: place['long_description_es'],
      longDescriptionEn: place['long_description_en'],
      phoneNumber: place['phone_number'],
      phoneNumber2: place['phone_number2'] ?? '',
      email: place['email'],
      websiteUrl: place['web'],
      imageUrls: ContentValidator.apiImageUrls(place['image_gallery'] ?? []),
      videoUrl: place['video'],
      canReserve: place['can_reserve'] == 1,
      latitude: place['lat']?.toDouble(),
      longitude: place['lon']?.toDouble(),
      address: place['address'],
      instagramUrl: place['instagram'],
      facebookUrl: place['facebook'],
      twitterUrl: place['twitter'],
      holidays: place['holidays'],
      activeOffers: ContentValidator.activeOffers(place['offer'] ?? []),
      schedule: place['schedule_es'],
      scheduleEn: place['schedule_en'],
    );
  }
}
