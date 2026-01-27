import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/place_image.dart';
import 'package:valdeiglesias/dtos/place_service.dart';

class Hotel extends Place {
  Hotel({
    required super.placeType,
    required super.placeTypeEn,
    required super.placeName,
    required super.placeNameEn,
    super.email,
    super.bookingUrl,
    super.activeOffers,
    required super.instagramUrl,
    required super.facebookUrl,
    required super.twitterUrl,
    super.address,
    super.latitude,
    super.longitude,
    super.phoneNumber,
    super.schedule,
    super.scheduleEn,
    super.websiteUrl,
    super.holidays,
    super.placeId,
    super.videoUrl,
    super.canReserve,
    super.shortDescription,
    super.shortDescriptionEn,
    super.longDescription,
    super.longDescriptionEn,
    super.mainImageUrl,
    super.imageUrls,

    required this.secondPhoneNumber,
    required this.imageGallery,
    required this.placeServices,
    this.category,
  });

  final String secondPhoneNumber;
  final PlaceCategory? category;
  final List<PlaceImage> imageGallery;
  List<PlaceService> placeServices;
}
