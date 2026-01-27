import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/food_item.dart';
import 'package:valdeiglesias/dtos/place_service.dart';
import 'package:valdeiglesias/models/filter_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/eat_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/filter_bottom_sheet.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/no_results_placeholder.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

class EatPreDetail extends StatefulWidget {
  const EatPreDetail({
    super.key,
    required this.places,
    required this.accessible,
  });

  /// A list of food items representing places to eat.
  ///
  /// This list contains instances of [FoodItem] that represent the places
  /// where users can find food. It is used to manage and display the food
  /// options in the UI.
  final List<FoodItem> places;
  final bool accessible;

  @override
  State<EatPreDetail> createState() => _EatPreDetailState();
}

/// State class for the [EatPreDetail] widget.
///
/// This class manages the state of the `EatPreDetail` screen, including
/// the list of items to be displayed. It provides methods to handle user
/// interactions and update the UI accordingly.
class _EatPreDetailState extends State<EatPreDetail> {
  /// Services associated with the place.
  ///
  /// Contains instances of [FilterItem] that represent the
  /// services available at the place. It is used to manage and display
  /// the services associated with the place in the UI.
  late Set<FilterItem> _services;

  /// A set of filtered places where to eat.
  ///
  /// This set contains instances of [FoodItem] that represent the places
  /// where to eat after applying the selected filters. It is used to manage
  /// and display the filtered places in the UI.
  late Set<FoodItem> _filteredRestaurants;
  late bool _restaurantsFiltered;
  late bool _isFiltering;
  late LanguageModel _language;
  late Set<FilterItem> _selectedFilters;
  late FilterModel filter;

  @override
  void initState() {
    _services = _initServicesData();
    _filteredRestaurants = {};
    _restaurantsFiltered = false;
    _selectedFilters = {};
    super.initState();
  }

  @override
  void dispose() {
    _filteredRestaurants = {};
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<FilterModel>(context).restaurants = widget.places.toSet();

    _filteredRestaurants =
        Provider.of<FilterModel>(context).filteredRestaurants;
    _language = Provider.of<LanguageModel>(context);
    _selectedFilters = Provider.of<FilterModel>(context).selectedFilters;
    _isFiltering = Provider.of<FilterModel>(context).userIsFiltering;
    _restaurantsFiltered = _filteredRestaurants.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final whereToEatLabel = (_language.english)
        ? AppConstants.whereToEatLabelEn
        : AppConstants.whereToEatLabel;

    Widget mainContent;

    if (_restaurantsFiltered) {
      mainContent = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildListItems(
              context,
              _filteredRestaurants.toList(),
            ),
          ),
        ),
      );
    } else {
      if (_selectedFilters.isEmpty) {
        mainContent = SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildListItems(
                context,
                widget.places,
              ),
            ),
          ),
        );
      } else {
        mainContent = NoResultsPlaceholder();

        if (_isFiltering) {
          mainContent = Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
              bottom: 100.0,
            ),
            child: Center(child: LoaderBuilder.getLoader()),
          );
        }
      }
    }

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
          value: whereToEatLabel,
          accessible: widget.accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.filter_list_outlined,
                    color: AppConstants.primary,
                  ),
                  onPressed: () async {
                    if (_services.isNotEmpty) {
                      await showModalBottomSheet<Set<FilterItem>?>(
                        enableDrag: false,
                        isDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterBottomSheet(
                            filterItems: _services.toList(),
                            filterRestaurants: true,
                            filterHotels: false,
                            itemsDescription:
                                AppConstants.servicesFilterItemsDesc,
                            itemsDescriptionEn:
                                AppConstants.servicesFilterItemsDescEn,
                          );
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppConstants.borderRadius),
                            topRight:
                                Radius.circular(AppConstants.borderRadius),
                          ),
                        ),
                      ).then(
                        (selectedFilters) {
                          if (selectedFilters != null) {
                            _selectedFilters = selectedFilters;

                            if (_selectedFilters.isNotEmpty) {
                              context.read<FilterModel>().filterRestaurants();
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            mainContent,
          ],
        ),
      ),
    );
  }

  /// Initializes the set of services data.
  ///
  /// This method retrieves and initializes the set of [PlaceService] instances
  /// associated with the place. It is called during the initialization process
  /// to prepare the data for display in the UI
  ///
  /// Returns:
  ///  A set of [FilterItem] instances associated with the place.
  Set<FilterItem> _initServicesData() {
    Set<FilterItem> items = {};

    for (final place in widget.places) {
      for (final service in place.placeServices) {
        bool serviceNotExists = items.where(
          (item) {
            return item.placeService?.pivot.serviceId ==
                service.pivot.serviceId;
          },
        ).isEmpty;

        if (serviceNotExists) {
          items.add(
            FilterItem(
              nameEn: service.nameEn,
              nameEs: service.nameEs,
              placeService: service,
            ),
          );
        }
      }
    }

    return items;
  }

  /// Builds a list of widgets representing the places where to eat.
  ///
  /// This method creates a list of widgets based on the provided list of [FoodItem]s.
  /// Each widget displays information about a place where to eat.
  List<Widget> _buildListItems(BuildContext context, List<FoodItem> items) {
    return List.generate(
      items.length,
      (index) {
        FoodItem place = items[index];
        String description = '';

        if (_language.english) {
          if (place.shortDescriptionEn != null) {
            description = place.shortDescriptionEn!;
          }
        } else {
          if (place.shortDescription != null) {
            description = place.shortDescription!;
          }
        }

        final thumbnailImage = (widget.accessible)
            ? const SizedBox()
            : GestureDetector(
                onTap: () => _showDetail(context, items[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.thumbnailBorderRadius,
                  ),
                  child: SizedBox(
                    width: AppConstants.thumbnailWidth,
                    height: AppConstants.thumbnailHeight,
                    child: Image.network(
                      items[index].mainImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );

        return Card(
          color: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.cardSpacing),
            child: Builder(
              builder: (context) {
                final textPadding = const EdgeInsets.all(AppConstants.shortSpacing);

                final actionsSection = (widget.accessible)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 30.0,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppConstants.primary,
                            ),
                            onTap: () {},
                          ),
                        ),
                      )
                    // Funcionalidad de estrella deshabilitada
                    
                    : WishlistButton(
                        place: place,
                        isTextButton: false,
                      );

                final descSection = (widget.accessible)
                    ? const SizedBox()
                    : Padding(
                        padding: textPadding,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );

                return Row(
                  children: [
                    thumbnailImage,
                    Expanded(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppConstants.cardSpacing,
                            right: AppConstants.cardSpacing,
                            bottom: 8.0,
                          ),
                          child: Builder(
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: textPadding,
                                    child: Text(
                                      items[index].placeName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppConstants.primary,
                                          ),
                                    ),
                                  ),
                                  descSection,
                                ],
                              );
                            },
                          ),
                        ),
                        onTap: () => _showDetail(context, items[index]),
                      ),
                    ),
                    actionsSection,
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Displays the details of the selected food item.
  ///
  /// This method navigates to the detail screen of the selected [FoodItem].
  void _showDetail(BuildContext context, FoodItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EatDetail(
          item: item,
          accessible: widget.accessible,
        ),
      ),
    );
  }
}
