import 'package:valdeiglesias/dtos/place.dart';

class MapPlaces {
  const MapPlaces({
    required this.cellars,
    required this.restaurants,
    required this.experiences,
    required this.guidedTours,
    required this.places,
    required this.routes,
    required this.routesEn,
    required this.events,
    required this.stores,
    required this.hotels,
  });

  final List<Place> cellars;
  final List<Place> restaurants;
  final List<Place> experiences;
  final List<Place> guidedTours;
  final List<Place> places;
  final List<Place> routes;
  final List<Place> routesEn;
  final List<Place> events;
  final List<Place> stores;
  final List<Place> hotels;
}
