import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';

class SocialNetworkButton extends StatelessWidget {
  const SocialNetworkButton({
    super.key,
    required this.url,
    required this.icon,
  });

  final String url;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
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
