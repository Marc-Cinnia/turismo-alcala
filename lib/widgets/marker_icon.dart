import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({
    super.key,
    required this.placeName,
    required this.placeImage,
    required this.sectionRoute,
  });

  final String placeName;
  final String placeImage;
  final String sectionRoute;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(AppConstants.mapMarkerIconPaths[sectionRoute]!),
    );
  }
}
