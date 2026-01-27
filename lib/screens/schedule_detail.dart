import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/event.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/download_button.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

class ScheduleDetail extends StatelessWidget {
  const ScheduleDetail({
    super.key,
    required this.event,
    required this.accessible,
  });

  final Event event;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    final downloadButton = _getDownloadButton();
    Widget gallery = const SizedBox();

    if (event.imageGallery.isNotEmpty) {
      gallery = Gallery(imageUrls: event.imageGallery);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: event.placeName, accessible: accessible),
        centerTitle: true,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  child: SuperNetworkImage(
                    url: event.mainImageUrl,
                    height: AppConstants.carouselHeight,
                    placeholderBuilder: () => Center(
                      child: LoaderBuilder.getLoader(),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${event.startDate} - ${event.endDate}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.contrast,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    event.eventAddress,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppConstants.lessContrast),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing),
                WishlistButton(place: event, isTextButton: true), //Funcionalidad de estrella deshabilitada
                const SizedBox(height: AppConstants.spacing),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing,
                    left: AppConstants.spacing,
                    right: AppConstants.spacing,
                  ),
                  child: Text(
                    (accessible)
                        ? event.shortDescription!
                        : event.longDescription!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing),
                downloadButton,
                const SizedBox(height: AppConstants.spacing),
                const Divider(),
                Builder(
                  builder: (context) {
                    if (event.latitude == 0.0 || event.longitude == 0.0) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(Icons.map_outlined,
                                  color: AppConstants.lessContrast),
                              const SizedBox(width: AppConstants.spacing),
                              Text(
                                AppConstants.locNotAvailableLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: AppConstants.lessContrast),
                              ),
                            ],
                          ));
                    }
                    return SizedBox(
                      height: AppConstants.mapHeight,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                event.latitude!,
                                event.longitude!,
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
                                      event.latitude!,
                                      event.longitude!,
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
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacing),
                const Divider(),
                const SizedBox(height: AppConstants.spacing),
                gallery,
                RatingPanel(
                  drupalId: event.placeId,
                  drupalType: AppConstants.drupalEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDownloadButton() {
    if (event.pdfUrl.isEmpty) {
      return const SizedBox();
    }

    return DownloadButton(downloadUrl: event.pdfUrl);
  }
}
