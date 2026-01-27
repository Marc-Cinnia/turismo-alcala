import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:super_network_image/super_network_image.dart';

import '../constants/app_constants.dart';
import '../models/language_model.dart';
import '../screens/museal.dart';
import '../utils/loader_builder.dart';
import 'language_selector.dart';

// Widget que muestra un bottom sheet con información de un lugar específico
class PlaceBottomSheet extends StatelessWidget {
  const PlaceBottomSheet({
    super.key,
    required this.place,
  });

  final Map<String, dynamic> place; // Datos del lugar a mostrar

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(
      AppConstants.borderRadius,
    );
    const sheetBorderRadius = BorderRadius.only(
      topLeft: borderRadius,
      topRight: borderRadius,
    );
    const bottomSheetTextPadding = EdgeInsets.only(
      left: AppConstants.spacing,
      right: AppConstants.spacing,
    );
    const spacer = SizedBox(
      height: AppConstants.shortSpacing,
    );

    final language = context.watch<LanguageModel>();

    // Función auxiliar para extraer valores de forma segura de los campos del lugar
    String getValue(dynamic field) {
      if (field == null) return '';
      if (field is List && field.isNotEmpty) {
        if (field[0] is Map) {
          if (field[0]['url'] != null) {
            return field[0]['url'].toString();
          }
          if (field[0]['value'] != null) {
            return field[0]['value'].toString();
          }
        }
        return '';
      }
      if (field is Map && field['value'] != null) {
        return field['value'].toString();
      }
      return '';
    }

    final String description = getValue(place['field_museal_description']);
    final String name = getValue(place['title']);

    final modalArriveLabel = (language.english)
        ? AppConstants.modalArriveLabelEn
        : AppConstants.modalArriveLabel;

    final modalDetailLabel = (language.english)
        ? AppConstants.modalDetailLabelEn
        : AppConstants.modalDetailLabel;

    // Extrae las coordenadas para las direcciones de Google Maps
    double? latitude;
    double? longitude;
    final location = place['field_museal_location'];
    if (location != null && location is List && location.isNotEmpty) {
      final locData = location[0];
      if (locData != null && locData['lat'] != null && locData['lng'] != null) {
        latitude = locData['lat'].toDouble();
        longitude = locData['lng'].toDouble();
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.8; // Ocupa 80% de la altura de la pantalla
    
    return Container(
      height: availableHeight,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            ClipRRect(
              borderRadius: sheetBorderRadius,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Altura más grande para imágenes verticales, pero sin estirar
                  final imageHeight = constraints.maxWidth * 0.9; 
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: imageHeight,
                    child: SuperNetworkImage(
                      url: getValue(place['field_museal_main_image']),
                      width: constraints.maxWidth,
                      height: imageHeight,
                      fit: BoxFit.contain, // Muestra la imagen completa sin distorsionarla
                      placeholderBuilder: () => Center(
                        child: LoaderBuilder.getLoader(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Semantics(
              header: true,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.spacing),
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppConstants.primary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppConstants.spacing),
                    child: const LanguageSelector(),
                  ),
                ],
              ),
            ),
            Semantics(
              label: 'Descripción: $description',
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: bottomSheetTextPadding,
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            spacer,
            Semantics(
              label: 'Sección de botones de acción para esta escultura. Aquí puedes obtener direcciones o ver información completa.',
              child: Container(
                margin: const EdgeInsets.only(
                  top: AppConstants.spacing,
                  right: AppConstants.spacing,
                  bottom: AppConstants.spacing,
                ),
                child: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    Semantics(
                      label: 'Botón para obtener direcciones a esta escultura en Google Maps. Te llevará a la aplicación de mapas con la ruta desde tu ubicación actual.',
                      hint: 'Toca para abrir Google Maps con direcciones paso a paso',
                      button: true,
                      child: TextButton.icon(
                        onPressed: () async {
                          if (latitude != null && longitude != null) {
                            _launchDirectionsMap(latitude, longitude);
                          }
                        },
                        icon: const Icon(
                          Icons.map_outlined,
                          color: AppConstants.contrast,
                        ),
                        label: Text(
                          modalArriveLabel,
                          style: GoogleFonts.dmSans().copyWith(
                            color: AppConstants.contrast,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing),
                    Semantics(
                      label: 'Ver detalles completos de ${getValue(place['title']).isNotEmpty ? getValue(place['title']) : 'esta escultura'}',
                      hint: 'Toca para abrir la página completa con descripción detallada, material, medidas, año de construcción, imágenes y referencias bibliográficas',
                      button: true,
                      enabled: true,
                      focusable: true,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(place: place),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline, color: Colors.white),
                        label: Text(
                          modalDetailLabel,
                          style: GoogleFonts.dmSans().copyWith(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            AppConstants.contrast,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
          Semantics(
            label: 'Botón para cerrar este popup de información de la escultura y volver al mapa principal',
            hint: 'Toca para cerrar esta ventana y regresar al mapa',
            button: true,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacing),
                  child: Icon(
                    Icons.close_outlined,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchDirectionsMap(
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    String url = AppConstants.googleDirectionsUrl;
    String params = '&destination=$destinationLatitude,$destinationLongitude';

    final uri = Uri.parse('$url$params');

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
