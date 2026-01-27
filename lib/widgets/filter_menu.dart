import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class FilterMenu extends StatelessWidget {
  const FilterMenu({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  final Set<PlaceCategory> categories;
  final ValueChanged onSelected;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry> entries = [];

    if (categories.isNotEmpty) {
      for (var category in categories) {
        final categoryLabel = category.name;

        entries.add(
          DropdownMenuEntry<int>(
            value: category.id,
            label: categoryLabel,
            labelWidget: Text(
              categoryLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.primary,
                  ),
            ),
          ),
        );
      }

      final hintText = categories.first.name;

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        elevation: AppConstants.cardElevation,
        child: DropdownMenu(
          dropdownMenuEntries: entries,
          hintText: hintText,
          width: MediaQuery.of(context).size.width,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            hintStyle: const TextStyle(
              color: AppConstants.label,
            ),
          ),
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppConstants.label,
          ),
          onSelected: onSelected,
        ),
      );
    }

    return Center(child: LoaderBuilder.getLoader());
  }
}
