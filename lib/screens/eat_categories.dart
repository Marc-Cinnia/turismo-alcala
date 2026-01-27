import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/food_item.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/eat_pre_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

/// Categories Screen for "Where to Eat" section
class EatCategories extends StatefulWidget {
  EatCategories({
    super.key,
    required this.accessible,
  });

  static const allCategories = 0;
  final bool accessible;

  @override
  State<EatCategories> createState() => _EatCategoriesState();
}

class _EatCategoriesState extends State<EatCategories> {
  late EatModel model;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    model = context.watch<EatModel>();

    String title = (language.english)
        ? AppConstants.whereToEatLabelEn
        : AppConstants.whereToEatLabel;

    String description = (language.english)
        ? AppConstants.whereToEatDescriptionEn
        : AppConstants.whereToEatDescription;

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
          value: title,
          accessible: widget.accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: Builder(
        builder: (context) {
          if (model.hasData) {
            final categories = (language.english)
                ? model.categoriesEn.toList()
                : model.categories.toList();

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
                        description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildListItems(
                        context,
                        categories,
                        model.placesToEat,
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
    List<FoodItem> places,
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
            final screen = EatPreDetail(
              places: _getFilteredPlaces(category.id, places),
              accessible: widget.accessible,
            );

            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => screen),
            );
          },
        );
      },
    );
  }

  List<FoodItem> _getFilteredPlaces(int categoryId, List<FoodItem> places) {
    if (categoryId != EatCategories.allCategories) {
      return places
          .where(
            (place) => place.category?.id == categoryId,
          )
          .toList();
    }

    return places;
  }
}
