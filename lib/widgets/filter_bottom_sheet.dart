import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/models/filter_model.dart';
import 'package:valdeiglesias/models/language_model.dart';

/// A widget that displays a bottom sheet with a list of items for
/// filtering.
///
/// The [FilterBottomSheet] widget allows users to select items from
/// a list and apply filters.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.filterItems,
    required this.filterHotels,
    required this.filterRestaurants,
    this.itemsDescription,
    this.itemsDescriptionEn,
  });

  /// A list of items to be filtered.
  ///
  /// This list contains instances of [FilterItem] that represent the items
  /// available for filtering. It is used to manage and display the filter options
  /// in the UI.
  final List<FilterItem> filterItems;

  /// A description of the items to be filtered.
  ///
  /// This string provides a description of the items that are subject to filtering.
  /// It is used to display information about the items in the UI.
  final String? itemsDescription;
  final String? itemsDescriptionEn;

  final bool filterRestaurants;
  final bool filterHotels;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

/// State class for the [FilterBottomSheet] widget.
///
/// This class manages the state of the bottom sheet content, including the
/// list of items selected for filtering. It provides methods to clear and
/// to apply the selected filters, closing the bottom sheet and passing the
/// selected items back to the previous screen.
class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<FilterItem> _itemsToFilter;
  late Set<FilterItem> _selectedFilters;
  late FilterModel filter;
  late bool _english;

  @override
  void initState() {
    super.initState();
    _english = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<FilterModel>(context, listen: false).userIsFiltering = true;
    _itemsToFilter = Provider.of<FilterModel>(context).filterItems;
    _selectedFilters = Provider.of<FilterModel>(context).selectedFilters;
    _english = context.watch<LanguageModel>().english;
  }

  @override
  Widget build(BuildContext context) {
    filter = context.watch<FilterModel>();

    final title = (_english)
        ? '${AppConstants.serviceFilterLabelEn} '
        : '${AppConstants.serviceFilterLabelEs} ';

    final applyFiltersLabel = (_english)
        ? AppConstants.applyFiltersLabelEn
        : AppConstants.applyFiltersLabel;

    final clearFiltersLabel = (_english)
        ? AppConstants.clearFiltersLabelEn
        : AppConstants.clearFiltersLabel;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.primary,
                      ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_outlined,
                    color: AppConstants.primary,
                  ),
                  onPressed: () {
                    if (_selectedFilters.isNotEmpty) {
                      context.read<FilterModel>().clear();
                    }

                    _closeModal(null);
                  },
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      children: List.generate(
                        widget.filterItems.length,
                        (index) {
                          bool itemWasAdded = _selectedFilters.contains(
                            widget.filterItems[index],
                          );

                          final name = (_english)
                              ? widget.filterItems[index].nameEn
                              : widget.filterItems[index].nameEs;

                          return ListTile(
                            title: Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppConstants.primary,
                                  ),
                            ),
                            trailing: (itemWasAdded)
                                ? const Icon(
                                    Icons.check_outlined,
                                    color: AppConstants.primary,
                                  )
                                : const SizedBox(),
                            onTap: () => context
                                .read<FilterModel>()
                                .toggleSelectItem(widget.filterItems[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(clearFiltersLabel),
                  ),
                  const SizedBox(width: AppConstants.spacing),
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedFilters.isEmpty) {
                          context.read<FilterModel>().clear();
                        } else {
                          if (widget.filterRestaurants) {
                            context.read<FilterModel>().filterRestaurants();
                          }

                          if (widget.filterHotels) {
                            context.read<FilterModel>().filterHotels();
                          }
                        }

                        _closeModal(null);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadius,
                          ),
                          color: AppConstants.contrast,
                        ),
                        padding: const EdgeInsets.all(AppConstants.spacing),
                        child: Text(
                          applyFiltersLabel,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Closes the bottom sheet.
  void _closeModal(Set<FilterItem>? selectedFilters) {
    Navigator.of(context).pop(selectedFilters);
  }

  /// Clears all the selected filters.
  ///
  /// This method resets the `itemsToFilter` list by clearing all its elements
  /// and then calls `setState` to update the UI accordingly.
  void _clearFilters() {
    context.read<FilterModel>().clear();
    _closeModal(null);
  }
}
