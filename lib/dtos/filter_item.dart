import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_service.dart';
import 'package:valdeiglesias/dtos/section.dart';

class FilterItem {
  FilterItem({
    required this.nameEn,
    required this.nameEs,
    this.section,
    this.placeService,
    this.places,
    this.placesEn,
    this.isSelected = false,
  });

  final String nameEs;
  final String nameEn;
  Section? section;
  PlaceService? placeService;
  List<Place>? places;
  List<Place>? placesEn;
  bool isSelected;
}
