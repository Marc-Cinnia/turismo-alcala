import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/experience_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/detail_main_image.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/video_section.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

class ExperienceDetail extends StatelessWidget {
  const ExperienceDetail({
    super.key,
    required this.experience,
    required this.experienceEn,
    required this.accessible,
  });

  final ExperienceItem experience;
  final ExperienceItem experienceEn;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    const spacer = const SizedBox(height: AppConstants.spacing);
    const vSpacer = const SizedBox(width: AppConstants.spacing);
    const divider = const Divider();
    final language = context.watch<LanguageModel>();

    Widget videoSection = const SizedBox();
    Widget gallery = const SizedBox();

    final exp = (language.english) ? experienceEn : experience;

    final contactTitle = (language.english)
        ? AppConstants.contactSectionTitleEn
        : AppConstants.contactSectionTitle;
    final websiteLabel = (language.english)
        ? AppConstants.websiteLabelEn
        : AppConstants.websiteLabel;
    ;

    if (exp.imageUrls != null && exp.imageUrls!.isNotEmpty) {
      gallery = Gallery(imageUrls: exp.imageUrls!);
    }

    if (exp.videoUrl != null) {
      videoSection = VideoSection(videoUrl: experience.videoUrl);
    }

    final mainImage = (exp.mainImageUrl != null)
        ? DetailMainImage(imageUrl: exp.mainImageUrl!)
        : const SizedBox();

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
          value: exp.placeName,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing,
                    bottom: AppConstants.spacing,
                    left: AppConstants.spacing,
                    right: AppConstants.spacing,
                  ),
                  child: Text(
                    (accessible) ? exp.shortDescription! : exp.longDescription!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ),
                spacer,
                WishlistButton(place: exp, isTextButton: true), // Funcionalidad de estrella deshabilitada
                spacer,
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing,
                    left: AppConstants.spacing,
                    right: AppConstants.spacing,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      contactTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppConstants.primary),
                    ),
                  ),
                ),
                const Divider(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: AppConstants.primary,
                        ),
                        vSpacer,
                        Text(exp.phoneNumber!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.link_rounded,
                            color: AppConstants.lessContrast,
                          ),
                          onTap: () => WebsiteLauncher.launchWebsite(
                            exp.websiteUrl!,
                          ),
                        ),
                        vSpacer,
                        GestureDetector(
                          child: Text(
                            websiteLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppConstants.lessContrast,
                                ),
                          ),
                          onTap: () => WebsiteLauncher.launchWebsite(
                            exp.websiteUrl!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.gps_fixed_rounded,
                          color: AppConstants.primary,
                        ),
                        vSpacer,
                        Expanded(
                          child: Text(
                            exp.address!,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                spacer,
                SizedBox(
                  height: 400.0,
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            exp.latitude!,
                            exp.longitude!,
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
                                  exp.latitude!,
                                  exp.longitude!,
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
                spacer,
                divider,
                spacer,
                videoSection,
                gallery,
                spacer,
                RatingPanel(
                  drupalId: exp.placeId,
                  drupalType: AppConstants.drupalExperience,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
