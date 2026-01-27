import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/map_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/marker_icon.dart';
import 'package:valdeiglesias/widgets/place_bottom_sheet.dart';

class MapViewer extends StatefulWidget {
  const MapViewer({super.key});

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  late bool _filtersCreated;

  late FlutterMap _flutterMap;
  late Set<FilterItem> _filters;
  late List<Marker> _markers;

  @override
  void initState() {
    _filters = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapModel>(
      builder: (context, mapModel, child) {
        _filtersCreated = mapModel.filtersCreated;
        _filters = mapModel.selectedFilters;

        if (_filtersCreated) {
          _markers = _getMarkers(_filters);
          _flutterMap = _getMap();
          return _flutterMap;
        }

        return Center(child: LoaderBuilder.getLoader());
      },
    );
  }

  List<Marker> _getMarkers(Set<FilterItem> filters) {
    List<Marker> result = [];

    for (final filter in filters) {
      final markers = List.generate(
        filter.places!.length,
        (index) {
          final place = filter.places![index];

          final marker = Marker(
            point: LatLng(
              place.latitude!,
              place.longitude!,
            ),
            child: GestureDetector(
              child: MarkerIcon(
                placeName: place.placeName,
                placeImage: place.mainImageUrl!,
                sectionRoute: filter.section!.routeName,
              ),
              onTap: () => _showDetailModal(place, place),
            ),
          );

          return marker;
        },
      );
      result.addAll(markers);
    }

    return result;
  }

  FlutterMap _getMap() {
    return FlutterMap(
      options: const MapOptions(
        initialZoom: AppConstants.mapMediumZoom,
        initialCenter: AppConstants.smvCentralLocation,
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.urlTemplate,
          userAgentPackageName: AppConstants.userAgentPackageName,
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }

  /// Displays the detail modal for the selected place.
  ///
  /// This method shows a modal bottom sheet with detailed information
  /// about the selected [Place]. It is called when the user
  /// selects a place on the map.
  void _showDetailModal(Place place, Place? placeEn) async {
    const borderRadius = Radius.circular(AppConstants.borderRadius);
    const sheetBorderRadius = BorderRadius.only(
      topLeft: borderRadius,
      topRight: borderRadius,
    );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: sheetBorderRadius,
      ),
      builder: (context) => PlaceBottomSheet(
        place: place,
        placeEn: placeEn ?? place,
      ),
    ).then(
      (_) {},
    );
  }
}
