import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/hotel.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/offers.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/reservation_form.dart';
import 'package:valdeiglesias/widgets/social_network_button.dart';
import 'package:valdeiglesias/widgets/video_section.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

/// Detail Screen for "where to sleep" section
class SleepDetail extends StatelessWidget {
  const SleepDetail({
    super.key,
    required this.item,
    required this.accessible,
  });

  final Hotel item;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    const spacer = const SizedBox(height: AppConstants.spacing);
    const divider = const Divider();
    final language = context.watch<LanguageModel>();
    final session = context.watch<SessionModel>();

    Widget placeSchedule = const SizedBox();
    List<Widget> days = [];
    List<Widget> daysEn = [];
    String scheduleTitle = (language.english)
        ? AppConstants.scheduleTitleEn
        : AppConstants.scheduleTitle;
    Widget videoSection = const SizedBox();
    Widget reservationForm = const SizedBox();
    Widget map = const SizedBox();

    final bookingButton = _getSocialNetworkButton(
      item.bookingUrl!,
      const Icon(
        Icons.book_online_outlined,
        color: AppConstants.lessContrast,
      ),
    );
    final webButton = _getSocialNetworkButton(
      item.websiteUrl ?? '',
      const Icon(
        Icons.language_outlined,
        color: AppConstants.lessContrast,
      ),
    );
    final igButton = _getSocialNetworkButton(
      item.instagramUrl!,
      const Icon(
        FontAwesomeIcons.instagram,
        color: AppConstants.lessContrast,
      ),
    );
    final fbButton = _getSocialNetworkButton(
      item.facebookUrl!,
      const Icon(
        FontAwesomeIcons.facebook,
        color: AppConstants.lessContrast,
      ),
    );
    final twitterBtn = _getSocialNetworkButton(
      item.twitterUrl!,
      const Icon(
        FontAwesomeIcons.twitter,
        color: AppConstants.lessContrast,
      ),
    );

    String description = '';

    String vacationLabel = (language.english)
        ? AppConstants.noVacationDataLabelEn
        : AppConstants.noVacationDataLabel;

    Widget vacationText = const SizedBox();

    bool descriptionsAvailable = item.shortDescriptionEn != null &&
        item.shortDescription != null &&
        item.longDescriptionEn != null &&
        item.longDescription != null;

    if (descriptionsAvailable) {
      if (accessible) {
        description = (language.english)
            ? item.shortDescriptionEn!
            : item.shortDescription!;
      } else {
        description = (language.english)
            ? item.longDescriptionEn!
            : item.longDescription!;
      }
    }

    if (item.schedule != null && item.schedule!.isNotEmpty) {
      item.schedule!.forEach(
        (day, hourRange) {
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
        },
      );
    } else {
      vacationText = Align(
        alignment: Alignment.centerLeft,
        child: Text(
          vacationLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppConstants.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    if (item.scheduleEn != null && item.scheduleEn!.isNotEmpty) {
      item.scheduleEn!.forEach((day, hourRange) {
        daysEn.add(
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
    } else {
      vacationText = Align(
        alignment: Alignment.centerLeft,
        child: Text(
          vacationLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppConstants.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

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
            (language.english) ? daysEn.length : days.length,
            (index) {
              final day = (language.english) ? daysEn[index] : days[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacing),
                child: day,
              );
            },
          ),
        ),
        vacationText,
      ],
    );

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

    if (item.videoUrl != null && item.videoUrl!.isNotEmpty) {
      videoSection = Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppConstants.videoSectionLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing),
          VideoSection(videoUrl: item.videoUrl!),
          const SizedBox(height: AppConstants.spacing),
        ],
      );
    }

    if (item.canReserve != null && item.canReserve!) {
      reservationForm = ReservationForm(hotelId: item.placeId);
    }

    Widget mainImage = (item.mainImageUrl != null)
        ? SuperNetworkImage(
            url: item.mainImageUrl!,
            height: AppConstants.carouselHeight,
            placeholderBuilder: () => Center(
              child: LoaderBuilder.getLoader(),
            ),
          )
        : const SizedBox();

    Widget gallery = const SizedBox();

    if (item.imageGallery.isNotEmpty) {
      gallery = Gallery(
        imageUrls: List.generate(item.imageGallery.length,
            (index) => item.imageGallery[index].imageUrl),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Botón para volver a la lista de hoteles',
          hint: 'Toca para regresar a la lista de hoteles',
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
          label: 'Título del hotel: ${item.placeName}',
          child: DynamicTitle(value: item.placeName, accessible: accessible),
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
                  label: 'Imagen principal del hotel ${item.placeName}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    child: mainImage,
                  ),
                ),
                spacer,
                Semantics(
                  label: 'Descripción del hotel: $description',
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.spacing,
                      left: AppConstants.spacing,
                      right: AppConstants.spacing,
                    ),
                    child: Text(
                      description,
                      style: (accessible)
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                spacer,
                Semantics(
                  label: 'Dirección del hotel: ${item.address}',
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
                spacer,
                map,
                spacer,
                VideoSection(videoUrl: item.videoUrl),
                spacer,
                Semantics(
                  label: 'Enlaces de reserva, sitio web y redes sociales del hotel',
                  child: Row(
                    children: [
                      bookingButton,
                      webButton,
                      igButton,
                      fbButton,
                      twitterBtn,
                    ],
                  ),
                ),
                spacer,
                Semantics(
                  label: 'Ofertas y promociones del hotel',
                  child: Offers(item: item),
                ),
                spacer,
                divider,
                Semantics(
                  label: 'Galería de imágenes del hotel',
                  child: gallery,
                ),
                spacer,
                Semantics(
                  label: 'Sección de video del hotel',
                  child: videoSection,
                ),
                spacer,
                Semantics(
                  label: 'Formulario de reserva',
                  child: reservationForm,
                ),
                Semantics(
                  label: 'Panel de calificaciones y reseñas del hotel',
                  child: RatingPanel(hotelId: item.placeId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSocialNetworkButton(String url, Icon icon) {
    if (url.isNotEmpty) {
      return SocialNetworkButton(
        url: url,
        icon: icon,
      );
    }

    return const SizedBox();
  }
}
