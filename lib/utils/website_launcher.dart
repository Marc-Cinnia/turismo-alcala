import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteLauncher {
  static Future<void> launchWebsite(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static Widget socialNetworkButton(Icon icon, String url) {
    return GestureDetector(
      onTap:
          (url.isNotEmpty) ? () => WebsiteLauncher.launchWebsite(url) : () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            color: Colors.white,
          ),
          child: icon,
        ),
      ),
    );
  }
}
