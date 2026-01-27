import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/store.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/empty_gallery.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/offers.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/video_section.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; //Funcionalidad de estrella deshabilitada

/// Screen that contains the detail info for
/// a place where user can shop
class ShopDetail extends StatelessWidget {
  const ShopDetail({
    super.key,
    required this.item,
    required this.accessible,
  });

  final Store item;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    const divider = Divider();
    const spacer = const SizedBox(height: AppConstants.spacing);
    final language = context.watch<LanguageModel>();

    Widget placeSchedule = const SizedBox();
    String holidays = (language.english)
        ? AppConstants.noVacationDataLabelEn
        : AppConstants.noVacationDataLabel;
    Widget map = const SizedBox();
    Widget videoSection = const SizedBox();

    if (item.schedule != null && item.schedule!.isNotEmpty) {
      List<Widget> days = [];

      item.schedule!.forEach((day, hourRange) {
        days.add(
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$day:'),
              Text(hourRange),
            ],
          ),
        );
      });

      if (item.holidays != null && item.holidays!.isNotEmpty) {
        String holidaysContent = (language.english)
            ? '${AppConstants.vacationDataLabelEn}: ${item.holidays!}'
            : '${AppConstants.vacationDataLabel}: ${item.holidays!}';

        holidays = holidaysContent;
      }

      final scheduleTitle = (language.english)
          ? AppConstants.scheduleTitleEn
          : AppConstants.scheduleTitle;

      placeSchedule = Column(
        children: [
          divider,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              scheduleTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          spacer,
          Column(
            children: List.generate(
              days.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacing),
                child: days[index],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              holidays,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          divider,
        ],
      );
    }

    final storeName = (language.english) ? item.placeNameEn : item.placeName;

    String description = item.longDescription ?? '';

    if (language.english) {
      description = item.longDescriptionEn ?? '';

      if (accessible) {
        if (item.shortDescriptionEn != null) {
          description = item.shortDescriptionEn!;
        }
      }
    }

    if (item.latitude != null && item.longitude != null) {
      map = SizedBox(
        height: AppConstants.mapHeight,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  item.latitude!,
                  item.longitude!,
                ),
                initialZoom: AppConstants.mapInitialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: AppConstants.urlTemplate,
                  userAgentPackageName: AppConstants.userAgentPackageName,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        item.latitude!,
                        item.longitude!,
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
    }

    Widget gallery = const SizedBox();

    if (item.imageGallery.isNotEmpty) {
      gallery = Gallery(
        imageUrls: List.generate(
          item.imageGallery.length,
          (index) => item.imageGallery[index].imageUrl,
        ),
      );
    }

    if (item.videoUrl != null) {
      videoSection = VideoSection(videoUrl: item.videoUrl);
    }

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Botón para volver a la lista de tiendas',
          hint: 'Toca para regresar a la lista de tiendas',
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
          label: 'Título de la tienda: $storeName',
          child: DynamicTitle(value: storeName, accessible: accessible),
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
                  label: 'Imagen principal de la tienda $storeName',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    child: SuperNetworkImage(
                      url: item.mainImageUrl,
                      height: AppConstants.carouselHeight,
                      placeholderBuilder: () => Center(
                        child: LoaderBuilder.getLoader(),
                      ),
                    ),
                  ),
                ),
                spacer,
                Semantics(
                  label: 'Descripción de la tienda: $description',
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.spacing,
                      left: AppConstants.spacing,
                      right: AppConstants.spacing,
                    ),
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                spacer,
                Semantics(
                  label: 'Dirección de la tienda: ${item.address}',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppConstants.lessContrast,
                      ),
                      const SizedBox(width: AppConstants.shortSpacing),
                      Expanded(
                        child: Text(
                          item.address!,
                          style:
                              const TextStyle(color: AppConstants.lessContrast),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                spacer,
                WishlistButton(place: item, isTextButton: true), //Funcionalidad de estrella deshabilitada
                spacer,
                placeSchedule,
                Semantics(
                  label: 'Enlaces a sitio web y redes sociales de la tienda',
                  child: Row(
                    children: [
                      WebsiteLauncher.socialNetworkButton(
                        const Icon(
                          Icons.language_outlined,
                          color: AppConstants.lessContrast,
                        ),
                        item.websiteUrl!,
                      ),
                      WebsiteLauncher.socialNetworkButton(
                        const Icon(
                          Icons.language_outlined,
                          color: AppConstants.lessContrast,
                        ),
                        item.websiteUrl!,
                      ),
                      WebsiteLauncher.socialNetworkButton(
                        const Icon(
                          FontAwesomeIcons.instagram,
                          color: AppConstants.lessContrast,
                        ),
                        item.instagramUrl,
                      ),
                      WebsiteLauncher.socialNetworkButton(
                        const Icon(
                          FontAwesomeIcons.facebook,
                          color: AppConstants.lessContrast,
                        ),
                        item.facebookUrl,
                      ),
                      WebsiteLauncher.socialNetworkButton(
                        const Icon(
                          FontAwesomeIcons.twitter,
                          color: AppConstants.lessContrast,
                        ),
                        item.twitterUrl,
                      ),
                    ],
                  ),
                ),
                spacer,
                map,
                spacer,
                videoSection,
                spacer,
                Semantics(
                  label: 'Ofertas y promociones de la tienda',
                  child: Offers(item: item),
                ),
                spacer,
                const Divider(),
                spacer,
                Semantics(
                  label: 'Galería de imágenes de la tienda',
                  child: gallery,
                ),
                Semantics(
                  label: 'Panel de calificaciones y reseñas de la tienda',
                  child: RatingPanel(shopId: item.placeId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
