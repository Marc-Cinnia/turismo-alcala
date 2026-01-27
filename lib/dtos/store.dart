import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_image.dart';

/// An item that represents
/// a place where user can shop
class Store extends Place {
  Store({
    required super.placeName,
    required super.placeNameEn,
    super.placeType,
    super.placeTypeEn,
    super.placeId,
    super.categoryId,
    super.address,
    super.latitude,
    super.longitude,
    super.websiteUrl,
    super.schedule,
    super.holidays,
    super.shortDescription,
    super.shortDescriptionEn,
    super.longDescription,
    super.longDescriptionEn,
    super.videoUrl,
    required this.mainImageUrl,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.activeOffers,
    required this.imageGallery,
  });

  final String mainImageUrl;
  final String instagramUrl;
  final String facebookUrl;
  final String twitterUrl;
  final List<Offer> activeOffers;
  final List<PlaceImage> imageGallery;
}
