import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/place_detail.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class PlaceBottomSheet extends StatelessWidget {
  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.placeEn,
  });

  final Place place;
  final Place? placeEn;

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

    final String description = (language.english)
        ? placeEn?.shortDescriptionEn ?? AppConstants.valueNotAvailableEn
        : place.shortDescription ?? AppConstants.valueNotAvailable;

    final name = (language.english) ? placeEn!.placeName : place.placeName;

    final modalArriveLabel = (language.english)
        ? AppConstants.modalArriveLabelEn
        : AppConstants.modalArriveLabel;

    final modalDetailLabel = (language.english)
        ? AppConstants.modalDetailLabelEn
        : AppConstants.modalDetailLabel;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: sheetBorderRadius,
              child: LayoutBuilder(
                builder: (context, constraints) => SuperNetworkImage(
                  url: place.mainImageUrl!,
                  width: constraints.maxWidth,
                  height: AppConstants.mapBottomSheetImgHeight,
                  fit: BoxFit.fill,
                  placeholderBuilder: () => Center(
                    child: LoaderBuilder.getLoader(),
                  ),
                ),
              ),
            ),
            Align(
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
            Align(
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
            spacer,
            Container(
              margin: const EdgeInsets.only(
                top: AppConstants.spacing,
                right: AppConstants.spacing,
                bottom: AppConstants.spacing,
              ),
              child: OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      if (place.latitude != null && place.longitude != null) {
                        _launchDirectionsMap(
                          place.latitude!,
                          place.longitude!,
                        );
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
                  const SizedBox(width: AppConstants.spacing),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlaceDetail(
                            place: place,
                            placeEn: place,
                            accessible: false,
                          ),
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
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.spacing),
              child: Icon(
                Icons.close_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
