import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/place_image.dart';
import 'package:valdeiglesias/dtos/place_service.dart';
import 'package:valdeiglesias/dtos/place_service_pivot.dart';

class ContentValidator {
  static String value(List<dynamic> item) {
    String value = '';

    if (item.isNotEmpty) {
      value = item.first[AppConstants.valueKey].toString();

      if (value.isEmpty) value = AppConstants.valueNotAvailable;
    }

    return value;
  }

  static String url(List<dynamic> item) {
    String value = '';

    if (item.isNotEmpty) {
      value = item.first[AppConstants.urlKey] ?? '';
    }

    return value;
  }

  static List<PlaceImage> imageGallery(List<dynamic> imgData, String idKey) {
    List<PlaceImage> gallery = [];

    if (imgData.isNotEmpty) {
      for (var item in imgData) {
        gallery.add(
          PlaceImage(
            placeId: item[idKey],
            imageUrl: item[AppConstants.imageKey],
          ),
        );
      }
    }

    return gallery;
  }

  static List<String> imageUrls(List<dynamic> imgData) {
    List<String> urls = [];

    if (imgData.isNotEmpty) {
      for (var item in imgData) {
        urls.add(item[AppConstants.urlKey]);
      }
    }

    return urls;
  }

  static List<String> apiImageUrls(List<dynamic> imgData) {
    List<String> urls = [];

    if (imgData.isNotEmpty) {
      for (var item in imgData) {
        urls.add(item[AppConstants.imageKey]);
      }
    }

    return urls;
  }

  static PlaceCategory? placeCategory(dynamic item, String key) {
    if (item != null) {
      return PlaceCategory(
        id: item[AppConstants.idDataKey],
        name: item[key],
      );
    }

    return null;
  }

  static PlaceCategory? professionalPlaceCategory(dynamic item, String categoryKey, String nameKey) {
    if (item != null) {
      final categoryMap = item[categoryKey];

      return PlaceCategory(
        id: item[AppConstants.idDataKey],
        name: categoryMap[nameKey],
      );
    }

    return null;
  }

  static List<Offer> activeOffers(List<dynamic> offers) {
    List<Offer> activeOffers = [];

    if (offers.isNotEmpty) {
      for (var item in offers) {
        int offerId = item[AppConstants.idDataKey];
        String name = item[AppConstants.nameEs];
        String nameEn = item[AppConstants.nameEn];
        String shortDesc = item[AppConstants.shortDescEs];
        String shortDescEn = item[AppConstants.shortDescEn];
        String longDesc = item[AppConstants.longDescEs];
        String longDescEn = item[AppConstants.longDescEs];
        String imageUrl = item[AppConstants.imageKey];
        String startDate = item[AppConstants.startDateKey];
        String endDate = item[AppConstants.endDateKey];
        bool singleUse = item[AppConstants.singleUseKey] == 1;

        activeOffers.add(
          Offer(
            offerId: offerId,
            name: name,
            nameEn: nameEn,
            shortDesc: shortDesc,
            shortDescEn: shortDescEn,
            longDesc: longDesc,
            longDescEn: longDescEn,
            imageUrl: imageUrl,
            startDate: startDate,
            endDate: endDate,
            singleUse: singleUse,
          ),
        );
      }
    }

    return activeOffers;
  }

  static List<PlaceService> placeServices(
    List<dynamic> services,
    String idKey,
  ) {
    List<PlaceService> placeServices = [];

    if (services.isNotEmpty) {
      for (var item in services) {
        placeServices.add(
          PlaceService(
            id: item['id'],
            nameEs: item['name_es'],
            nameEn: item['name_en'],
            pivot: PlaceServicePivot(
              placeId: item['pivot'][idKey] ?? 0,
              serviceId: item['pivot']['id_service'] ?? 0,
            ),
          ),
        );
      }
    }

    return placeServices;
  }

  static LatLng location(List<dynamic> locations) {
    LatLng latLng = const LatLng(0.0, 0.0);

    if (locations.isNotEmpty) {
      latLng = LatLng(locations.first['lat'], locations.first['lng']);
    }

    return latLng;
  }

  static String videoUrl(List<dynamic> items) {
    String url = '';

    if (items.isNotEmpty) {
      url = items.first[AppConstants.urlKey];
    }

    return url;
  }
}
