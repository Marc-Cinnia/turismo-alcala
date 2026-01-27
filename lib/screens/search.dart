import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/food_item.dart';
import 'package:valdeiglesias/dtos/store.dart';
import 'package:valdeiglesias/dtos/hotel.dart';
import 'package:valdeiglesias/dtos/route_item.dart';
import 'package:valdeiglesias/dtos/experience_item.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
// import 'package:valdeiglesias/widgets/wishlist_button.dart'; // COMENTADO: Funcionalidad de estrella deshabilitada
import 'package:valdeiglesias/screens/place_detail.dart';
import 'package:valdeiglesias/screens/cellar_detail.dart';
import 'package:valdeiglesias/screens/guided_tours_detail.dart';
import 'package:valdeiglesias/screens/eat_detail.dart';
import 'package:valdeiglesias/screens/shop_detail.dart';
import 'package:valdeiglesias/screens/sleep_detail.dart';
import 'package:valdeiglesias/screens/route_detail.dart';
import 'package:valdeiglesias/screens/experience_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Place> _getAllPlaces() {
    try {
      // Obtener el idioma actual
      final language = context.read<LanguageModel>();
      
    // Obtener todos los datos de los modelos
    final visitModel = context.read<VisitModel>();
    final eatModel = context.read<EatModel>();
    final sleepModel = context.read<SleepModel>();
    final shopModel = context.read<ShopModel>();
    final routeModel = context.read<RouteModel>();
    final experienceModel = context.read<ExperienceModel>();
    final scheduleModel = context.read<ScheduleModel>();
    final cellarModel = context.read<CellarModel>();
    final guidedToursModel = context.read<GuidedToursModel>();

      // Si está en inglés, usar los lugares en inglés cuando estén disponibles
      List<Place> visitPlaces = visitModel.placesToVisit;
      if (language.english && 
          visitModel.placesCategories != null && 
          visitModel.placesCategories!.placesEn.isNotEmpty) {
        try {
          visitPlaces = visitModel.placesCategories!.placesEn;
        } catch (e) {
          print('Error al obtener lugares en inglés: $e');
          // Si hay error, usar los lugares en español como fallback
          visitPlaces = visitModel.placesToVisit;
        }
      }

      // Si está en inglés, usar las rutas en inglés cuando estén disponibles
      List<Place> routes = routeModel.routes;
      if (language.english && routeModel.routesEn.isNotEmpty) {
        routes = routeModel.routesEn;
      }

      // Si está en inglés, usar los eventos en inglés cuando estén disponibles
      List<Place> events = scheduleModel.getEventsByLanguage(language.english);

    return [
        ...visitPlaces,
      ...eatModel.placesToEat,
      ...sleepModel.placesToRest,
      ...shopModel.placesToShop,
        ...routes,
      ...experienceModel.items,
        ...events,
      ...cellarModel.cellars,
      ...guidedToursModel.tours,
    ];
    } catch (e) {
      print('Error en _getAllPlaces: $e');
      // Retornar lista vacía en caso de error para evitar crashes
      return [];
    }
  }

  /// Filtra los lugares según el idioma actual
  /// En inglés, solo muestra lugares con contenido en inglés válido
  List<Place> _filterPlacesByLanguage(List<Place> places, LanguageModel language) {
    if (language.english) {
      return places.where((place) {
        final titleEn = place.placeNameEn.trim();
        final descriptionEn = place.shortDescriptionEn?.trim() ?? '';
        
        // Si estamos usando placesEn de la API en inglés, esos lugares ya tienen contenido válido
        // Mostrar si tiene al menos título o descripción en inglés
        // No filtrar por si titleEn == titleEs porque pueden venir de la API en inglés
        return titleEn.isNotEmpty || descriptionEn.isNotEmpty;
      }).toList();
    }
    // En español, mostrar todos
    return places;
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.trim().isEmpty) {
      // Si no hay búsqueda, limpiar resultados
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Obtener el idioma actual
    final language = context.read<LanguageModel>();
    
    // Obtener todos los lugares actuales y filtrar por idioma
    final allPlaces = _getAllPlaces();
    final filteredByLanguage = _filterPlacesByLanguage(allPlaces, language);

    // Filtrar resultados según la búsqueda
    final filteredResults = filteredByLanguage.where((place) {
      final queryLower = query.toLowerCase();
      
      if (language.english) {
        // Si está en inglés, buscar solo en campos en inglés
        final titleEn = place.placeNameEn.toLowerCase();
        final descriptionEn = place.shortDescriptionEn?.toLowerCase() ?? '';
        
        return titleEn.contains(queryLower) || 
               descriptionEn.contains(queryLower);
      } else {
        // Si está en español, buscar solo en campos en español
        final title = place.placeName.toLowerCase();
        final description = place.shortDescription?.toLowerCase() ?? '';
      
      return title.contains(queryLower) || 
               description.contains(queryLower);
      }
    }).toList();

    setState(() {
      _searchResults = filteredResults;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final searchLabel = language.english ? 'Search' : 'Buscar';
    final searchHint = language.english ? 'Search in all content...' : 'Buscar en todo el contenido...';
    final noResultsLabel = language.english ? 'No results found' : 'No se encontraron resultados';
    final resultsLabel = language.english ? 'Results' : 'Resultados';

    return Scaffold(
      appBar: AppBar(
        title: Text(searchLabel),
        backgroundColor: const Color.fromRGBO(4, 134, 170, 1),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
        actions: ContentBuilder.getActions(),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color:  Color.fromRGBO(0, 0, 0, 1), // Color del texto que escribes
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: const TextStyle(
                  color: Colors.grey, // Color del texto de sugerencia
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _performSearch,
            ),
          ),
          
          // Resultados
          Expanded(
            child: _buildResults(language, noResultsLabel, resultsLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(LanguageModel language, String noResultsLabel, String resultsLabel) {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Si no hay búsqueda, mostrar todos los lugares usando Consumer
    if (_searchQuery.isEmpty) {
      return Consumer<VisitModel>(
        builder: (context, visitModel, child) {
          final allPlaces = _getAllPlaces();
          final filteredPlaces = _filterPlacesByLanguage(allPlaces, language);
          
          if (filteredPlaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    language.english 
                        ? 'Loading places...' 
                        : 'Cargando lugares...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  (language.english ? 'All places' : 'Todos los lugares') + ' (${filteredPlaces.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Agregar padding inferior para el menú
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return _buildSearchResultItem(place, language);
                  },
                ),
              ),
            ],
          );
        },
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              noResultsLabel,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              language.english 
                  ? 'Try different keywords' 
                  : 'Prueba con palabras diferentes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _searchQuery.isEmpty 
                ? (language.english ? 'All places' : 'Todos los lugares') + ' (${_searchResults.length})'
                : '$resultsLabel (${_searchResults.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.primary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Agregar padding inferior para el menú
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final place = _searchResults[index];
              return _buildSearchResultItem(place, language);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(Place place, LanguageModel language) {
    // Obtener el nombre del lugar según el idioma
    final placeName = language.english ? place.placeNameEn : place.placeName;
    
    // Obtener la descripción según el idioma
    String description = '';
    if (language.english) {
      description = place.shortDescriptionEn ?? place.shortDescription ?? '';
    } else {
      description = place.shortDescription ?? '';
    }

    return Card(
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardSpacing),
        child: Row(
          children: [
            // Imagen a la izquierda
            GestureDetector(
              onTap: () => _navigateToPlace(place, language),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.thumbnailBorderRadius),
                child: place.mainImageUrl != null
                    ? SuperNetworkImage(
                        url: place.mainImageUrl!,
                        width: AppConstants.thumbnailWidth,
                        height: AppConstants.thumbnailHeight,
                        fit: BoxFit.cover,
                        placeholderBuilder: () => Center(
                          child: LoaderBuilder.getLoader(),
                        ),
                      )
                    : Container(
                        width: AppConstants.thumbnailWidth,
                        height: AppConstants.thumbnailHeight,
                        color: AppConstants.primary,
                        child: Icon(
                          _getIconForPlace(place),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
              ),
            ),
            // Contenido de texto
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToPlace(place, language),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.cardSpacing,
                    right: AppConstants.cardSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.shortSpacing),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Botón de wishlist - COMENTADO: Funcionalidad de estrella deshabilitada
            /*
            WishlistButton(
              place: place,
              isTextButton: false,
            ),
            */
          ],
        ),
      ),
    );
  }

  IconData _getIconForPlace(Place place) {
    // Determinar el icono basado en el tipo de lugar
    if (place.placeType == 'eat') return Icons.restaurant;
    if (place.placeType == 'sleep') return Icons.hotel;
    if (place.placeType == 'shop') return Icons.shopping_bag;
    if (place.placeType == 'route') return Icons.route;
    if (place.placeType == 'experience') return Icons.star;
    if (place.placeType == 'event') return Icons.event;
    if (place.placeType == 'cellar') return Icons.wine_bar;
    if (place.placeType == 'tour') return Icons.tour;
    return Icons.place;
  }

  void _navigateToPlace(Place place, LanguageModel language) {
    // Navegar al detalle del lugar usando el widget específico según el tipo
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _buildDetailPage(place, language),
      ),
    );
  }

  Widget _buildDetailPage(Place place, LanguageModel language) {
    // Usar el detalle específico según el tipo de lugar para mostrar horarios
    switch (place.placeType) {
      case 'cellar':
        return CellarDetail(
          cellar: place,
        );
      case 'guided_tours':
        return GuidedToursDetail(
          tour: place,
          tourEn: place,
          accessible: false,
        );
      case 'eat':
        return EatDetail(
          item: place as FoodItem,
          accessible: false,
        );
      case 'shop':
        return ShopDetail(
          item: place as Store,
          accessible: false,
        );
      case 'sleep':
        return SleepDetail(
          item: place as Hotel,
          accessible: false,
        );
      case 'route':
        return RouteDetail(
          route: place as RouteItem,
          routeEn: place as RouteItem,
          accessible: false,
        );
      case 'exp':
        return ExperienceDetail(
          experience: place as ExperienceItem,
          experienceEn: place as ExperienceItem,
          accessible: false,
        );
      default:
        // Para otros tipos, usar PlaceDetail genérico
        return PlaceDetail(
          place: place,
          placeEn: place,
          accessible: false,
        );
    }
  }



}
