import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/detail_main_image.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/offers.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/reservation_form.dart';
import 'package:valdeiglesias/widgets/video_section.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

class GuidedToursDetail extends StatelessWidget {
  const GuidedToursDetail({
    super.key,
    required this.accessible,
    required this.tour,
    required this.tourEn,
  });

  final bool accessible;
  final Place tour;
  final Place tourEn;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: AppConstants.spacing);
    const divider = Divider();

    final english = context.watch<LanguageModel>().english;

    String placeName = (english) ? tourEn.placeName : tour.placeName;
    String? description = (accessible)
        ? (english)
            ? tourEn.shortDescription
            : tour.shortDescription
        : (english)
            ? tourEn.longDescription
            : tour.longDescription;

    final mainImage = DetailMainImage(imageUrl: tour.mainImageUrl!);

    final descriptionSection = (description != null)
        ? Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Text(
              description,
              textAlign: TextAlign.justify,
            ),
          )
        : const SizedBox();

    final phone = (tour.phoneNumber!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(tour.phoneNumber!),
            ],
          )
        : const SizedBox();

    final phone2 = (tour.phoneNumber2!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(tour.phoneNumber2!),
            ],
          )
        : const SizedBox();

    final email = (tour.email!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.email_outlined,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(tour.email!),
            ],
          )
        : const SizedBox();

    final website = (tour.websiteUrl!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.link_rounded,
                  color: AppConstants.lessContrast,
                ),
                onTap: () => WebsiteLauncher.launchWebsite(tour.websiteUrl!),
              ),
              const SizedBox(width: AppConstants.spacing),
              GestureDetector(
                child: Text(
                  (english)
                      ? AppConstants.websiteLabelEn
                      : AppConstants.websiteLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.lessContrast,
                      ),
                ),
                onTap: () => WebsiteLauncher.launchWebsite(tour.websiteUrl!),
              ),
            ],
          )
        : const SizedBox();

    final contactSection = Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            (english)
                ? AppConstants.contactSectionTitleEn
                : AppConstants.contactSectionTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        spacer,
        phone,
        spacer,
        phone2,
        spacer,
        email,
        spacer,
        website,
      ],
    );

    final gallery = (tour.imageUrls!.isNotEmpty)
        ? Column(
            children: [
              spacer,
              Gallery(
                imageUrls: tour.imageUrls!,
              ),
              spacer,
            ],
          )
        : const SizedBox();

    final ratingPanel = RatingPanel(tourId: tour.placeId);

    final wishlistButton = WishlistButton(place: tour, isTextButton: true); // Funcionalidad de estrella deshabilitada

    final offers = (tour.activeOffers != null && tour.activeOffers!.isNotEmpty)
        ? Offers(item: tour)
        : const SizedBox();

    Widget reservationForm = const SizedBox();

    Widget map = const SizedBox();

    Widget videoSection = const SizedBox();

    if (tour.canReserve != null && tour.canReserve!) {
      reservationForm = ReservationForm(tourId: tour.placeId);
    }

    if (tour.latitude != null && tour.longitude != null) {
      map = SizedBox(
        height: AppConstants.mapHeight,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  tour.latitude!,
                  tour.longitude!,
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
                        tour.latitude!,
                        tour.longitude!,
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

    if (tour.videoUrl != null) {
      videoSection = VideoSection(videoUrl: tour.videoUrl!);
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
        title: DynamicTitle(
          value: placeName,
          accessible: accessible,
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
                mainImage,
                spacer,
                divider,
                spacer,
                descriptionSection,
                spacer,
                divider,
                spacer,
                wishlistButton, // Funcionalidad de estrella deshabilitada
                divider,
                spacer,
                contactSection,
                spacer,
                divider,
                spacer,
                map,
                spacer,
                videoSection,
                spacer,
                gallery,
                spacer,
                divider,
                spacer,
                reservationForm,
                spacer,
                offers,
                spacer,
                ratingPanel,
                spacer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
