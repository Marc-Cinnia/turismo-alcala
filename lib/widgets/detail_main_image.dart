import 'package:flutter/material.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class DetailMainImage extends StatelessWidget {
  const DetailMainImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppConstants.borderRadius,
      ),
      child: SizedBox(
        height: AppConstants.carouselHeight,
        child: SuperNetworkImage(
          url: imageUrl,
        ),
      ),
    );
  }
}
