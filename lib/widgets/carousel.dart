import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/card_item.dart';
import 'package:valdeiglesias/models/card_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late List<CardItem> pages;
  late FlutterCarouselOptions carouselOptions;

  @override
  void initState() {
    carouselOptions = FlutterCarouselOptions(
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      height: AppConstants.carouselHeight,
      viewportFraction: 1.0,
      floatingIndicator: true,
      indicatorMargin: AppConstants.spacing,
      slideIndicator: CircularWaveSlideIndicator(
        slideIndicatorOptions: const SlideIndicatorOptions(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = context.watch<CardModel>().items;
    final english = context.watch<LanguageModel>().english;

    if (english) {
      pages = context.watch<CardModel>().itemsEn;
    }

    return Center(
      child: FlutterCarousel(
        items: _getPages(pages),
        options: carouselOptions,
      ),
    );
  }

  /// Returns the items in carousel rendered as each page
  List<Widget> _getPages(List<CardItem> cardItems) {
    return List.generate(
      cardItems.length,
      (index) {
        return CarouselPage(item: cardItems[index]);
      },
    );
  }
}

class CarouselPage extends StatefulWidget {
  const CarouselPage({
    super.key,
    required this.item,
  });

  final CardItem item;

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  Widget cardContent = const SizedBox();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.item.relatedUrl.isNotEmpty) {
          WebsiteLauncher.launchWebsite(widget.item.relatedUrl);
        }
      },
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
              child: SizedBox(
                height: AppConstants.carouselHeight,
                child: SuperNetworkImage(
                  url: widget.item.imageUrl,
                  height: AppConstants.carouselHeight,
                  placeholderBuilder: () => Center(
                    child: LoaderBuilder.getLoader(),
                  ),
                  fit: BoxFit.fitHeight,
                  onLoad: (source) {
                    setState(
                      () {
                        cardContent = Positioned(
                          left: 20.0,
                          right: 20.0,
                          bottom: 60.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.item.subtitle,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                widget.item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.white),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            cardContent,
          ],
        ),
      ),
    );
  }
}
