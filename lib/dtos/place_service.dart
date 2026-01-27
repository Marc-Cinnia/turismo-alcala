import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/place_service_pivot.dart';

class PlaceService extends FilterItem {
  PlaceService({
    required this.id,
    required this.pivot,
    required super.nameEn,
    required super.nameEs,
  });

  final int id;
  final PlaceServicePivot pivot;
}
