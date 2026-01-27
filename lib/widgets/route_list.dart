import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/screens/route_detail.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
// import 'package:valdeiglesias/widgets/wishlist_button.dart'; // COMENTADO: Funcionalidad de estrella deshabilitada

class RouteList extends StatefulWidget {
  const RouteList({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  late Widget _content;
  late Set<RouteItem> _filteredRoutes;
  late Set<RouteItem> _filteredRoutesEn;

  @override
  void initState() {
    super.initState();
    _filteredRoutesEn = {};
    _filteredRoutes = {};
    _content = const SizedBox();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filteredRoutesEn = Provider.of<RouteModel>(context).filteredRoutesEn;
    _filteredRoutes = Provider.of<RouteModel>(context).filteredRoutes;
    _setRoutes();
  }

  bool get _isEnglish {
    final language = Provider.of<LanguageModel>(context, listen: true);
    return language.english;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(child: _content);

  void _setRoutes() {
    final routeModel = Provider.of<RouteModel>(context, listen: false);
    final language = Provider.of<LanguageModel>(context, listen: false);
    
    // Si está en inglés, solo verificar _filteredRoutesEn
    // Si está en español, solo verificar _filteredRoutes
    final routesToCheck = _isEnglish ? _filteredRoutesEn : _filteredRoutes;
    final isEmpty = routesToCheck.isEmpty;
    
    // Si ya terminó de cargar y no hay rutas, mostrar mensaje
    if (routeModel.hasFinishedLoading && isEmpty) {
      _content = Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.route,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                language.english
                    ? 'No routes available'
                    : 'No hay rutas disponibles',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                language.english
                    ? 'There are no routes available for the selected filters'
                    : 'No hay rutas disponibles para los filtros seleccionados',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (isEmpty) {
      // Si aún está cargando, mostrar loader
      _content = Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
        child: LoaderBuilder.getLoader(),
      ));
    } else {
      _content = _getContent();
    }
  }

  Column _getContent() {
    // Usar las rutas correctas según el idioma
    final routesToShow = (_isEnglish && _filteredRoutesEn.isNotEmpty) 
        ? _filteredRoutesEn.toList() 
        : _filteredRoutes.toList();
    
    return Column(
      children: List.generate(
        routesToShow.length,
        (index) {
          final route = routesToShow[index];
          // Para el detalle, intentar obtener el correspondiente de la otra lista
          final routeEn = (index < _filteredRoutesEn.length) 
              ? _filteredRoutesEn.elementAt(index) 
              : route;
          final routeEs = (index < _filteredRoutes.length) 
              ? _filteredRoutes.elementAt(index) 
              : route;
          final thumbnailImage = (widget.accessible)
              ? const SizedBox()
              : GestureDetector(
                  onTap: () => _showDetail(context, routeEs, routeEn),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.thumbnailBorderRadius,
                    ),
                    child: Image(
                      width: AppConstants.thumbnailWidth,
                      height: AppConstants.thumbnailHeight,
                      image: NetworkImage(route.mainImageUrl!),
                      fit: BoxFit.fitHeight,
                    ),
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
              // : WishlistButton( // COMENTADO: Funcionalidad de estrella deshabilitada
              /*
              : WishlistButton(
                  place: route,
                  isTextButton: false,
                );
              */
              : const SizedBox(); // Widget vacío como reemplazo

          final descriptionSection = (widget.accessible)
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing,
                    left: AppConstants.spacing,
                    right: AppConstants.spacing,
                  ),
                  child: Text(
                    route.shortDescription!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );

          return Card(
            color: AppConstants.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: SizedBox(
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
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AppConstants.spacing,
                                  left: AppConstants.spacing,
                                  right: AppConstants.spacing,
                                ),
                                child: Text(
                                  route.placeName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppConstants.primary,
                                      ),
                                ),
                              ),
                              const SizedBox(height: AppConstants.shortSpacing),
                              descriptionSection,
                            ],
                          ),
                        ),
                        onTap: () => _showDetail(context, routeEs, routeEn),
                      ),
                    ),
                    actionsSection,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, RouteItem route, RouteItem routeEn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RouteDetail(
          route: route,
          routeEn: routeEn,
          accessible: widget.accessible,
        ),
      ),
    );
  }
}
