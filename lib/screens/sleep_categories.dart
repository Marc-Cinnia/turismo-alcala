import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/hotel.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/screens/sleep_pre_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

/// Categories Screen for "Where to Sleep" section
class SleepCategories extends StatefulWidget {
  SleepCategories({
    super.key,
    required this.accessible,
  });

  static const allCategories = 0;
  final bool accessible;

  @override
  State<SleepCategories> createState() => _SleepCategoriesState();
}

class _SleepCategoriesState extends State<SleepCategories> {
  late bool _hasData;
  late Set<PlaceCategory> _categoriesEn;
  late Set<PlaceCategory> _categories;
  late List<Hotel> _hotels;

  @override
  void initState() {
    super.initState();
    _hasData = false;
    _categoriesEn = {};
    _categories = {};
    _hotels = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasData = Provider.of<SleepModel>(context).hasData;
    _categoriesEn = Provider.of<SleepModel>(context).categoriesEn;
    _categories = Provider.of<SleepModel>(context).categories;
    _hotels = Provider.of<SleepModel>(context).placesToRest;
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();

    final whereToSleepLabel = (language.english)
        ? AppConstants.whereToSleepLabelEn
        : AppConstants.whereToSleepLabel;

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
          value: whereToSleepLabel,
          accessible: widget.accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: Builder(
        builder: (context) {
          if (_hasData) {
            final whereToSleepDescription = (language.english)
                ? AppConstants.whereToSleepDescriptionEn
                : AppConstants.whereToSleepDescription;

            final categories = (language.english) ? _categoriesEn : _categories;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacing,
                        left: AppConstants.spacing,
                        right: AppConstants.spacing,
                      ),
                      child: Text(
                        whereToSleepDescription,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildListItems(
                        context,
                        categories.toList(),
                        _hotels,
                        language,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: LoaderBuilder.getLoader());
        },
      ),
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    List<PlaceCategory> categories,
    List<Hotel> hotels,
    LanguageModel language,
  ) {
    return List.generate(
      categories.length,
      (index) {
        final category = categories[index];
        final name = category.name;

        return GestureDetector(
          child: Card(
            color: AppConstants.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.cardSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppConstants.primary),
                  ),
                  const SizedBox(
                    width: 30.0,
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: AppConstants.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            final screen = SleepPreDetail(
              hotels: _getHotels(category.id, hotels),
              accessible: widget.accessible,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => screen,
              ),
            );
          },
        );
      },
    );
  }

  List<Hotel> _getHotels(int categoryId, List<Hotel> hotels) {
    if (categoryId != SleepCategories.allCategories) {
      return hotels
          .where(
            (hotel) => hotel.category?.id == categoryId,
          )
          .toList();
    }

    return hotels;
  }
}
