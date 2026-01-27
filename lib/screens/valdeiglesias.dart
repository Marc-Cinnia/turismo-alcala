import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/valdeiglesias_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/valdeiglesias_gallery.dart';

class Valdeiglesias extends StatelessWidget {
  const Valdeiglesias({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  Widget build(BuildContext context) {
    final english = context.watch<LanguageModel>().english;
    final valdeiglesiasModel = context.watch<ValdeiglesiasModel>();
    Widget appBarTitle = const SizedBox();
    dynamic mainImage = const SizedBox();
    Widget mainContent = Center(child: LoaderBuilder.getLoader());

    if (valdeiglesiasModel.content != null) {
      appBarTitle = DynamicTitle(
        value: valdeiglesiasModel.content?.title ?? '',
        accessible: accessible,
      );

      mainImage = SuperNetworkImage(
        url: valdeiglesiasModel.content!.mainImageUrl,
        height: AppConstants.carouselHeight,
        placeholderBuilder: () => Center(
          child: LoaderBuilder.getLoader(),
        ),
      );

      mainContent = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.shortSpacing,
            right: AppConstants.shortSpacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacing),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                child: mainImage,
              ),
              const SizedBox(height: AppConstants.spacing),
              ContentBuilder.getTitle(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraphTitle1 ?? ''
                    : valdeiglesiasModel.content?.paragraphTitle1 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              _getParagraph(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraph1 ?? ''
                    : valdeiglesiasModel.content?.paragraph1 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              ContentBuilder.getTitle(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraphTitle2 ?? ''
                    : valdeiglesiasModel.content?.paragraphTitle2 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              _getParagraph(
                  valdeiglesiasModel.content?.paragraph2 ?? '', context),
              const SizedBox(height: AppConstants.spacing),
              ContentBuilder.getTitle(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraphTitle3 ?? ''
                    : valdeiglesiasModel.content?.paragraphTitle3 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              _getParagraph(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraph3 ?? ''
                    : valdeiglesiasModel.content?.paragraph3 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              ContentBuilder.getTitle(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraphTitle4 ?? ''
                    : valdeiglesiasModel.content?.paragraphTitle4 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              _getParagraph(
                (english)
                    ? valdeiglesiasModel.contentEn?.paragraph4 ?? ''
                    : valdeiglesiasModel.content?.paragraph4 ?? '',
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              ContentBuilder.getTitle(
                (english)
                    ? AppConstants.imagesGalleryLabelEn
                    : AppConstants.imagesGalleryLabel,
                context,
              ),
              const SizedBox(height: AppConstants.spacing),
              const ValdeiglesiasGallery(),
              const SizedBox(height: AppConstants.spacing),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: appBarTitle,
        actions: ContentBuilder.getActions(),
      ),
      body: mainContent,
    );
  }

  Widget _getParagraph(String paragraph, BuildContext context) {
    return Text(
      paragraph,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.justify,
    );
  }
}
