import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/route_point_ref.dart';

/// Contains data for each existent route in backend
class RouteItem extends Place {
  RouteItem({
    required super.placeName,
    required super.placeNameEn,
    required super.latitude,
    required super.longitude,
    required super.placeType,
    required super.placeTypeEn,
    super.shortDescription,
    super.shortDescriptionEn,
    super.longDescription,
    super.longDescriptionEn,
    super.imageUrls,
    super.placeId,
    super.mainImageUrl,
    required this.routeTypeId,
    required this.circuitTypeId,
    required this.distance,
    required this.travelTimeInHours,
    required this.travelTimeInMins,
    required this.difficultyId,
    required this.maximumAltitude,
    required this.minimumAltitude,
    required this.positiveElevation,
    required this.negativeElevation,
    required this.kmlFileUrl,
    this.points = const [],
  });

  final int routeTypeId;
  final int circuitTypeId;
  final String distance;
  final int travelTimeInHours;
  final int travelTimeInMins;
  final int difficultyId;
  final int maximumAltitude;
  final int minimumAltitude;
  final int positiveElevation;
  final int negativeElevation;
  final String kmlFileUrl;
  final List<RoutePointRef> points;
}
