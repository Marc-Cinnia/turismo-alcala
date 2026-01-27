import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/route_point_detail.dart';
import 'package:valdeiglesias/dtos/route_point_ref.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/services/route_point_service.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/place_bottom_sheet.dart';

class RoutePointsMap extends StatefulWidget {
  const RoutePointsMap({
    super.key,
    required this.points,
    required this.routeName,
    required this.accessible,
  });

  final List<RoutePointRef> points;
  final String routeName;
  final bool accessible;

  @override
  State<RoutePointsMap> createState() => _RoutePointsMapState();
}

class _RoutePointsMapState extends State<RoutePointsMap> {
  late Future<List<RoutePointDetail>> _pointsFuture;

  @override
  void initState() {
    super.initState();
    _pointsFuture = RoutePointService().fetchPoints(widget.points);
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final mapTitle = language.english
        ? 'Route Points Map'
        : 'Mapa de Puntos de la Ruta';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: mapTitle, accessible: widget.accessible),
        actions: [],
      ),
      body: FutureBuilder<List<RoutePointDetail>>(
        future: _pointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoaderBuilder.getLoader());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing),
                child: Text(
                  language.english
                      ? 'Error loading route points'
                      : 'Error al cargar los puntos de la ruta',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final points = snapshot.data!;
          
          // Intentar resolver coordenadas desde los modelos locales si no están en el detail
          final pointsWithCoordinates = _resolveCoordinates(context, points);

          if (pointsWithCoordinates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing),
                child: Text(
                  language.english
                      ? 'No points with coordinates available'
                      : 'No hay puntos con coordenadas disponibles',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return _buildMap(pointsWithCoordinates, language.english);
        },
      ),
    );
  }

  List<RoutePointDetail> _resolveCoordinates(
      BuildContext context, List<RoutePointDetail> points) {
    final resolvedPoints = <RoutePointDetail>[];

    for (final point in points) {
      // Si ya tiene coordenadas, usarlas
      if (point.latitude != null && point.longitude != null) {
        resolvedPoints.add(point);
        continue;
      }

      // Si tiene un Place asociado con coordenadas, usarlas
      if (point.place != null &&
          point.place!.latitude != null &&
          point.place!.longitude != null) {
        resolvedPoints.add(RoutePointDetail(
          id: point.id,
          title: point.title,
          url: point.url,
          shortDescription: point.shortDescription,
          imageUrl: point.imageUrl,
          latitude: point.place!.latitude,
          longitude: point.place!.longitude,
          place: point.place,
        ));
        continue;
      }

      // Intentar resolver el Place desde los modelos locales
      final resolvedPlace = _resolvePlace(context, point);
      if (resolvedPlace != null &&
          resolvedPlace.latitude != null &&
          resolvedPlace.longitude != null) {
        resolvedPoints.add(RoutePointDetail(
          id: point.id,
          title: point.title,
          url: point.url,
          shortDescription: point.shortDescription,
          imageUrl: point.imageUrl,
          latitude: resolvedPlace.latitude,
          longitude: resolvedPlace.longitude,
          place: resolvedPlace,
        ));
      }
    }

    return resolvedPoints;
  }

  Place? _resolvePlace(BuildContext context, RoutePointDetail detail) {
    if (detail.place != null) {
      return detail.place;
    }

    final nodeId = detail.id.toString();

    final candidates = <List<Place>>[
      context.read<VisitModel>().placesToVisit,
      context.read<EatModel>().placesToEat,
      context.read<SleepModel>().placesToRest,
      context.read<ShopModel>().placesToShop,
      context.read<ExperienceModel>().items,
      context.read<GuidedToursModel>().tours,
      context.read<RouteModel>().routes,
      context.read<ScheduleModel>().eventSchedule,
      context.read<CellarModel>().cellars,
    ];

    for (final list in candidates) {
      final match = _findById(list, nodeId);
      if (match != null) {
        return match;
      }
    }

    return null;
  }

  Place? _findById(List<Place> places, String id) {
    try {
      return places.firstWhere(
        (place) => place.placeId != null && '${place.placeId}' == id,
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildMap(List<RoutePointDetail> points, bool english) {
    // Calcular el centro y los límites del mapa
    final latitudes = points.map((p) => p.latitude!).toList();
    final longitudes = points.map((p) => p.longitude!).toList();

    final minLat = latitudes.reduce((a, b) => a < b ? a : b);
    final maxLat = latitudes.reduce((a, b) => a > b ? a : b);
    final minLng = longitudes.reduce((a, b) => a < b ? a : b);
    final maxLng = longitudes.reduce((a, b) => a > b ? a : b);

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    // Calcular el zoom apropiado basado en la extensión de los puntos
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double initialZoom = AppConstants.mapInitialZoom;
    if (maxDiff < 0.01) {
      initialZoom = 15.0;
    } else if (maxDiff < 0.05) {
      initialZoom = 13.0;
    } else if (maxDiff < 0.1) {
      initialZoom = 12.0;
    } else {
      initialZoom = 11.0;
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(centerLat, centerLng),
        initialZoom: initialZoom,
        minZoom: 10.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.urlTemplate,
          userAgentPackageName: AppConstants.userAgentPackageName,
        ),
        MarkerLayer(
          markers: points.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;
            return Marker(
              point: LatLng(point.latitude!, point.longitude!),
              width: AppConstants.markerSize * 1.5,
              height: AppConstants.markerSize * 1.5,
              child: GestureDetector(
                onTap: () => _showPointInfo(context, point, english),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppConstants.contrast,
                      size: AppConstants.markerSize * 1.5,
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showPointInfo(
      BuildContext context, RoutePointDetail point, bool english) {
    // Intentar obtener el Place asociado o crear uno desde el detail
    Place? place = point.place;
    
    // Si no tiene Place, intentar resolverlo desde los modelos locales
    if (place == null) {
      place = _resolvePlace(context, point);
    }
    
    // Si aún no tiene Place, crear uno básico desde el detail
    if (place == null) {
      place = Place(
        placeName: point.title,
        placeNameEn: point.title,
        latitude: point.latitude,
        longitude: point.longitude,
        shortDescription: point.shortDescription,
        shortDescriptionEn: point.shortDescription,
        mainImageUrl: point.imageUrl ?? '',
        placeType: AppConstants.routeApiType,
        placeTypeEn: AppConstants.routeApiType,
      );
    }

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
        place: place!,
        placeEn: place,
      ),
    ).then(
      (_) {},
    );
  }
}

