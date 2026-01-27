import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/widgets/language_selector.dart';

class ContentBuilder {
  static Widget getTitle(String title, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: AppConstants.primary),
      ),
    );
  }

  /// Creates a List of `actions` for using in Application [AppBar]s
  /// Depending on its `accessible` flag.
  static List<Widget>? getActions() {
    return <Widget>[LanguageSelector()];
  }

  static Set<PlaceCategory> getOrderedCategories(
      Set<PlaceCategory> categories, PlaceCategory categoryAll) {
    List<PlaceCategory> sortedCategories = categories.toList();
    sortedCategories.sort(
      (first, second) => first.name.compareTo(second.name),
    );
    sortedCategories.insert(0, categoryAll);

    return sortedCategories.toSet();
  }

  static Set<PlaceCategory> getProfessionalOrderedCategories(
    Set<PlaceCategory> categories,
    PlaceCategory categoryAll,
  ) {
    List<PlaceCategory> sortedCategories = categories.toList();
    sortedCategories.sort(
      (first, second) => first.name.compareTo(second.name),
    );
    sortedCategories.insert(0, categoryAll);

    return sortedCategories.toSet();
  }
}
