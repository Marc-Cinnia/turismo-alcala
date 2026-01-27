import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/places_categories.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/screens/place_pre_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

/// Categories Screen for "What to Visit" section
class PlacesCategoriesScreen extends StatefulWidget {
  const PlacesCategoriesScreen({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<PlacesCategoriesScreen> createState() => _PlacesCategoriesScreenState();
}

class _PlacesCategoriesScreenState extends State<PlacesCategoriesScreen> {
  late PlacesCategories? screenData;
  late bool _english;
  late String _appBarTitle;
  late String _description;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _english = context.watch<LanguageModel>().english;
    _description = (_english)
        ? AppConstants.visitDescriptionEn
        : AppConstants.visitDescription;

    _appBarTitle =
        (_english) ? AppConstants.visitLabelEn : AppConstants.visitLabel;

    screenData = context.watch<VisitModel>().placesCategories;

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
          value: _appBarTitle,
          accessible: widget.accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: Builder(
        builder: (context) {
          final categories = (_english)
              ? screenData?.categoriesEn ?? {}
              : screenData?.categories ?? {};

          if (screenData != null) {
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
                        _description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildListItems(
                        context,
                        categories,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: LoaderBuilder.getLoader());
          }
        },
      ),
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    Set<PlaceCategory> categories,
  ) {
    final catList = categories.map((category) => category).toList();

    return List.generate(
      catList.length,
      (index) {
        final category = catList[index];

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
                    category.name,
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
            final screen = PlacePreDetail(
              places: _getPlaces(category.id),
              placesEn: _getPlacesEn(category.id),
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

  List<Place> _getPlaces(int categoryId) {
    // Si está en inglés, usar lugares en inglés
    List<Place> basePlaces = (_english && screenData?.placesEn != null && screenData!.placesEn.isNotEmpty)
        ? screenData!.placesEn
        : screenData?.places ?? [];

    if (categoryId != 0) {
      basePlaces = basePlaces
          .where((place) => place.categoryId == categoryId)
          .toList();
    }

    return basePlaces;
  }

  List<Place> _getPlacesEn(int categoryId) {
    // Si está en inglés, usar lugares en inglés, sino usar español como fallback
    List<Place> basePlaces = (_english && screenData?.placesEn != null && screenData!.placesEn.isNotEmpty)
        ? screenData!.placesEn
        : screenData?.places ?? [];

    if (categoryId != 0) {
      basePlaces = basePlaces
          .where((place) => place.categoryId == categoryId)
          .toList();
    }

    return basePlaces;
  }
}
