import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';

/// It represents the categories of places.
///
/// The fields of this class contain data
/// about various categories of places.
class PlacesCategories {
  PlacesCategories({
    required this.categories,
    required this.categoriesEn,
    required this.places,
    required this.placesEn,
  });

  final Set<PlaceCategory> categories;

  final Set<PlaceCategory> categoriesEn;

  /// The places fetched from backend (in default language).
  final List<Place> places;

  /// The places fetched from backend (in english).
  final List<Place> placesEn;
}
