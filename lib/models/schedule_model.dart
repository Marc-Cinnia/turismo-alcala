import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/event.dart';
import 'package:valdeiglesias/models/app_model.dart';

import 'package:valdeiglesias/utils/content_validator.dart';
import 'package:valdeiglesias/utils/date_formatter.dart';

class ScheduleModel extends AppModel with ChangeNotifier {
  ScheduleModel() {
    _setSchedule();
  }

  final Map<String, List<Event>> _events = {};
  final Map<String, List<Event>> _eventsEn = {};

  List<Event> _eventSchedule = [];
  bool _hasFinishedLoading = false;

  List<Event> get eventSchedule => _eventSchedule;
  
  /// Obtiene los eventos según el idioma
  List<Event> getEventsByLanguage(bool english) {
    if (english) {
      // Si está en inglés, devolver todos los eventos de scheduleEn
      List<Event> eventsEn = [];
      for (var monthEvents in _eventsEn.values) {
        eventsEn.addAll(monthEvents);
      }
      return eventsEn;
    } else {
      // Si está en español, devolver todos los eventos de schedule
      List<Event> events = [];
      for (var monthEvents in _events.values) {
        events.addAll(monthEvents);
      }
      return events;
    }
  }

  Map<String, List<Event>> get schedule => _events;
  Map<String, List<Event>> get scheduleEn => _eventsEn;
  bool get hasData => _events.isNotEmpty || _eventsEn.isNotEmpty;
  bool get hasFinishedLoading => _hasFinishedLoading;

  void _setSchedule() async {
    _hasFinishedLoading = false;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse(AppConstants.currentSchedule),
      );
      
      if (response.statusCode == AppConstants.success) {
        try {
          dynamic parsedBody = jsonDecode(response.body);
          List<dynamic> body;
          
          if (parsedBody is Map<String, dynamic>) {
            if (parsedBody.containsKey('data') && parsedBody['data'] is List) {
              body = parsedBody['data'];
            } else if (parsedBody.containsKey('status_code') && parsedBody['status_code'] == 200 && parsedBody.containsKey('data')) {
              body = parsedBody['data'];
            } else {
              _hasFinishedLoading = true;
              notifyListeners();
              return;
            }
          } else if (parsedBody is List) {
            body = parsedBody;
          } else {
            _hasFinishedLoading = true;
            notifyListeners();
            return;
          }
          
          if (body.isNotEmpty) {
            Set<int> months = _monthsOfEvents(body);
            List<MapEntry<String, List<Event>>> entries = [];

            for (int month in months) {
              List<Event> items = _eventsByMonth(month, body);
              entries.add(MapEntry(AppConstants.months[month]!, items));
              _eventSchedule.addAll(items);
            }

            _events.addEntries(entries);
          }
        } catch (e) {
          // Error silencioso al parsear
        }
      }
    } catch (e) {
      // Error silencioso en la petición
    }

    try {
      final responseEn = await http.get(
        Uri.parse(AppConstants.currentScheduleEn),
      );

      if (responseEn.statusCode == AppConstants.success) {
        try {
          dynamic parsedBody = jsonDecode(responseEn.body);
          List<dynamic> body;
          
          if (parsedBody is Map<String, dynamic>) {
            if (parsedBody.containsKey('data') && parsedBody['data'] is List) {
              body = parsedBody['data'];
            } else if (parsedBody.containsKey('status_code') && parsedBody['status_code'] == 200 && parsedBody.containsKey('data')) {
              body = parsedBody['data'];
            } else {
              _hasFinishedLoading = true;
              notifyListeners();
              return;
            }
          } else if (parsedBody is List) {
            body = parsedBody;
          } else {
            _hasFinishedLoading = true;
            notifyListeners();
            return;
          }
          
          if (body.isNotEmpty) {
            Set<int> monthsEn = _monthsOfEvents(body);
            List<MapEntry<String, List<Event>>> entriesEn = [];

            for (int month in monthsEn) {
              List<Event> items = _eventsByMonth(month, body);
              entriesEn.add(MapEntry(AppConstants.monthsEn[month]!, items));
            }

            _eventsEn.addEntries(entriesEn);
          }
        } catch (e) {
          // Error silencioso al parsear
        }
      }
    } catch (e) {
      // Error silencioso en la petición
    }
    
    _hasFinishedLoading = true;
    notifyListeners();
  }

  Future<Map<String, List<Event>>> getSchedule() async {
    final scheduleResponse = await http.get(
      Uri.parse(AppConstants.currentSchedule),
    );

    if (scheduleResponse.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(scheduleResponse.body);
      Set<int> months = _monthsOfEvents(body);
      List<MapEntry<String, List<Event>>> entries = [];

      for (int month in months) {
        List<Event> items = _eventsByMonth(month, body);
        entries.add(MapEntry(AppConstants.months[month]!, items));
      }

      _events.addEntries(entries);
    }

    return _events;
  }

  Set<int> _monthsOfEvents(List<dynamic> events) {
    Set<int> months = {};
    final now = DateTime.now();

    for (var event in events) {
      try {
        final endDateField = event[AppConstants.scheduleEndDate];
        final startDateField = event[AppConstants.scheduleStartDate];
        
        if (endDateField is List && endDateField.isNotEmpty &&
            startDateField is List && startDateField.isNotEmpty) {
          final endDateValue = endDateField.first[AppConstants.valueKey];
          final startDateValue = startDateField.first[AppConstants.valueKey];
          
          if (endDateValue != null && startDateValue != null) {
            DateTime endDate = DateTime.parse(endDateValue.toString());
            
            if (endDate.isAfter(now) || endDate.isAtSameMomentAs(now)) {
              DateTime startDate = DateTime.parse(startDateValue.toString());
              months.add(startDate.month);
            }
          }
        }
      } catch (e) {
        // Error silencioso al parsear fecha
      }
    }

    return months;
  }

  List<Event> _eventsByMonth(int currentMonth, List<dynamic> events) {
    List<Event> eventsByMonth = [];
    final now = DateTime.now();

    for (var event in events) {
      try {
        final startDateField = event[AppConstants.scheduleStartDate];
        final endDateField = event[AppConstants.scheduleEndDate];
        
        if (startDateField is List && startDateField.isNotEmpty &&
            endDateField is List && endDateField.isNotEmpty) {
          final startDateValue = startDateField.first[AppConstants.valueKey];
          final endDateValue = endDateField.first[AppConstants.valueKey];
          
          if (startDateValue != null && endDateValue != null) {
            DateTime startDate = DateTime.parse(startDateValue.toString());
            DateTime endDate = DateTime.parse(endDateValue.toString());

            if ((endDate.isAfter(now) || endDate.isAtSameMomentAs(now)) && 
                startDate.month == currentMonth) {
              eventsByMonth.add(getPlace(event) as Event);
            }
          }
        }
      } catch (e) {
        // Error silencioso al procesar evento
      }
    }

    return eventsByMonth;
  }

  List<String> _getUrls(List<dynamic> items) {
    final List<String> urls = [];

    if (items.isNotEmpty) {
      for (var item in items) {
        try {
          if (item is Map && item.containsKey(AppConstants.urlKey)) {
            final url = item[AppConstants.urlKey];
            if (url != null && url.toString().isNotEmpty) {
              urls.add(url.toString());
            }
          }
        } catch (e) {
          // Error silencioso al obtener URL
        }
      }
    }

    return urls;
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map(
        (place) {
          return InterestPlace(
            latitude: ContentValidator.location(
              place[AppConstants.scheduleLocation],
            ).latitude,
            longitude: ContentValidator.location(
              place[AppConstants.scheduleLocation],
            ).longitude,
            name: place[AppConstants.titleKey].first[AppConstants.valueKey],
            nameEn: place[AppConstants.titleKey].first[AppConstants.valueKey],
            imageUrl: place[AppConstants.scheduleMainImage]
                .first[AppConstants.urlKey],
            description: place[AppConstants.scheduleShortDesc]
                .first[AppConstants.valueKey],
            descriptionEn: place[AppConstants.scheduleShortDesc]
                .first[AppConstants.valueKey],
            placeForDetail: getPlace(place),
          );
        },
      ).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    // Obtener fechas de forma segura
    DateTime startDate;
    DateTime endDate;
    
    try {
      final startDateField = place[AppConstants.scheduleStartDate];
      if (startDateField is List && startDateField.isNotEmpty) {
        final dateValue = startDateField.first[AppConstants.valueKey];
        if (dateValue != null) {
          startDate = DateTime.parse(dateValue.toString());
        } else {
          startDate = DateTime.now();
        }
      } else {
        startDate = DateTime.now();
      }
    } catch (e) {
      startDate = DateTime.now();
    }

    try {
      final endDateField = place[AppConstants.scheduleEndDate];
      if (endDateField is List && endDateField.isNotEmpty) {
        final dateValue = endDateField.first[AppConstants.valueKey];
        if (dateValue != null) {
          endDate = DateTime.parse(dateValue.toString());
        } else {
          endDate = DateTime.now().add(const Duration(days: 1));
        }
      } else {
        endDate = DateTime.now().add(const Duration(days: 1));
      }
    } catch (e) {
      endDate = DateTime.now().add(const Duration(days: 1));
    }

    // Obtener campos de forma segura usando ContentValidator
    int? placeId;
    try {
      if (place[AppConstants.nIdKey]?.isNotEmpty == true) {
        final idValue = place[AppConstants.nIdKey].first[AppConstants.valueKey];
        if (idValue is int) {
          placeId = idValue;
        } else if (idValue is String) {
          placeId = int.tryParse(idValue);
        }
      }
    } catch (e) {
      placeId = null;
    }
    
    final placeName = place[AppConstants.titleKey]?.isNotEmpty == true
        ? place[AppConstants.titleKey].first[AppConstants.valueKey].toString()
        : 'Sin título';
    
    final eventAddress = place[AppConstants.scheduleAddress]?.isNotEmpty == true
        ? place[AppConstants.scheduleAddress].first[AppConstants.valueKey].toString()
        : '';
    
    final shortDescription = place[AppConstants.scheduleShortDesc]?.isNotEmpty == true
        ? place[AppConstants.scheduleShortDesc].first[AppConstants.valueKey].toString()
        : null;
    
    String mainImageUrl = '';
    try {
      final mainImageField = place[AppConstants.scheduleMainImage];
      if (mainImageField is List && mainImageField.isNotEmpty) {
        final imageItem = mainImageField.first;
        if (imageItem is Map && imageItem.containsKey(AppConstants.urlKey)) {
          mainImageUrl = imageItem[AppConstants.urlKey]?.toString() ?? '';
        } else {
          mainImageUrl = ContentValidator.url(mainImageField);
        }
      }
    } catch (e) {
      mainImageUrl = '';
    }
    
    final longDescription = place[AppConstants.scheduleLongDescription]?.isNotEmpty == true
        ? place[AppConstants.scheduleLongDescription].first[AppConstants.valueKey].toString()
        : null;
    
    final location = place[AppConstants.scheduleLocation] != null
        ? ContentValidator.location(place[AppConstants.scheduleLocation] is List 
            ? place[AppConstants.scheduleLocation] 
            : [])
        : const LatLng(0.0, 0.0);
    
    final imageGallery = place[AppConstants.scheduleImageGallery] != null
        ? _getUrls(place[AppConstants.scheduleImageGallery] is List 
            ? place[AppConstants.scheduleImageGallery] 
            : [])
        : <String>[];
    
    final pdfUrl = place[AppConstants.schedulePdf] != null
        ? ContentValidator.url(place[AppConstants.schedulePdf] is List 
            ? place[AppConstants.schedulePdf] 
            : [])
        : '';

    return Event(
      placeId: placeId,
      placeName: placeName,
      placeNameEn: placeName,
      eventAddress: eventAddress,
      shortDescription: shortDescription,
      startDate: DateFormatter.format(startDate),
      startDay: startDate.day.toString(),
      endDate: DateFormatter.format(endDate),
      mainImageUrl: mainImageUrl,
      longDescription: longDescription,
      latitude: location.latitude,
      longitude: location.longitude,
      imageGallery: imageGallery,
      pdfUrl: pdfUrl,
      placeType: AppConstants.eventApiType,
      placeTypeEn: AppConstants.eventApiType,
      startDt: startDate,
      endDt: endDate,
      startTime: TimeOfDay(hour: startDate.hour, minute: startDate.minute),
      endTime: TimeOfDay(hour: endDate.hour, minute: endDate.minute),
    );
  }
}
