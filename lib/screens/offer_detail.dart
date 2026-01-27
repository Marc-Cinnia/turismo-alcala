import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/detail_main_image.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/offer_dates.dart';
import 'package:valdeiglesias/widgets/offer_qr_code.dart';

class OfferDetail extends StatelessWidget {
  const OfferDetail({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: AppConstants.spacing);
    const divider = Divider();
    
    final english = context.watch<LanguageModel>().english;
    final accessibleModel = context.watch<AccessibleModel>();

    final name = (english) ? offer.nameEn : offer.name;
    final descriptionText = (english) ? offer.longDescEn : offer.longDescEn;
    final descriptionSection = Text(
      descriptionText,
      textAlign: TextAlign.justify,
    );
    final detailMainImage = DetailMainImage(imageUrl: offer.imageUrl);
    final offerDates = OfferDates(offer: offer);
    final offerQRCode = OfferQRCode(offer: offer);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(
          value: name,
          accessible: accessibleModel.enabled,
        ),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            top: AppConstants.spacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Center(
            child: Column(
              children: [
                detailMainImage,
                spacer,
                divider,
                spacer,
                descriptionSection,
                spacer,
                divider,
                spacer,
                offerDates,
                spacer,
                divider,
                spacer,
                offerQRCode,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
