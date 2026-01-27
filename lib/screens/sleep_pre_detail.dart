import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/hotel.dart';
import 'package:valdeiglesias/dtos/place_service.dart';
import 'package:valdeiglesias/models/filter_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/sleep_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/filter_bottom_sheet.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/no_results_placeholder.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; //Funcionalidad de estrella deshabilitada

class SleepPreDetail extends StatefulWidget {
  const SleepPreDetail({
    super.key,
    required this.accessible,
    required this.hotels,
  });

  final bool accessible;
  final List<Hotel> hotels;

  @override
  State<SleepPreDetail> createState() => _SleepPreDetailState();
}

class _SleepPreDetailState extends State<SleepPreDetail> {
  /// Services associated with the place.
  ///
  /// Contains instances of [PlaceService] that represent the
  /// services available at the place. It is used to manage and display
  /// the services associated with the place in the UI.
  late Set<FilterItem> _services;

  /// A set of filtered places where to sleep.
  ///
  /// This set contains instances of [Hotel]s that represent the places
  /// where to sleep after applying the selected filters. It is used to manage
  /// and display the filtered places in the UI.
  late Set<Hotel> _filteredHotels;

  late LanguageModel _language;
  late Set<FilterItem> _selectedFilters;

  late FilterModel filter;

  late bool _hotelsFiltered;
  late bool _isFiltering;

  @override
  void initState() {
    _services = _initServicesData();
    _filteredHotels = {};
    _hotelsFiltered = false;
    _isFiltering = false;
    _selectedFilters = {};
    super.initState();
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
    Provider.of<FilterModel>(context).hotels = widget.hotels.toSet();

    _filteredHotels = Provider.of<FilterModel>(context).filteredHotels;
    _language = Provider.of<LanguageModel>(context);
    _selectedFilters = Provider.of<FilterModel>(context).selectedFilters;
    _isFiltering = Provider.of<FilterModel>(context).userIsFiltering;
    _hotelsFiltered = _filteredHotels.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    filter = context.watch<FilterModel>();

    var whereToSleepLabel = (_language.english)
        ? AppConstants.whereToSleepLabelEn
        : AppConstants.whereToSleepLabel;

    Widget mainContent;

    if (_hotelsFiltered) {
      mainContent = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildListItems(
              context,
              _filteredHotels.toList(),
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
                widget.hotels,
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
          value: whereToSleepLabel,
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
                  onPressed: _showFilterModal,
                ),
              ],
            ),
            mainContent,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListItems(BuildContext context, List<Hotel> hotels) {
    return List.generate(
      hotels.length,
      (index) {
        Hotel hotel = hotels[index];
        String shortDescription = '';
        bool descriptionsAvailable =
            hotel.shortDescriptionEn != null && hotel.shortDescription != null;

        if (descriptionsAvailable) {
          shortDescription = (_language.english)
              ? hotels[index].shortDescriptionEn!
              : hotels[index].shortDescription!;
        }

        Widget mainImage = (hotels[index].mainImageUrl != null)
            ? SizedBox(
                width: AppConstants.thumbnailWidth,
                height: AppConstants.thumbnailHeight,
                child: Image.network(
                  hotels[index].mainImageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox();

        final textPadding = const EdgeInsets.all(AppConstants.shortSpacing);

        final thumbnailImage = (widget.accessible)
            ? const SizedBox()
            : GestureDetector(
                onTap: () => _showDetail(context, hotels[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.thumbnailBorderRadius,
                  ),
                  child: mainImage,
                ),
              );

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
                place: hotel,
                isTextButton: false,
              );


        return Card(
          color: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.cardSpacing),
            child: Row(
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
                      child: Builder(builder: (context) {
                        final description = (widget.accessible)
                            ? const SizedBox()
                            : Padding(
                                padding: textPadding,
                                child: Text(
                                  shortDescription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: textPadding,
                              child: Text(
                                hotels[index].placeName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppConstants.primary,
                                    ),
                              ),
                            ),
                            description,
                          ],
                        );
                      }),
                    ),
                    onTap: () => _showDetail(context, hotels[index]),
                  ),
                ),
                actionsSection,
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, Hotel item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SleepDetail(
          item: item,
          accessible: widget.accessible,
        ),
      ),
    );
  }

  void _showFilterModal() async {
    if (_services.isNotEmpty) {
      await showModalBottomSheet<Set<FilterItem>?>(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (context) => FilterBottomSheet(
          filterItems: _services.toList(),
          filterHotels: true,
          filterRestaurants: false,
          itemsDescription: AppConstants.servicesFilterItemsDesc,
          itemsDescriptionEn: AppConstants.servicesFilterItemsDescEn,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadius),
            topRight: Radius.circular(AppConstants.borderRadius),
          ),
        ),
      ).then(
        (selectedFilters) {
          if (selectedFilters != null) {
            _selectedFilters = selectedFilters;

            if (_selectedFilters.isNotEmpty) {
              context.read<FilterModel>().filterHotels();
            }
          }
        },
      );
    }
  }

  /// Initializes the set of services data.
  ///
  /// This method retrieves and initializes the set of [PlaceService] instances
  /// associated with the place. It is called during the initialization process
  /// to prepare the data for display in the UI
  ///
  /// Returns:
  ///  A set of [PlaceService] instances associated with the place.
  Set<FilterItem> _initServicesData() {
    Set<FilterItem> items = {};

    for (final place in widget.hotels) {
      for (final service in place.placeServices) {
        bool serviceNotExists = items
            .where(
              (item) =>
                  item.placeService?.pivot.serviceId == service.pivot.serviceId,
            )
            .isEmpty;

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
}
