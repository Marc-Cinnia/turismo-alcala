import 'package:valdeiglesias/dtos/experience_item.dart';
import 'package:valdeiglesias/dtos/place_category.dart';

class ExperienceCategoriesData {
  ExperienceCategoriesData({
    required this.categories,
    required this.categoriesEn,
    required this.places,
    required this.placesEn,
  });

  final Set<PlaceCategory> categories;
  final Set<PlaceCategory> categoriesEn;
  final List<ExperienceItem> places;
  final List<ExperienceItem> placesEn;
}
