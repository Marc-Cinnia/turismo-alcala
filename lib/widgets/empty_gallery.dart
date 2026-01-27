import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';

class EmptyGallery extends StatelessWidget {
  const EmptyGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const spacer = const SizedBox(height: AppConstants.spacing);
    final language = context.watch<LanguageModel>();

    final imagesGalleryLabel = (language.english)
        ? AppConstants.imagesGalleryLabelEn
        : AppConstants.imagesGalleryLabel;

    final galleryNotAvailableLabel = (language.english)
        ? AppConstants.galleryNotAvailableLabelEn
        : AppConstants.galleryNotAvailableLabel;

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                imagesGalleryLabel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          spacer,
          Text(
            galleryNotAvailableLabel,
          ),
        ],
      ),
    );
  }
}
