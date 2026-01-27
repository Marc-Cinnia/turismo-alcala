import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/incident_model.dart';
import 'package:valdeiglesias/models/language_model.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  late bool _english;

  @override
  Widget build(BuildContext context) {
    _english = context.watch<LanguageModel>().english;

    final addLocationLabel = (_english)
        ? AppConstants.addLocationLabelEn
        : AppConstants.addLocationLabel;

    return OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.add_location_outlined,
            color: AppConstants.contrast,
          ),
          label: Text(
            addLocationLabel,
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
      ],
    );
  }
}
