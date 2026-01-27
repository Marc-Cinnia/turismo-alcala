import 'package:flutter/material.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/food_item.dart';
import 'package:valdeiglesias/dtos/hotel.dart';

class FilterModel extends ChangeNotifier {
  Set<FilterItem> _itemsToFilter = {};
  Set<FilterItem> _selectedFilters = {};
  Set<FoodItem> _filteredRestaurants = {};
  Set<Hotel> _filteredHotels = {};
  Set<FoodItem> _restaurants = {};
  Set<Hotel> _hotels = {};
  bool _userIsFiltering = false;

  Set<FilterItem> get filterItems => _itemsToFilter;
  Set<FilterItem> get selectedFilters => _selectedFilters;
  Set<FoodItem> get filteredRestaurants => _filteredRestaurants;
  Set<Hotel> get filteredHotels => _filteredHotels;
  bool get userIsFiltering => _userIsFiltering;

  void set restaurants(Set<FoodItem> restaurants) {
    _restaurants = restaurants;
    _setRestaurantsFilters(restaurants);
  }

  void set hotels(Set<Hotel> hotels) {
    _hotels = hotels;
    _setHotelsFilters(hotels);
  }

  void set userIsFiltering(bool isFiltering) {
    _userIsFiltering = isFiltering;
  }

  void toggleSelectItem(FilterItem item) {
    _userIsFiltering = true;

    if (_selectedFilters.contains(item)) {
      _selectedFilters.remove(item);
    } else {
      _selectedFilters.add(item);
    }

    notifyListeners();
  }

  void filterRestaurants() {
    final result = _restaurants.where(
      (restaurant) {
        return _selectedFilters.every(
          (selection) {
            return restaurant.placeServices.any(
              (service) {
                bool serviceInRestaurant = service.pivot.serviceId ==
                    selection.placeService?.pivot.serviceId;

                return serviceInRestaurant;
              },
            );
          },
        );
      },
    ).toSet();

    _filteredRestaurants = result;
    _userIsFiltering = false;
    notifyListeners();
  }

  void filterHotels() {
    final result = _hotels.where(
      (hotel) {
        return _selectedFilters.every(
          (selection) {
            return hotel.placeServices.any(
              (service) {
                bool serviceInHotel = service.pivot.serviceId ==
                    selection.placeService?.pivot.serviceId;

                return serviceInHotel;
              },
            );
          },
        );
      },
    ).toSet();

    _filteredHotels = result;
    _userIsFiltering = false;
    notifyListeners();
  }

  void add(FilterItem item) {
    if (!_itemsToFilter.contains(item)) {
      _itemsToFilter.add(item);
      notifyListeners();
    }
  }

  void addAll(List<FilterItem> items) {
    _itemsToFilter.addAll(items);
    notifyListeners();
  }

  void remove(FilterItem item) {
    if (_itemsToFilter.contains(item)) {
      _itemsToFilter.remove(item);
      notifyListeners();
    }
  }

  void removeAll(List<FilterItem> items) {
    for (final item in items) {
      _itemsToFilter.remove(item);
    }

    notifyListeners();
  }

  void clear() {
    _selectedFilters.clear();
    _filteredRestaurants.clear();
    _filteredHotels.clear();
    notifyListeners();
  }

  void applyFilters() {
    _userIsFiltering = false;
    notifyListeners();
  }

  void _setRestaurantsFilters(Set<FoodItem> restaurants) {
    for (final restaurant in restaurants) {
      final services = restaurant.placeServices;

      for (final service in services) {
        final filterNotAdded = _itemsToFilter
            .where(
              (filter) =>
                  filter.placeService!.pivot.serviceId ==
                  service.pivot.serviceId,
            )
            .isEmpty;

        if (filterNotAdded) {
          _itemsToFilter.add(
            FilterItem(
              nameEs: service.nameEs,
              nameEn: service.nameEn,
              placeService: service,
              isSelected: _itemsToFilter.contains(restaurant),
            ),
          );
        }
      }
    }
  }

  void _setHotelsFilters(Set<Hotel> hotels) {
    for (final hotel in hotels) {
      final services = hotel.placeServices;

      for (final service in services) {
        final filterNotAdded = _itemsToFilter
            .where(
              (filter) =>
                  filter.placeService!.pivot.serviceId ==
                  service.pivot.serviceId,
            )
            .isEmpty;

        if (filterNotAdded) {
          _itemsToFilter.add(
            FilterItem(
              nameEs: service.nameEs,
              nameEn: service.nameEn,
              placeService: service,
              isSelected: _itemsToFilter.contains(hotel),
            ),
          );
        }
      }
    }
  }
}
