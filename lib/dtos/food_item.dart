import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/place_image.dart';
import 'package:valdeiglesias/dtos/place_service.dart';

class FoodItem extends Place {
  FoodItem({
    required super.placeName,
    required super.placeNameEn,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required super.address,
    required super.placeType,
    required super.placeTypeEn,
    required super.websiteUrl,
    super.holidays,
    super.holidaysEn,
    super.placeId,
    super.videoUrl,
    super.canReserve,
    super.bookingUrl,
    super.instagramUrl,
    super.facebookUrl,
    super.twitterUrl,
    super.shortDescription,
    super.shortDescriptionEn,
    super.longDescription,
    super.longDescriptionEn,
    required this.mainImageUrl,
    required this.secondPhoneNumber,
    required this.email,
    required this.tripAdvisorUrl,
    required this.imageGallery,
    required this.activeOffers,
    required this.placeServices,
    this.category,
    this.schedule,
    this.scheduleEn,
  });

  final String mainImageUrl;
  final String secondPhoneNumber;
  final String email;
  final String tripAdvisorUrl;
  final Map<String, dynamic>? schedule;
  final Map<String, dynamic>? scheduleEn;
  final PlaceCategory? category;
  final List<PlaceImage> imageGallery;
  final List<Offer> activeOffers;
  List<PlaceService> placeServices;
}
