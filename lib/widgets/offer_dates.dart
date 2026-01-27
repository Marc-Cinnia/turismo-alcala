import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/models/language_model.dart';

class OfferDates extends StatelessWidget {
  const OfferDates({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final horizontalSpacer = const SizedBox(width: AppConstants.spacing);

    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: AppConstants.lessContrast);

    final english = context.watch<LanguageModel>().english;

    final startDateLabel = (english)
        ? AppConstants.offerStartDateLabelEn
        : AppConstants.offerStartDateLabel;

    final endDateLabel = (english)
        ? AppConstants.offerEndDateLabelEn
        : AppConstants.offerEndDateLabel;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$startDateLabel:'),
              horizontalSpacer,
              Text(
                offer.startDate,
                style: textStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$endDateLabel:'),
              horizontalSpacer,
              Text(
                offer.endDate,
                style: textStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
