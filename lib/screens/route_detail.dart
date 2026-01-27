import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_info_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/route_info.dart';
import 'package:valdeiglesias/widgets/route_points_section.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/screens/route_points_map.dart';
// import 'package:valdeiglesias/widgets/wishlist_button.dart'; // COMENTADO: Funcionalidad de estrella deshabilitada

class RouteDetail extends StatelessWidget {
  const RouteDetail({
    super.key,
    required this.route,
    required this.routeEn,
    required this.accessible,
  });

  final RouteItem route;
  final RouteItem routeEn;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final routeModel = context.watch<RouteModel>();

    final currentRoute = (language.english) ? routeEn : route;
    final isTouristicRoute =
        _isTouristicRoute(routeModel, currentRoute.routeTypeId);

    bool hideKMLButton = currentRoute.kmlFileUrl.isEmpty;
    const spacer = SizedBox(height: AppConstants.spacing);

    final downloadKMLLabel = (language.english)
        ? AppConstants.downloadKMLLabelEn
        : AppConstants.downloadKMLLabel;

    final kmlButton = Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        onPressed: () {
          Uri toLaunch = Uri.parse(currentRoute.kmlFileUrl).replace(
            scheme: 'https',
          );
          _launchInBrowser(toLaunch);
        },
        icon: const Icon(
          Icons.explore,
          color: AppConstants.contrast,
        ),
        label: Text(
          downloadKMLLabel,
          style: GoogleFonts.dmSans().copyWith(
            color: AppConstants.contrast,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        ),
      ),
    );

    final infoTitle = (language.english)
        ? AppConstants.routeInfoLabelEn
        : AppConstants.routeInfoLabel;

    final routeStartLocation = (language.english)
        ? AppConstants.routeStartLocationLabelEn
        : AppConstants.routeStartLocationLabel;

    final routeName =
        (language.english) ? currentRoute.placeNameEn : currentRoute.placeName;

    Widget gallery = const SizedBox();

    if (route.imageUrls != null && route.imageUrls!.isNotEmpty) {
      gallery = Gallery(imageUrls: route.imageUrls!);
    }

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Botón para volver a la lista de rutas',
          hint: 'Toca para regresar a la lista de rutas',
          button: true,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppConstants.backArrowColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Semantics(
          label: 'Título de la ruta: $routeName',
          child: DynamicTitle(value: routeName, accessible: accessible),
        ),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            top: AppConstants.spacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Center(
            child: Column(
              children: [
                Semantics(
                  label: 'Imagen principal de la ruta $routeName',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: SuperNetworkImage(
                        url: currentRoute.mainImageUrl!,
                        placeholderBuilder: () => Center(
                          child: LoaderBuilder.getLoader(),
                        ),
                      ),
                    ),
                  ),
                ),
                spacer,
                // WishlistButton(place: currentRoute, isTextButton: true), // COMENTADO: Funcionalidad de estrella deshabilitada
                spacer,
                Semantics(
                  label: 'Descripción de la ruta: ${(accessible) ? currentRoute.shortDescription! : currentRoute.longDescription!}',
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.spacing,
                      left: AppConstants.spacing,
                      right: AppConstants.spacing,
                    ),
                    child: Text(
                      (accessible)
                          ? currentRoute.shortDescription!
                          : currentRoute.longDescription!,
                      style: (accessible)
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                if (!hideKMLButton) ...[
                  kmlButton,
                  spacer,
                ],
                if (!isTouristicRoute) ...[
                  Semantics(
                    label: 'Información técnica de la ruta',
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacing,
                        left: AppConstants.spacing,
                        right: AppConstants.spacing,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          infoTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppConstants.primary),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  spacer,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChangeNotifierProvider(
                      create: (context) => RouteInfoModel(
                        routeTypeId: currentRoute.routeTypeId,
                        circuitTypeId: currentRoute.circuitTypeId,
                        distance: currentRoute.distance,
                        travelTimeInHours: currentRoute.travelTimeInHours,
                        travelTimeInMins: currentRoute.travelTimeInMins,
                        difficultyId: currentRoute.difficultyId,
                        maximumAltitude: currentRoute.maximumAltitude,
                        minimumAltitude: currentRoute.minimumAltitude,
                        positiveElevation: currentRoute.positiveElevation,
                        negativeElevation: currentRoute.negativeElevation,
                      ),
                      child: const RouteInfo(),
                    ),
                  ),
                  spacer,
                ],
                Semantics(
                  label: 'Ubicación de inicio de la ruta',
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.spacing,
                      left: AppConstants.spacing,
                      right: AppConstants.spacing,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        routeStartLocation,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppConstants.primary),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                spacer,
                Semantics(
                  label: 'Mapa de la ruta con ubicación de inicio',
                  child: SizedBox(
                    height: 400.0,
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              route.latitude!,
                              route.longitude!,
                            ),
                            initialZoom: AppConstants.mapInitialZoom,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: AppConstants.urlTemplate,
                              userAgentPackageName:
                                  AppConstants.userAgentPackageName,
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    route.latitude!,
                                    route.longitude!,
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: AppConstants.contrast,
                                    size: AppConstants.markerSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                spacer,
                if (currentRoute.points.isNotEmpty) ...[
                  RoutePointsSection(
                    points: currentRoute.points,
                    english: language.english,
                    accessible: accessible,
                  ),
                  spacer,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacing,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RoutePointsMap(
                                points: currentRoute.points,
                                routeName: routeName,
                                accessible: accessible,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.map,
                          color: AppConstants.contrast,
                        ),
                        label: Text(
                          language.english
                              ? 'View Points on Map'
                              : 'Ver Puntos en el Mapa',
                          style: GoogleFonts.dmSans().copyWith(
                            color: AppConstants.contrast,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  spacer,
                ],
                const Divider(),
                spacer,
                Semantics(
                  label: 'Galería de imágenes de la ruta',
                  child: gallery,
                ),
                spacer,
                Semantics(
                  label: 'Panel de calificaciones y reseñas de la ruta',
                  child: RatingPanel(
                    drupalId: route.placeId,
                    drupalType: AppConstants.drupalRoute,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isTouristicRoute(RouteModel routeModel, int routeTypeId) {
    final types = [
      ...routeModel.routeTypes,
      ...routeModel.routeTypesEn,
    ];

    for (final type in types) {
      if (type.id == routeTypeId && _matchesTouristic(type.name)) {
        return true;
      }
    }

    return false;
  }

  bool _matchesTouristic(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    final normalized = _normalize(value);

    return normalized.contains('turistica') ||
        normalized.contains('turistico') ||
        normalized.contains('touristic') ||
        normalized.contains('tourist');
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }

  void _launchInBrowser(Uri uriToLaunch) async {
    bool launched =
        await launchUrl(uriToLaunch, mode: LaunchMode.externalApplication);

    if (!launched) {
      throw Exception('Could not launch $uriToLaunch');
    }
  }
}
