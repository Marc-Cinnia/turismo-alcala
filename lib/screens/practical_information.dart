import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/info.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/practical_information_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/detail_main_image.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';

class PracticalInformation extends StatelessWidget {
  const PracticalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final english = context.watch<LanguageModel>().english;
    final infoModel = context.watch<PracticalInformationModel>();
    final accessible = context.watch<AccessibleModel>();
    const spacer = const SizedBox(height: AppConstants.spacing);
    const divider = const Divider();

    Widget appBarTitle = const SizedBox();
    Widget mainImage = const SizedBox();
    Widget mainTitle = const SizedBox();
    Widget description = const SizedBox();
    Widget gallery = const SizedBox();

    Widget mainContent = Center(child: LoaderBuilder.getLoader());

    if (infoModel.hasData) {
      Info data = infoModel.info!;

      String title = (english) ? data.titleEn : data.title;
      String subtitle = (english) ? data.subtitle1En : data.subtitle1;
      String descText = (english) ? data.descriptionEn : data.description;

      appBarTitle = DynamicTitle(
        value: title,
        accessible: accessible.enabled,
      );

      mainImage = DetailMainImage(imageUrl: data.imageUrl);
      mainTitle = ContentBuilder.getTitle(subtitle, context);
      description = Text(
        descText,
        textAlign: TextAlign.left,
      );

      if (data.galleryImages.isNotEmpty) {
        gallery = Gallery(imageUrls: data.galleryImages);
      }

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
              mainImage,
              spacer,
              divider,
              mainTitle,
              spacer,
              description,
              spacer,
              divider,
              gallery,
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
}
