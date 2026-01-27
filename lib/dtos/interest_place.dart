import 'package:valdeiglesias/dtos/place.dart';

class InterestPlace {
  InterestPlace({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.descriptionEn,
    required this.placeForDetail,
    this.nameEn,
  });

  final double latitude;
  final double longitude;
  final String name;
  final String? nameEn;
  final String imageUrl;
  final String? description;
  String? descriptionEn;
  final Place placeForDetail;
}
