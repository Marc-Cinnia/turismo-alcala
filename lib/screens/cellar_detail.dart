import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
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

class CellarDetail extends StatelessWidget {
  const CellarDetail({
    super.key,
    required this.cellar,
  });

  final Place cellar;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: AppConstants.spacing);
    const divider = Divider();

    final english = context.watch<LanguageModel>().english;
    final accessible = context.watch<AccessibleModel>().enabled;

    String placeName = (english) ? cellar.placeNameEn : cellar.placeName;
    String? description = (accessible)
        ? (english)
            ? cellar.shortDescriptionEn
            : cellar.shortDescription
        : (english)
            ? cellar.longDescriptionEn
            : cellar.longDescription;

    final mainImage = (cellar.mainImageUrl != null)
        ? DetailMainImage(imageUrl: cellar.mainImageUrl!)
        : const SizedBox();

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

    final phone = (cellar.phoneNumber!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(cellar.phoneNumber!),
            ],
          )
        : const SizedBox();

    final phone2 = (cellar.phoneNumber2!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(cellar.phoneNumber2!),
            ],
          )
        : const SizedBox();

    final email = (cellar.email!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.email_outlined,
                color: AppConstants.primary,
              ),
              const SizedBox(width: AppConstants.spacing),
              Text(cellar.email!),
            ],
          )
        : const SizedBox();

    final website = (cellar.websiteUrl!.isNotEmpty)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.link_rounded,
                  color: AppConstants.lessContrast,
                ),
                onTap: () => WebsiteLauncher.launchWebsite(cellar.websiteUrl!),
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
                onTap: () => WebsiteLauncher.launchWebsite(cellar.websiteUrl!),
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

    final gallery = (cellar.imageUrls!.isNotEmpty)
        ? Column(
            children: [
              spacer,
              Gallery(
                imageUrls: cellar.imageUrls!,
              ),
              spacer,
            ],
          )
        : const SizedBox();

    final offers =
        (cellar.activeOffers != null && cellar.activeOffers!.isNotEmpty)
            ? Offers(item: cellar)
            : const SizedBox();

    final ratingPanel = RatingPanel(cellarId: cellar.placeId);

    // Funcionalidad de estrella deshabilitada
    
    final wishlistButton = WishlistButton(
      place: cellar,
      isTextButton: true,
    );
    

    Widget reservationForm = const SizedBox();

    Widget map = const SizedBox();

    Widget videoSection = const SizedBox();

    if (cellar.canReserve != null && cellar.canReserve!) {
      reservationForm = ReservationForm(cellarId: cellar.placeId);
    }

    if (cellar.latitude != null && cellar.longitude != null) {
      map = SizedBox(
        height: AppConstants.mapHeight,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  cellar.latitude!,
                  cellar.longitude!,
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
                        cellar.latitude!,
                        cellar.longitude!,
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

    if (cellar.videoUrl != null) {
      videoSection = VideoSection(videoUrl: cellar.videoUrl!);
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
                spacer,
                divider,
                spacer,
                contactSection,
                spacer,
                divider,
                map,
                spacer,
                gallery,
                spacer,
                offers,
                spacer,
                videoSection,
                spacer,
                reservationForm,
                spacer,
                ratingPanel,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
