import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/screens/offer_detail.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/login_form.dart';

class Offers extends StatelessWidget {
  const Offers({
    super.key,
    required this.item,
  });

  final Place item;

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: AppConstants.spacing);
    final language = context.watch<LanguageModel>();
    Widget content = const SizedBox();

    final activeOffersLabel = (language.english)
        ? AppConstants.activeOffersLabelEn
        : AppConstants.activeOffersLabel;

    int offersNumber = 0;

    if (item.activeOffers != null && item.activeOffers!.isNotEmpty) {
      offersNumber = item.activeOffers!.length;
    }

    content = Column(
      children: [
        Title(
          activeOffersLabel: activeOffersLabel,
          offersNumber: offersNumber,
        ),
        spacer,
        OffersList(item: item),
      ],
    );

    return content;
  }
}

class OffersList extends StatelessWidget {
  const OffersList({
    super.key,
    required this.item,
  });

  final Place item;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final session = context.watch<SessionModel>();

    Widget content = const SizedBox();

    if (item.activeOffers != null && item.activeOffers!.isNotEmpty) {
      content = Column(
        children: List.generate(
          item.activeOffers!.length,
          (index) {
            final spacer = const SizedBox(height: AppConstants.spacing);
            final name = (language.english)
                ? item.activeOffers![index].nameEn
                : item.activeOffers![index].name;
            final description = (language.english)
                ? item.activeOffers![index].shortDescEn
                : item.activeOffers![index].shortDesc;

            final offer = item.activeOffers![index];

            return GestureDetector(
              onTap: () {
                if (session.isActive) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfferDetail(offer: offer),
                    ),
                  );
                } else {
                  final offersMessage = (language.english)
                      ? AppConstants.offersMessageEn
                      : AppConstants.offersMessage;
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => LoginForm(
                      descriptionMessage: offersMessage,
                    ),
                  ).then(
                    (_) async {
                      if (session.isActive) {
                        String loginMsg = (language.english)
                            ? AppConstants.succesfulLoginEn
                            : AppConstants.succesfulLogin;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loginMsg),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfferDetail(offer: offer),
                          ),
                        );
                      }
                    },
                  );
                }
              },
              child: Card(
                color: AppConstants.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.cardSpacing),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.thumbnailBorderRadius,
                          ),
                          child: SuperNetworkImage(
                            url: offer.imageUrl,
                            width: AppConstants.thumbnailWidth,
                            height: AppConstants.thumbnailHeight,
                            fit: BoxFit.fitHeight,
                            placeholderBuilder: () =>
                                Center(child: LoaderBuilder.getLoader()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: AppConstants.cardSpacing,
                              right: AppConstants.cardSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppConstants.primary,
                                      ),
                                ),
                                spacer,
                                Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return content;
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
    required this.activeOffersLabel,
    required this.offersNumber,
  });

  final String activeOffersLabel;
  final int offersNumber;

  @override
  Widget build(BuildContext context) {
    final offersSection = (offersNumber > 0)
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.spacing,
                  left: AppConstants.spacing,
                  right: AppConstants.spacing,
                ),
                child: Text(
                  activeOffersLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: AppConstants.shortSpacing),
              Text(
                '($offersNumber)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ],
          )
        : const SizedBox();

    return offersSection;
  }
}
