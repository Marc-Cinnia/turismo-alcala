import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/map_places.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/section.dart';

class MapModel extends ChangeNotifier {
  Set<FilterItem> _filters = {};
  Set<FilterItem> _selectedFilters = {};
  List<Place> _cellars = [];
  List<Place> _restaurants = [];
  List<Place> _experiences = [];
  List<Place> _guidedTours = [];
  List<Place> _places = [];
  List<Place> _routes = [];
  List<Place> _events = [];
  List<Place> _stores = [];
  List<Place> _hotels = [];
  bool _filtersCreated = false;
  bool _placesLoaded = false;

  Set<FilterItem> get filters => _filters;
  Set<FilterItem> get selectedFilters => _selectedFilters;

  bool get filtersCreated => _filtersCreated;
  bool get placesLoaded => _placesLoaded;

  set placesLoaded(bool loaded) {
    _placesLoaded = loaded;
    notifyListeners();
  }

  void setFilters(List<Section> sections, MapPlaces mapPlaces) {
    _setMapPlaces(mapPlaces);

    print('=== MAP MODEL DEBUG ===');
    print('Sections received: ${sections.length}');
    for (var section in sections) {
      print('Section: ${section.label} - routeName: ${section.routeName}');
    }
    print('Map places data:');
    print('  - Places (visit): ${mapPlaces.places.length}');
    print('  - Restaurants: ${mapPlaces.restaurants.length}');
    print('  - Experiences: ${mapPlaces.experiences.length}');
    print('  - Guided Tours: ${mapPlaces.guidedTours.length}');
    print('  - Routes: ${mapPlaces.routes.length}');
    print('  - Events: ${mapPlaces.events.length}');
    print('  - Stores: ${mapPlaces.stores.length}');
    print('  - Hotels: ${mapPlaces.hotels.length}');
    print('  - Cellars: ${mapPlaces.cellars.length}');

    if (sections.isNotEmpty) {
      sections.forEach(
        (section) {
          print('Creating filter for section: ${section.routeName}');
          final filter = _createFilter(section);

          if (filter != null) {
            print(
                'Filter created: ${filter.nameEs} with ${filter.places?.length} places');

            // Check if filter already exists and preserve user selection
            final wasSelected = _selectedFilters
                .where((currentFilter) => currentFilter.nameEs == filter.nameEs)
                .isNotEmpty;
            final existingFilter = _filters
                .where((currentFilter) => currentFilter.nameEs == filter.nameEs)
                .firstOrNull;

            // Remove existing filter if it exists
            _filters.removeWhere(
                (currentFilter) => currentFilter.nameEs == filter.nameEs);
            _selectedFilters.removeWhere(
                (currentFilter) => currentFilter.nameEs == filter.nameEs);

            // Add the new filter
            _filters.add(filter);

            // Preserve user selection state or default to selected for new filters
            if (existingFilter != null ? wasSelected : true) {
              _selectedFilters.add(filter);
            }

            print(
                'Filter added to list (selected: ${_selectedFilters.contains(filter)})');
          } else {
            print('No filter created for section: ${section.routeName}');
          }
        },
      );
    }

    print('Total filters created: ${_filters.length}');
    for (var filter in _filters) {
      print('  - ${filter.nameEs}: ${filter.places?.length} places');
    }
    print('======================');

    if (_filters.isNotEmpty) {
      _filtersCreated = true;
      notifyListeners();
    }
  }

  void _setMapPlaces(MapPlaces mapPlaces) {
    _cellars = mapPlaces.cellars;
    _restaurants = mapPlaces.restaurants;
    _experiences = mapPlaces.experiences;
    _guidedTours = mapPlaces.guidedTours;
    _places = mapPlaces.places;
    _routes = mapPlaces.routes;
    _events = mapPlaces.events;
    _stores = mapPlaces.stores;
    _hotels = mapPlaces.hotels;
  }

  FilterItem? _createFilter(Section section) {
    FilterItem? filter;

    switch (section.routeName) {
      case AppConstants.cellar:
        if (_cellars.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.cellarLabelEn,
            nameEs: AppConstants.cellarLabel,
            places: _cellars,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.eat:
        if (_restaurants.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.whereToEatLabelEn,
            nameEs: AppConstants.whereToEatLabel,
            places: _restaurants,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.experience:
        if (_experiences.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.experienceTitleEn,
            nameEs: AppConstants.experienceTitle,
            places: _experiences,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.guidedVisits:
        if (_guidedTours.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.toursLabelEn,
            nameEs: AppConstants.toursLabel,
            places: _guidedTours,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.visit:
        if (_places.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.visitLabelEn,
            nameEs: AppConstants.visitLabel,
            places: _places,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.routes:
        if (_routes.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.routesTitleEn,
            nameEs: AppConstants.routesTitle,
            places: _routes,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.schedule:
        if (_events.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.eventsTitleLabelEn,
            nameEs: AppConstants.eventsTitleLabel,
            places: _events,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.shop:
        if (_stores.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.whereToShopLabelEn,
            nameEs: AppConstants.whereToShopLabel,
            places: _stores,
            section: section,
            isSelected: true,
          );
        }
        break;

      case AppConstants.sleep:
        if (_hotels.isNotEmpty) {
          filter = FilterItem(
            nameEn: AppConstants.whereToSleepLabelEn,
            nameEs: AppConstants.whereToSleepLabel,
            places: _hotels,
            section: section,
            isSelected: true,
          );
        }
        break;
    }

    return filter;
  }

  void toggleSelectFilter(FilterItem filter) {
    bool isSelected = false;
    FilterItem? selectedFilter;

    try {
      selectedFilter = _selectedFilters
          .where(
            (item) => item.nameEs == filter.nameEs,
          )
          .firstOrNull;

      isSelected = selectedFilter != null;
    } catch (e) {
      print('Exception during filtering: $e');
    }

    if (isSelected) {
      _selectedFilters.remove(selectedFilter!);
    } else {
      _selectedFilters.add(filter);
    }
  }

  void applyFilters() => notifyListeners();

  void clearFilters() {
    _selectedFilters.clear();
    notifyListeners();
  }
}
