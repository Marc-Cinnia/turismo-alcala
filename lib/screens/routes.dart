import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/no_results_placeholder.dart';
import 'package:valdeiglesias/widgets/route_filter_dialog.dart';
import 'package:valdeiglesias/widgets/route_list.dart';
import 'package:valdeiglesias/widgets/route_category_filter.dart';

class Routes extends StatefulWidget {
  Routes({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  late bool _noResults;
  late bool _filtersApplied;
  late Widget _routes;
  late bool _categorySelected;

  @override
  void initState() {
    super.initState();
    _noResults = false;
    _filtersApplied = false;
    _categorySelected = false;
    _routes = const SizedBox();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _noResults = Provider.of<RouteModel>(context).noResults;
    _filtersApplied = Provider.of<RouteModel>(context).filtersApplied;
    // Verificar si se ha hecho una selección (incluyendo "All")
    final routeModel = Provider.of<RouteModel>(context);
    _categorySelected = routeModel.filtersApplied;

    // Solo mostrar rutas si se ha seleccionado una categoría
    if (_categorySelected) {
      if (_noResults && _filtersApplied) {
        _routes = NoResultsPlaceholder();
      } else {
        _routes = RouteList(accessible: widget.accessible);
      }
    } else {
      // Mostrar mensaje de selección de categoría
      _routes = _buildCategorySelectionMessage();
    }
  }

  Widget _buildCategorySelectionMessage() {
    return const SizedBox(); // No mostrar mensaje, solo el filtro
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final spacer = const SizedBox(height: AppConstants.spacing);

    final filterButton = OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(
            Icons.filter_list_outlined,
            color: AppConstants.primary,
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return RouteFilterDialog();
              },
            );
          },
        ),
      ],
    );

    String title = (language.english)
        ? AppConstants.routesTitleEn
        : AppConstants.routesTitle;

    String description = (language.english)
        ? AppConstants.routesDescriptionEn
        : AppConstants.routesDescription;

    final descText = Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacing,
        left: AppConstants.spacing,
        right: AppConstants.spacing,
      ),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: title, accessible: widget.accessible),
        actions: ContentBuilder.getActions(),
      ),
      body: _categorySelected 
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacing),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  descText,
                  spacer,
                  filterButton,
                  spacer,
                  _routes,
                ],
              ),
            ),
          )
        : Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RouteCategoryFilter(),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
