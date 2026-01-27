import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/dtos/route_item.dart';
import 'package:valdeiglesias/dtos/route_point_ref.dart';
import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class RouteModel extends AppModel with ChangeNotifier {
  RouteModel() {
    _setRoutes();
  }

  final List<RouteItem> _routes = [];
  final List<RouteItem> _routesEn = [];

  Set<RouteItem> _filteredRoutes = {};
  Set<RouteItem> _filteredRoutesEn = {};

  List<RouteFilterType> _routeTypesEn = [];
  List<RouteFilterType> _routeTypes = [];

  List<RouteFilterType> _circuitTypes = [];
  List<RouteFilterType> _circuitTypesEn = [];

  List<RouteFilterType> _difficultyTypes = [];
  List<RouteFilterType> _difficultyTypesEn = [];

  Set<RouteFilterType> _selectedRouteTypes = {};
  Set<RouteFilterType> _selectedRouteTypesEn = {};
  Set<RouteFilterType> _selectedCircuitTypes = {};
  Set<RouteFilterType> _selectedCircuitTypesEn = {};
  Set<RouteFilterType> _selectedDifficultyTypes = {};
  Set<RouteFilterType> _selectedDifficultyTypesEn = {};

  int _routeTypeSelected = 0;
  int _circuitTypeSelected = 0;
  int _difficultyTypeSelected = 0;

  bool _noResults = false;
  bool _filtersApplied = false;
  bool _hasFinishedLoading = false;

  List<RouteItem> get routes => _routes;
  List<RouteItem> get routesEn => _routesEn;
  Set<RouteItem> get filteredRoutes => _filteredRoutes;
  Set<RouteItem> get filteredRoutesEn => _filteredRoutesEn;
  bool get hasFinishedLoading => _hasFinishedLoading;

  List<RouteFilterType> get routeTypes => _routeTypes;
  List<RouteFilterType> get routeTypesEn => _routeTypesEn;
  List<RouteFilterType> get circuitTypes => _circuitTypes;
  List<RouteFilterType> get circuitTypesEn => _circuitTypesEn;
  List<RouteFilterType> get difficultyTypes => _difficultyTypes;
  List<RouteFilterType> get difficultyTypesEn => _difficultyTypesEn;

  Set<RouteFilterType> get selectedRouteTypes => _selectedRouteTypes;
  Set<RouteFilterType> get selectedRouteTypesEn => _selectedRouteTypesEn;
  Set<RouteFilterType> get selectedCircuitTypes => _selectedCircuitTypes;
  Set<RouteFilterType> get selectedCircuitTypesEn => _selectedCircuitTypesEn;
  Set<RouteFilterType> get selectedDifficultyTypes => _selectedDifficultyTypes;
  Set<RouteFilterType> get selectedDifficultyTypesEn =>
      _selectedDifficultyTypesEn;

  int get routeTypeSelected => _routeTypeSelected;
  int get circuitTypeSelected => _circuitTypeSelected;
  int get difficultyTypeSelected => _difficultyTypeSelected;

  bool get noResults => _noResults;
  bool get filtersApplied => _filtersApplied;

  void _setRoutes() async {
    _hasFinishedLoading = false;
    notifyListeners();
    
    print('=== INICIANDO CARGA DE RUTAS ===');
    print('URL ES: ${AppConstants.paths}');
    print('URL EN: ${AppConstants.pathsEn}');
    
    try {
      print('Haciendo petición ES...');
      final response = await http.get(Uri.parse(AppConstants.paths));
      print('Petición ES completada - Status: ${response.statusCode}');
      
      print('Haciendo petición EN...');
      final responseEn = await http.get(Uri.parse(AppConstants.pathsEn));
      print('Petición EN completada - Status: ${responseEn.statusCode}');

      if (response.statusCode == AppConstants.success) {
        print('Procesando respuesta ES...');
        List<dynamic> body = jsonDecode(response.body);
        print('Body ES tiene ${body.length} elementos');
        
        if (body.isNotEmpty) {
          print('Primer elemento ES: ${body.first}');
        }

        for (int i = 0; i < body.length; i++) {
          try {
            var item = body[i];
            print('Procesando ruta ES ${i + 1}/${body.length}: ${item['title']?[0]?['value'] ?? 'Sin título'}');
            _routes.add(getPlace(item) as RouteItem);
            print('✓ Ruta ES ${i + 1} procesada correctamente');
          } catch (e) {
            print('✗ Error procesando ruta ES ${i + 1}: $e');
            print('Datos de la ruta: ${body[i]}');
          }
        }
        print('Rutas ES cargadas: ${_routes.length}');
      } else {
        print('ERROR: Respuesta ES falló con código ${response.statusCode}');
      }

      if (responseEn.statusCode == AppConstants.success) {
        print('Procesando respuesta EN...');
        List<dynamic> body = jsonDecode(responseEn.body);
        print('Body EN tiene ${body.length} elementos');

        for (int i = 0; i < body.length; i++) {
          try {
            var item = body[i];
            print('Procesando ruta EN ${i + 1}/${body.length}: ${item['title']?[0]?['value'] ?? 'Sin título'}');
            _routesEn.add(getPlace(item) as RouteItem);
            print('✓ Ruta EN ${i + 1} procesada correctamente');
          } catch (e) {
            print('✗ Error procesando ruta EN ${i + 1}: $e');
            print('Datos de la ruta: ${body[i]}');
          }
        }
        print('Rutas EN cargadas: ${_routesEn.length}');
      } else {
        print('ERROR: Respuesta EN falló con código ${responseEn.statusCode}');
      }
    } catch (e) {
      print('ERROR AL CARGAR RUTAS: $e');
      print('Tipo de error: ${e.runtimeType}');
    }

    await _setRouteTypes();
    await _setCircuitTypes();
    await _setDifficultyTypes();
    _setSelectorValues(routes);
    _filteredRoutes.addAll(_routes);
    _filteredRoutesEn.addAll(_routesEn);
    
    _hasFinishedLoading = true;
    
    print('=== ESTADO FINAL ===');
    print('Total rutas ES: ${_routes.length}');
    print('Total rutas EN: ${_routesEn.length}');
    print('Rutas filtradas ES: ${_filteredRoutes.length}');
    print('Rutas filtradas EN: ${_filteredRoutesEn.length}');
    print('========================');
    
    notifyListeners();
  }

  /// Fetch the routes data
  Future<List<RouteItem>> getRoutes() async {
    final response = await http.get(Uri.parse(AppConstants.paths));

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        _routes.add(getPlace(item) as RouteItem);
      }
    }

    return routes;
  }

  /// Fetch the routes data
  Future<List<RouteItem>> getRoutesEn() async {
    final responseEn = await http.get(Uri.parse(AppConstants.pathsEn));

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(responseEn.body);

      for (var item in body) {
        _routesEn.add(getPlace(item) as RouteItem);
      }
    }

    return routesEn;
  }

  @override
  List<InterestPlace> getInterestPlaces(List<dynamic> places) {
    List<InterestPlace> mappedPlaces = [];

    mappedPlaces.addAll(
      places.map(
        (place) {
          return InterestPlace(
            latitude: place[AppConstants.routeLocation]
                .first[AppConstants.placeLatitude],
            longitude: place[AppConstants.routeLocation]
                .first[AppConstants.placeLongitude],
            name: place[AppConstants.titleKey].first[AppConstants.valueKey],
            nameEn: place[AppConstants.titleKey].first[AppConstants.valueKey],
            imageUrl:
                place[AppConstants.routeMainImage].first[AppConstants.urlKey],
            description:
                place[AppConstants.routeShortDesc].first[AppConstants.valueKey],
            descriptionEn:
                place[AppConstants.routeShortDesc].first[AppConstants.valueKey],
            placeForDetail: getPlace(place),
          );
        },
      ).toList(),
    );

    return mappedPlaces;
  }

  @override
  Place getPlace(place) {
    List<String> imageUrls = [];
    final points = _mapRoutePoints(place[AppConstants.routePointsField]);

    if (place[AppConstants.routeGallery] != null && place[AppConstants.routeGallery].isNotEmpty) {
      for (var image in place[AppConstants.routeGallery]) {
        if (image[AppConstants.urlKey] != null) {
          imageUrls.add(image[AppConstants.urlKey]);
        }
      }
    }

    return RouteItem(
      mainImageUrl: place[AppConstants.routeMainImage]?.isNotEmpty == true
          ? place[AppConstants.routeMainImage].first[AppConstants.urlKey]
          : '',
      placeId: place[AppConstants.nIdKey]?.isNotEmpty == true
          ? place[AppConstants.nIdKey].first[AppConstants.valueKey]
          : '',
      placeName: place[AppConstants.titleKey]?.isNotEmpty == true
          ? place[AppConstants.titleKey].first[AppConstants.valueKey]
          : 'Ruta sin título',
      placeNameEn: place[AppConstants.titleKey]?.isNotEmpty == true
          ? place[AppConstants.titleKey].first[AppConstants.valueKey]
          : 'Route without title',
      shortDescription: place[AppConstants.routeShortDesc]?.isNotEmpty == true
          ? place[AppConstants.routeShortDesc].first[AppConstants.valueKey]
          : 'Sin descripción',
      longDescription: place[AppConstants.routeLongDesc]?.isNotEmpty == true
          ? place[AppConstants.routeLongDesc].first[AppConstants.valueKey]
          : 'Sin descripción larga',
      routeTypeId: place[AppConstants.routeTypeId]?.isNotEmpty == true
          ? place[AppConstants.routeTypeId].first[AppConstants.targetIdKey]
          : 1, // Tipo por defecto
      circuitTypeId: place[AppConstants.circuitTypeId]?.isNotEmpty == true
          ? place[AppConstants.circuitTypeId].first[AppConstants.targetIdKey]
          : 1, // Circuito por defecto
      distance: place[AppConstants.distance]?.isNotEmpty == true
          ? '${place[AppConstants.distance].first[AppConstants.valueKey]} Km'
          : '0 Km',
      travelTimeInHours: place[AppConstants.travelTimeInHours]?.isNotEmpty == true
          ? (place[AppConstants.travelTimeInHours].first[AppConstants.valueKey] as num).toInt()
          : 0,
      travelTimeInMins: place[AppConstants.travelTimeInMins]?.isNotEmpty == true
          ? (place[AppConstants.travelTimeInMins].first[AppConstants.valueKey] as num).toInt()
          : 0,
      difficultyId: place[AppConstants.difficulty]?.isNotEmpty == true
          ? place[AppConstants.difficulty].first[AppConstants.targetIdKey]
          : 1, // Dificultad por defecto
      maximumAltitude: place[AppConstants.maximumAltitude]?.isNotEmpty == true
          ? (place[AppConstants.maximumAltitude].first[AppConstants.valueKey] as num).toInt()
          : 0,
      minimumAltitude: place[AppConstants.minimumAltitude]?.isNotEmpty == true
          ? (place[AppConstants.minimumAltitude].first[AppConstants.valueKey] as num).toInt()
          : 0,
      positiveElevation: place[AppConstants.positiveElevation]?.isNotEmpty == true
          ? (place[AppConstants.positiveElevation].first[AppConstants.valueKey] as num).toInt()
          : 0,
      negativeElevation: place[AppConstants.negativeElevation]?.isNotEmpty == true
          ? (place[AppConstants.negativeElevation].first[AppConstants.valueKey] as num).toInt()
          : 0,
      latitude: place[AppConstants.routeLocation]?.isNotEmpty == true
          ? (place[AppConstants.routeLocation].first[AppConstants.placeLatitude] as num).toDouble()
          : 40.4815, // Coordenadas por defecto de Alcalá de Henares
      longitude: place[AppConstants.routeLocation]?.isNotEmpty == true
          ? (place[AppConstants.routeLocation].first[AppConstants.placeLongitude] as num).toDouble()
          : -3.3640,
      imageUrls: imageUrls,
      kmlFileUrl: ContentValidator.url(place[AppConstants.routeKml]),
      placeType: AppConstants.routeApiType,
      placeTypeEn: AppConstants.routeApiType,
      points: points,
    );
  }

  List<RoutePointRef> _mapRoutePoints(dynamic rawPoints) {
    if (rawPoints is! List) {
      return const [];
    }

    final List<RoutePointRef> points = [];

    for (final point in rawPoints) {
      if (point is Map) {
        final targetId = _parseId(point[AppConstants.targetIdKey]);
        final targetType = '${point[AppConstants.targetTypeKey] ?? ''}';
        final targetUuid = '${point[AppConstants.targetUuidKey] ?? ''}';
        final url = '${point[AppConstants.urlKey] ?? ''}';

        if (targetId != null && url.isNotEmpty) {
          points.add(
            RoutePointRef(
              targetId: targetId,
              targetType: targetType,
              targetUuid: targetUuid,
              url: url,
            ),
          );
        }
      }
    }

    return points;
  }

  int? _parseId(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  Future<void> _setRouteTypes() async {
    List<dynamic> types = [];
    List<dynamic> typesEn = [];

    print('=== CARGANDO TIPOS DE RUTA ===');
    print('URL ES: ${AppConstants.routeType}');
    print('URL EN: ${AppConstants.routeTypeEn}');

    if (_routeTypes.isEmpty) {
      final response = await http.get(
        Uri.parse(AppConstants.routeType),
      );

      if (response.statusCode == AppConstants.success) {
        types = jsonDecode(response.body);
        _routeTypes = _mapTypes(types);
        print('✓ Tipos de ruta ES cargados: ${_routeTypes.length}');
        for (var type in _routeTypes) {
          print('  - ${type.id}: ${type.name}');
        }
      } else {
        print('✗ Error cargando tipos ES: ${response.statusCode}');
      }
    } else {
      print('⚠️ Tipos ES ya cargados: ${_routeTypes.length}');
    }

    if (_routeTypesEn.isEmpty) {
      final responseEn = await http.get(
        Uri.parse(AppConstants.routeTypeEn),
      );

      if (responseEn.statusCode == AppConstants.success) {
        typesEn = jsonDecode(responseEn.body);
        _routeTypesEn = _mapTypes(typesEn);
        print('✓ Tipos de ruta EN cargados: ${_routeTypesEn.length}');
        for (var type in _routeTypesEn) {
          print('  - ${type.id}: ${type.name}');
        }
      } else {
        print('✗ Error cargando tipos EN: ${responseEn.statusCode}');
      }
    } else {
      print('⚠️ Tipos EN ya cargados: ${_routeTypesEn.length}');
    }

    print('=== FIN TIPOS DE RUTA ===');
  }

  Future<void> _setCircuitTypes() async {
    List<dynamic> types = [];
    List<dynamic> typesEn = [];

    if (_circuitTypes.isEmpty) {
      final response = await http.get(
        Uri.parse(AppConstants.circuitType),
      );

      if (response.statusCode == AppConstants.success) {
        types = jsonDecode(response.body);
        _circuitTypes = _mapTypes(types);
      }
    }

    if (_circuitTypesEn.isEmpty) {
      final responseEn = await http.get(
        Uri.parse(AppConstants.circuitTypeEn),
      );

      if (responseEn.statusCode == AppConstants.success) {
        typesEn = jsonDecode(responseEn.body);
        _circuitTypesEn = _mapTypes(typesEn);
      }
    }

    // if (_circuitTypes.isNotEmpty && _circuitTypesEn.isNotEmpty) {
    //   notifyListeners();
    // }
  }

  Future<void> _setDifficultyTypes() async {
    List<dynamic> types = [];
    List<dynamic> typesEn = [];

    if (_difficultyTypes.isEmpty) {
      final response = await http.get(
        Uri.parse(AppConstants.difficultyType),
      );

      if (response.statusCode == AppConstants.success) {
        types = jsonDecode(response.body);
        _difficultyTypes = _mapTypes(types);
      }
    }

    if (_difficultyTypesEn.isEmpty) {
      final responseEn = await http.get(
        Uri.parse(AppConstants.difficultyTypeEn),
      );

      if (responseEn.statusCode == AppConstants.success) {
        typesEn = jsonDecode(responseEn.body);
        _difficultyTypesEn = _mapTypes(typesEn);
      }
    }

    // if (_difficultyTypes.isNotEmpty && _difficultyTypesEn.isNotEmpty) {
    //   notifyListeners();
    // }
  }

  void setRouteTypeSelection(int selectionId) {
    _routeTypeSelected = selectionId;
    notifyListeners();
  }

  void setCircuitTypeSelection(int selectionId) {
    _circuitTypeSelected = selectionId;
    notifyListeners();
  }

  void setDifficultyTypeSelection(int selectionId) {
    _difficultyTypeSelected = selectionId;
    notifyListeners();
  }

  void setFiltersApplied(bool applied) {
    _filtersApplied = applied;
    notifyListeners();
  }

  void filterRoutes() {
    _noResults = false;
    _filteredRoutes.clear();
    _filteredRoutesEn.clear();
    bool routeTypeSelected = _routeTypeSelected != 0;

    if (routeTypeSelected) {
      _filteredRoutes.addAll(
        _routes.where(_routeTypeMatch).toSet(),
      );

      _filteredRoutesEn.addAll(
        _routesEn.where(_routeTypeMatch).toSet(),
      );
    } else {
      _filteredRoutes.addAll(_routes);
      _filteredRoutesEn.addAll(_routesEn);
    }

    if (_filteredRoutes.isEmpty && _filteredRoutesEn.isEmpty) {
      _noResults = true;
    }

    if (_routeTypeSelected == 0) {
      _noResults = false;
      _filteredRoutes.addAll(_routes);
      _filteredRoutesEn.addAll(_routesEn);
    }

    _filtersApplied = true;
    notifyListeners();
  }

  void resetFilters() {
    _filteredRoutes.clear();
    _filteredRoutesEn.clear();
    _filteredRoutes.addAll(_routes);
    _filteredRoutesEn.addAll(_routesEn);
    _noResults = false;
    _filtersApplied = false;
    notifyListeners();
  }

  List<RouteFilterType> _mapTypes(List<dynamic> types) {
    return types.map(
      (type) {
        int id = type[AppConstants.idKey].first[AppConstants.valueKey];
        String name = type[AppConstants.nameKey].first[AppConstants.valueKey];

        return RouteFilterType(
          id: id,
          name: name,
        );
      },
    ).toList();
  }

  bool _routeTypeMatch(RouteItem route) {
    return route.routeTypeId == _routeTypeSelected;
  }

  void _setSelectorValues(List<RouteItem> routes) {
    for (final route in routes) {
      _selectedCircuitTypes.addAll(
        _sortValues(_circuitTypes
            .where((type) => type.id == route.circuitTypeId)
            .toList()),
      );

      _selectedCircuitTypesEn.addAll(
        _circuitTypesEn
            .where((type) => type.id == route.circuitTypeId)
            .toList(),
      );

      _selectedDifficultyTypes.addAll(
        _difficultyTypes
            .where((type) => type.id == route.difficultyId)
            .toList(),
      );

      _selectedDifficultyTypesEn.addAll(
        _difficultyTypesEn
            .where((type) => type.id == route.difficultyId)
            .toList(),
      );

      _selectedRouteTypes.addAll(
        _routeTypes
            .where(
              (type) => type.id == route.routeTypeId,
            )
            .toList(),
      );

      _selectedRouteTypesEn.addAll(
        _routeTypesEn
            .where(
              (type) => type.id == route.routeTypeId,
            )
            .toList(),
      );
    }

    // Sort selected values:
    _selectedRouteTypes = _sortValues(_selectedRouteTypes.toList());
    _selectedRouteTypesEn = _sortValues(_selectedRouteTypesEn.toList());
    _selectedDifficultyTypes = _sortValues(_selectedDifficultyTypes.toList());
    _selectedDifficultyTypesEn = _sortValues(
      _selectedDifficultyTypesEn.toList(),
    );
    _selectedCircuitTypes = _sortValues(_selectedCircuitTypes.toList());
    _selectedCircuitTypesEn = _sortValues(_selectedCircuitTypesEn.toList());
  }

  Set<RouteFilterType> _sortValues(List<RouteFilterType> values) {
    List<RouteFilterType> sorted = List.from(values);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted.toSet();
  }
}
