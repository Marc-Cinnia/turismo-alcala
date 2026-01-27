import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/models/plan_model.dart';

class PlanMap extends StatefulWidget {
  const PlanMap({super.key});

  @override
  State<PlanMap> createState() => _PlanMapState();
}

class _PlanMapState extends State<PlanMap> {
  late List<JourneyPoint?> _journeyPoints;
  late Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _journeyPoints = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentPosition = Provider.of<PlanModel>(context).currentPosition;
    _journeyPoints = Provider.of<PlanModel>(context).journeyPoints;
  }

  @override
  Widget build(BuildContext context) {
    _currentPosition = context.watch<PlanModel>().currentPosition;

    Widget map = const SizedBox();

    bool hasData = _journeyPoints.every(
      (point) => point?.placeLatitude != null && point?.placeLongitude != null,
    );

    Marker? userLocationMarker;

    if (_currentPosition != null) {
      userLocationMarker = Marker(
        point: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        child: Stack(
          children: [
            Center(
              child: FaIcon(
                FontAwesomeIcons.locationPin,
                color: AppConstants.lessContrast,
                size: AppConstants.markerSize,
              ),
            ),
            Center(
              child: Icon(
                Icons.person_pin_circle_outlined,
                size: AppConstants.markerSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final markers = List.generate(
      _journeyPoints.length,
      (index) {
        double latitude = _journeyPoints[index]!.placeLatitude!;
        double longitude = _journeyPoints[index]!.placeLongitude!;
        int placeIndex = _journeyPoints[index]!.placeIndex!;

        return Marker(
          point: LatLng(
            latitude,
            longitude,
          ),
          child: Stack(
            children: [
              Center(
                child: FaIcon(
                  FontAwesomeIcons.locationPin,
                  color: AppConstants.contrast,
                  size: AppConstants.markerSize,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '$placeIndex',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (userLocationMarker != null) {
      markers.add(userLocationMarker);
    }

    if (hasData) {
      map = SizedBox(
        height: AppConstants.mapHeight,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: AppConstants.smvCentralLocation,
            initialZoom: AppConstants.mapShortZoom,
          ),
          children: [
            TileLayer(
              urlTemplate: AppConstants.urlTemplate,
              userAgentPackageName: AppConstants.userAgentPackageName,
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      );
    }

    return map;
  }
}
