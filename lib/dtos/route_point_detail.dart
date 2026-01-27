import 'package:valdeiglesias/dtos/place.dart';

class RoutePointDetail {
  const RoutePointDetail({
    required this.id,
    required this.title,
    required this.url,
    this.shortDescription,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.place,
  });

  final int id;
  final String title;
  final String url;
  final String? shortDescription;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final Place? place;
}

