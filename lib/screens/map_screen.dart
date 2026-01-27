import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/map_places.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/section.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/map_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/filter_button.dart';
import 'package:valdeiglesias/widgets/map_viewer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LanguageModel _language;
  late List<Place> _cellars;
  late List<Place> _restaurants;
  late List<Place> _experiences;
  late List<Place> _guidedTours;
  late List<Place> _places;
  late List<Place> _routes;
  late List<Place> _routesEn;
  late List<Place> _events;
  late List<Place> _stores;
  late List<Place> _hotels;
  late List<Section> _sections = [];
  late bool _placesReady;
  late bool _accessible;
  late bool _filtersCreated;
  late MapViewer _mapViewer;
  int _previousTotalPlaces = 0;

  @override
  void initState() {
    print('=== MAP SCREEN INIT ===');
    _placesReady = false;
    _mapViewer = MapViewer();
    
    // Intentar cargar datos después de un breve delay si no están listos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_placesReady) {
        print('Retrying data load after delay...');
        _refreshMapData();
      }
    });
    
    // Sistema de retry más agresivo
    _startDataMonitoring();
    
    super.initState();
  }
  
  void _startDataMonitoring() {
    // Monitorear datos cada 1 segundo hasta que estén listos
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_placesReady || _filtersCreated) {
        timer.cancel();
        return;
      }
      
      // Forzar actualización del estado
      if (mounted) {
        setState(() {
          // Esto forzará didChangeDependencies a ejecutarse
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Provider.of<LanguageModel>(context);
    _cellars = Provider.of<CellarModel>(context).cellars;
    _restaurants = Provider.of<EatModel>(context).placesToEat;
    _experiences = Provider.of<ExperienceModel>(context).items;
    _guidedTours = Provider.of<GuidedToursModel>(context).tours;
    
    // Si está en inglés, usar lugares en inglés cuando estén disponibles
    final visitModel = Provider.of<VisitModel>(context);
    if (_language.english && 
        visitModel.placesCategories != null && 
        visitModel.placesCategories!.placesEn.isNotEmpty) {
      _places = visitModel.placesCategories!.placesEn;
    } else {
      _places = visitModel.placesToVisit;
    }
    
    // Usar rutas según el idioma
    if (_language.english) {
      _routes = Provider.of<RouteModel>(context).routesEn.isNotEmpty
          ? Provider.of<RouteModel>(context).routesEn
          : Provider.of<RouteModel>(context).routes;
    } else {
    _routes = Provider.of<RouteModel>(context).routes;
    }
    _routesEn = Provider.of<RouteModel>(context).routesEn;
    _events = Provider.of<ScheduleModel>(context).eventSchedule;
    _stores = Provider.of<ShopModel>(context).placesToShop;
    _hotels = Provider.of<SleepModel>(context).placesToRest;
    _sections = Provider.of<SectionModel>(context).items;
    _filtersCreated = Provider.of<MapModel>(context).filtersCreated;
    _accessible = Provider.of<AccessibleModel>(context).enabled;

    // Debug: Verificar qué datos están vacíos
    print('=== MAP DEBUG ===');
    print('Sections: ${_sections.length}');
    print('Cellars: ${_cellars.length}');
    print('Restaurants: ${_restaurants.length}');
    print('Experiences: ${_experiences.length}');
    print('Guided Tours: ${_guidedTours.length}');
    print('Places: ${_places.length}');
    print('Routes: ${_routes.length}');
    print('Routes EN: ${_routesEn.length}');
    print('Events: ${_events.length}');
    print('Stores: ${_stores.length}');
    print('Hotels: ${_hotels.length}');
    print('Filters Created: $_filtersCreated');
    print('Places Ready: $_placesReady');
    print('================');

    if (_sections.isNotEmpty) {
      // Check if at least some data is available instead of requiring all categories
      _placesReady = _places.isNotEmpty ||
          _restaurants.isNotEmpty ||
          _experiences.isNotEmpty ||
          _guidedTours.isNotEmpty ||
          _routes.isNotEmpty ||
          _events.isNotEmpty ||
          _stores.isNotEmpty ||
          _hotels.isNotEmpty ||
          _cellars.isNotEmpty;

      print('Places Ready: $_placesReady');
      
      // Calculate total places to detect if more data loaded
      int currentTotalPlaces = _places.length +
          _restaurants.length +
          _experiences.length +
          _guidedTours.length +
          _routes.length +
          _events.length +
          _stores.length +
          _hotels.length +
          _cellars.length;
      
      // If we have data but filters aren't created, create them immediately
      if (_placesReady && !_filtersCreated) {
        print('Data is ready but filters not created - creating now');
        _previousTotalPlaces = currentTotalPlaces;
        _createMapFilters();
      } 
      // If filters are already created but we have more data now, update them
      else if (_filtersCreated && _placesReady && currentTotalPlaces > _previousTotalPlaces) {
        print('More data available (${_previousTotalPlaces} -> $currentTotalPlaces) - updating filters');
        _previousTotalPlaces = currentTotalPlaces;
        _createMapFilters();
      }
      else if (!_placesReady) {
        print('No data available yet - waiting for data to load');
      } else if (_filtersCreated) {
        print('Filters already created - map should show markers');
      }

      // Additional debug to see which data is available
      print('Places (visit): ${_places.length}');
      print('Restaurants: ${_restaurants.length}');
      print('Experiences: ${_experiences.length}');
      print('Guided Tours: ${_guidedTours.length}');
      print('Routes: ${_routes.length}');
      print('Events: ${_events.length}');
      print('Stores: ${_stores.length}');
      print('Hotels: ${_hotels.length}');
      print('Cellars: ${_cellars.length}');
    } else {
      // Si no hay secciones, también verificar si hay datos disponibles
      _placesReady = _places.isNotEmpty ||
          _restaurants.isNotEmpty ||
          _experiences.isNotEmpty ||
          _guidedTours.isNotEmpty ||
          _routes.isNotEmpty ||
          _events.isNotEmpty ||
          _stores.isNotEmpty ||
          _hotels.isNotEmpty ||
          _cellars.isNotEmpty;
      
      print('No sections available, checking direct data: $_placesReady');
      
      if (_placesReady && !_filtersCreated) {
        print('Data available without sections - creating filters');
        _createMapFilters();
      }
    }

    // Create filters automatically when data is available
    if (!_filtersCreated && _sections.isNotEmpty) {
      // Check if we have any data at all
      bool hasAnyData = _places.isNotEmpty ||
          _restaurants.isNotEmpty ||
          _experiences.isNotEmpty ||
          _guidedTours.isNotEmpty ||
          _routes.isNotEmpty ||
          _events.isNotEmpty ||
          _stores.isNotEmpty ||
          _hotels.isNotEmpty ||
          _cellars.isNotEmpty;
      
      if (hasAnyData) {
        print('Creating filters automatically - data available');
        _createMapFilters();
      } else {
        print('No data available yet, will retry...');
        // Retry after a short delay if no data is available
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              // This will trigger didChangeDependencies again
            });
          }
        });
      }
    }
    
    // Forzar actualización si detectamos datos pero no filtros
    if (_placesReady && !_filtersCreated) {
      print('Data ready but no filters - forcing creation');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _createMapFilters();
        }
      });
    }
  }

  void _createMapFilters() {
    print('=== CREATING MAP FILTERS ===');
    print('Sections available: ${_sections.length}');
    print('Data summary:');
    print('  - Places: ${_places.length}');
    print('  - Restaurants: ${_restaurants.length}');
    print('  - Experiences: ${_experiences.length}');
    print('  - Guided Tours: ${_guidedTours.length}');
    print('  - Routes: ${_routes.length}');
    print('  - Events: ${_events.length}');
    print('  - Stores: ${_stores.length}');
    print('  - Hotels: ${_hotels.length}');
    print('  - Cellars: ${_cellars.length}');
    
    final mapPlaces = MapPlaces(
      cellars: _cellars,
      restaurants: _restaurants,
      experiences: _experiences,
      guidedTours: _guidedTours,
      places: _places,
      routes: _routes,
      routesEn: _routesEn,
      events: _events,
      stores: _stores,
      hotels: _hotels,
    );

    print('Creating MapPlaces with places: ${_places.length}');

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<MapModel>(
          context,
          listen: false,
        ).setFilters(
          _sections,
          mapPlaces,
        );
        // Force a rebuild after creating filters
        if (mounted) {
          setState(() {
            _placesReady = true;
            print('Map filters created and state updated');
          });
        }
      },
    );
  }

  void _refreshMapData() {
    print('Manual refresh triggered');
    _createMapFilters();
  }

  @override
  Widget build(BuildContext context) {
    final mapLabel = (_language.english)
        ? AppConstants.mapMenuLabelEn
        : AppConstants.mapMenuLabel;

    // Mostrar indicador de carga si los datos no están listos
    if (!_placesReady && _sections.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: DynamicTitle(value: mapLabel, accessible: _accessible),
          centerTitle: true,
          actions: ContentBuilder.getActions(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primary),
              ),
              const SizedBox(height: 16),
              Text(
                _language.english 
                    ? 'Loading map data...' 
                    : 'Cargando datos del mapa...',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppConstants.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Create floating action buttons
    List<Widget> floatingButtons = [];

    if (_filtersCreated) {
      floatingButtons.add(FilterButton());
    }

    // Always show refresh button with same style as FilterButton
    floatingButtons.add(
      SizedBox(height: 10), // Spacing between buttons
    );
    floatingButtons.add(
      FloatingActionButton(
        onPressed: _refreshMapData,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.borderRadius),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        tooltip: _language.english
            ? 'Refresh map data'
            : 'Actualizar datos del mapa',
        child: const Icon(
          Icons.refresh,
          color: Color.fromRGBO(4, 134, 170, 1),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: DynamicTitle(value: mapLabel, accessible: _accessible),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      extendBody: false,
      body: _mapViewer,
      floatingActionButton: floatingButtons.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(
                  top: 100), // Mover más abajo desde la parte superior
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: floatingButtons,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
