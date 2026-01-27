import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/valdeiglesias_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class ValdeiglesiasGallery extends StatelessWidget {
  const ValdeiglesiasGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ValdeiglesiasModel>();

    if (model.content != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: AppConstants.carouselHeight,
                child: PageView.builder(
                  itemCount: model.content?.imageUrls.length,
                  itemBuilder: (context, index) {
                    List<Widget> pages = _getPages(
                      context,
                      model.content?.imageUrls.length ?? 0,
                      model.content?.imageUrls[index] ?? '',
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

    return Center(child: LoaderBuilder.getLoader());
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
