import 'package:valdeiglesias/dtos/place.dart';

class ExperienceItem extends Place {
  ExperienceItem({
    required super.placeName,
    required super.placeNameEn,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required super.address,
    required super.placeType,
    required super.placeTypeEn,
    super.mainImageUrl,
    super.placeId,
    super.shortDescription,
    super.longDescription,
    super.websiteUrl,
    super.imageUrls,
    super.categoryId,
    super.videoUrl,
  });
}
