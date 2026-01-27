import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final title = (language.english)
        ? AppConstants.imagesGalleryLabelEn
        : AppConstants.imagesGalleryLabel;
    const spacer = const SizedBox(height: AppConstants.spacing);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            spacer,
            SizedBox(
              height: AppConstants.carouselHeight,
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  List<Widget> pages = _getPages(
                    context,
                    imageUrls.length,
                    imageUrls[index],
                  );
                  return pages[index % pages.length];
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Returns the items in carousel rendered as each page
  List<Widget> _getPages(BuildContext context, int numPages, String imageUrl) {
    return List.generate(numPages, (index) {
      return SizedBox(
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppConstants.borderRadius),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: SuperNetworkImage(
              url: imageUrl,
              placeholderBuilder: () => Center(
                child: LoaderBuilder.getLoader(),
              ),
            ),
          ),
        ),
      );
    });
  }
}
