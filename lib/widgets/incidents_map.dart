import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/incident_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/widgets/location_button.dart';

class IncidentsMap extends StatefulWidget {
  const IncidentsMap({super.key});

  @override
  State<IncidentsMap> createState() => _IncidentsMapState();
}

class _IncidentsMapState extends State<IncidentsMap> {
  final _spacer = const SizedBox(height: AppConstants.spacing);

  LatLng _center = AppConstants.smvCentralLocation;
  LatLng? _userPosition;

  late bool _english;
  late bool _reportSent;
  late String _mapTitle;
  late List<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    _english = context.watch<LanguageModel>().english;
    _mapTitle = (_english) ? AppConstants.mapTitleEn : AppConstants.mapTitle;
    _markers = context.watch<IncidentModel>().markers;
    _reportSent = context.watch<IncidentModel>().reportSent;

    if (_reportSent) {
      _markers.clear();
      _userPosition = null;
    }

    if (_userPosition != null) {
      _markers.add(
        Marker(
          point: LatLng(
            _userPosition!.latitude,
            _userPosition!.longitude,
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
        ),
      );
    }

    final title = Text(
      _mapTitle,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppConstants.primary,
          ),
    );

    final mapSizedBox = SizedBox(
      height: AppConstants.mapHeight,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _center,
          initialZoom: AppConstants.mapInitialZoom,
          onTap: (position, latLng) {
            setState(
              () {
                _userPosition = latLng;
                _markers.clear();
                // _markers.add(
                //   Marker(
                //     point: latLng,
                //     child: const Icon(
                //       Icons.location_on_rounded,
                //       color: AppConstants.contrast,
                //       size: AppConstants.markerSize,
                //     ),
                //   ),
                // );
                context.read<IncidentModel>().userPosition = latLng;
                context.read<IncidentModel>().userPositionAdded = true;
              },
            );
          },
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
      ),
    );

    final locationButton = LocationButton(
      onPressed: () async {
        LatLng? position;

        position = await _getCurrentLocation();

        if (position != null) {
          String message = (_english)
              ? AppConstants.locationAddedEn
              : AppConstants.locationAdded;

          context.read<IncidentModel>().userPosition = position;
          context.read<IncidentModel>().userPositionAdded = true;
          _markers.clear();
          _markers.add(
            Marker(
              point: LatLng(
                position.latitude,
                position.longitude,
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
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          setState(() => _userPosition = position);
        }
      },
    );

    final mapMain = Column(
      children: [
        mapSizedBox,
        _spacer,
        locationButton,
      ],
    );

    return Column(
      children: [
        title,
        _spacer,
        mapMain,
      ],
    );
  }

  Future<LatLng?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están permanentemente denegados.');
    }

    final currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }
}
